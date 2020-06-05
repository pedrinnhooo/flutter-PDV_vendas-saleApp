import 'dart:convert';
import 'dart:io';

import 'package:amazon_cognito_identity_dart/sig_v4.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:common_files/src/bloc/hasura_bloc.dart';
import 'package:common_files/src/model/entities/cadastro/variante/variante.dart';
import 'package:common_files/src/model/entities/cadastro/variante/varianteDao.dart';
import 'package:common_files/src/utils/constants.dart';
import 'package:common_files/src/utils/policy.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:http/http.dart' as http;

class VarianteBloc extends BlocBase {
  HasuraBloc _hasuraBloc;
  Variante variante;
  VarianteDAO varianteDAO;
  String filtroNome="";
  bool nomeInvalido = false, formInvalido = false;
  Color corVariante = Colors.grey;
  File imagem = null;

  List<Variante> varianteList = [];

  BehaviorSubject<List<Variante>> varianteListController;
  Observable<List<Variante>> get varianteListOut => varianteListController.stream;
  BehaviorSubject<Variante> varianteController;
  Observable<Variante> get varianteOut => varianteController.stream;
  BehaviorSubject<bool> nomeInvalidoController;
  Observable<bool> get nomeInvalidoOut => nomeInvalidoController.stream;
  BehaviorSubject<Color> corController;
  Observable<Color> get corVarianteOut => corController.stream;
  BehaviorSubject<File> imagemController;
  Observable<File> get imagemOut => imagemController.stream;

  VarianteBloc(this._hasuraBloc){
    variante = Variante();
    varianteDAO = VarianteDAO(_hasuraBloc,variante: variante);
    varianteListController = BehaviorSubject.seeded(varianteList);
    varianteController = BehaviorSubject.seeded(variante);
    nomeInvalidoController = BehaviorSubject.seeded(nomeInvalido);
    corController = BehaviorSubject.seeded(corVariante);
    imagemController = BehaviorSubject.seeded(imagem);
  }

  getAllVariante() async {
    Variante _variante = Variante();
    VarianteDAO _varianteDAO = VarianteDAO(_hasuraBloc, variante: _variante);
    varianteList = await _varianteDAO.getAllFromServer(id: true, filtroNome: filtroNome,
                                                      dataCadastro: true, dataAtualizacao: true);
    varianteListController.add(varianteList);
  }

  getVarianteById(int id) async {
    Variante _variante = Variante();
    VarianteDAO _varianteDAO = VarianteDAO(_hasuraBloc, variante: _variante);
    variante = await _varianteDAO.getByIdFromServer(id);
    
    varianteController.add(variante);
  }

  setCorVariante(Color cor){
    corVariante = cor;
    corController.add(corVariante);
  }

  newVariante() async {
    variante = Variante();
    variante.nome = "";
    varianteController.add(variante);
  }

  saveVariante() async  {
    variante.dataCadastro = variante.dataCadastro == null ? DateTime.now() : variante.dataCadastro;
    variante.possuiImagem = imagem != null ? 1 : 0;
    variante.dataAtualizacao = DateTime.now();
    VarianteDAO varianteDAO = VarianteDAO(_hasuraBloc, variante: variante);
    variante = await varianteDAO.saveOnServer();
    if(variante.possuiImagem == 1){
      await uploadImageToServer(imagem);
      await deleteImagem();
    }
    await getAllVariante();
    await resetBloc();
  }

  deleteVariante() async {
    variante.ehDeletado = 1; 
    variante.dataAtualizacao = DateTime.now();
    VarianteDAO _varianteDAO = VarianteDAO(_hasuraBloc, variante: variante);
    variante = await _varianteDAO.saveOnServer();
    await deleteImageFromServer();
    await resetBloc();
  }

  validaNome() {
    nomeInvalido = variante.nome == "" ? true : false;
    formInvalido = nomeInvalido;
    nomeInvalidoController.add(nomeInvalido);
  }

  updateStream(){
    varianteListController.add(varianteList);
  }
  
  setImagem(File path){
    imagem = path;
    variante.possuiImagem = 1;
    imagemController.add(imagem);
    varianteController.add(variante);
  }

  deleteImagem() async{
    imagem = null;
    variante.possuiImagem = 0;
    var appDir = (await getTemporaryDirectory()).path;
    Directory(appDir).delete(recursive: true);
    imagemController.add(imagem);
    varianteController.add(variante);
  }

  limpaValidacoes(){
    nomeInvalido = false;
    imagem = null;
    nomeInvalidoController.add(nomeInvalido);
  }

  resetBloc() async  {
    variante = Variante();
    varianteController.add(variante);
  }

  uploadImageToServer(File imageFile) async {
    final stream = http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    final length = await imageFile.length();
    final uri = Uri.parse(s3Endpoint);
    final req = http.MultipartRequest("POST", uri);
    final multipartFile = http.MultipartFile('file', stream, length, filename: basename(imageFile.path));
    final policy = Policy.fromS3PresignedPost('images/variante/1/${variante.id}.png','fluggy-images', accessKeyId, 15, length, region: region);
    final key = SigV4.calculateSigningKey(secretKeyId, policy.datetime, region, 's3');
    final signature = SigV4.calculateSignature(key, policy.encode()); 

    req.files.add(multipartFile);
    req.fields['key'] = policy.key;
    req.fields['acl'] = 'public-read';
    req.fields['X-Amz-Credential'] = policy.credential;
    req.fields['X-Amz-Algorithm'] = 'AWS4-HMAC-SHA256';
    req.fields['X-Amz-Date'] = policy.datetime;
    req.fields['Policy'] = policy.encode();
    req.fields['X-Amz-Signature'] = signature;

    try {
      final response = await req.send();
      print(response.statusCode);
      if(response.statusCode == 204){
        print("POST Efetuado com sucesso.");
      } 
      await for (var value in response.stream.transform(utf8.decoder)) {
        print(value);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  deleteImageFromServer() async {
    final datetime = SigV4.generateDatetime();
    final hashedPayload = SigV4.hashCanonicalRequest('');
    final credentialScope = SigV4.buildCredentialScope(datetime, region, 's3');
    final canonicalRequest = '''DELETE
/images/variante/1/${variante.id}.png

host:fluggy-images.s3-sa-east-1.amazonaws.com
x-amz-content-sha256:$hashedPayload
x-amz-date:$datetime

host;x-amz-content-sha256;x-amz-date
$hashedPayload''';
    final stringToSign = SigV4.buildStringToSign(datetime, credentialScope, SigV4.hashCanonicalRequest(canonicalRequest));   
    final signingKey = SigV4.calculateSigningKey(secretKeyId, datetime, region, 's3');
    final signature = SigV4.calculateSignature(signingKey, stringToSign);
    final authorization = [
      'AWS4-HMAC-SHA256 Credential=$accessKeyId/$credentialScope',
      'SignedHeaders=host;x-amz-content-sha256;x-amz-date',
      'Signature=$signature',
    ].join(',');

    // print("#############");
    // print('CACONICAL REQUEST: '+canonicalRequest);
    // print("HASHED PAYLOAD: "+ hashedPayload);
    // print("STRING TO SIGN: "+stringToSign);
    // print("AUTHORIZATION: "+ authorization);
    // print("SIGNATURE: "+signature);
    // print("&&&&&&&&&&&&&&&");

    final uri = Uri.https('fluggy-images.s3-sa-east-1.amazonaws.com', '/images/variante/1/${variante.id}.png');
    http.Response response;
    try {
      response = await http.delete(uri, headers: {
        "Host": "fluggy-images.s3-sa-east-1.amazonaws.com",
        "X-Amz-Content-Sha256": "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855",
        "X-Amz-Date": datetime,
        "Authorization": authorization, 
        "Content-Length": "0",
        "Connection": "keep-alive",
        "cache-control": "no-cache"
      });
      print(response.body);
      if(response.statusCode == 204){
        print("DELETE Efetuado com sucesso.");
      }
    } catch (e) {
      print(e.toString());
    }
  }
  
  @override
  void dispose() {
    varianteListController.close();
    varianteController.close();
    nomeInvalidoController.close();
    imagemController.close();
    super.dispose();
  }
}
