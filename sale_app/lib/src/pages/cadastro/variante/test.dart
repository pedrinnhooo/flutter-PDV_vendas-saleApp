import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:http/http.dart' as http;

class TesteAmazonS3 extends StatefulWidget {
  TesteAmazonS3({Key key}) : super(key: key);

  @override
  _TesteAmazonS3State createState() => _TesteAmazonS3State();
}

class _TesteAmazonS3State extends State<TesteAmazonS3> {
  var progress;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("TESTE AMAZONNN"),),
        body: Container(
          color: Colors.orangeAccent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CachedNetworkImage(
                imageUrl: "https://fluggy-images.s3-sa-east-1.amazonaws.com/u8kl9gr9gbk31111.png",
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
                imageBuilder: (context, imageProvider){
                  return Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.fill,
                      )
                    ),
                  );
                },
              ),
              Container(
                alignment: Alignment.center,
                width: 200,
                height: 100,
                color: Colors.black,
                child: Text("$progress", style: TextStyle(color: Colors.white),),
              ),

              FlatButton(
                onPressed: amazon,
                color: Colors.redAccent,
                child: Text("DOWNLOAD AMAZONN"),
              )
            ],
          ),
        ),
    );
  }

  criaDiretorio() async {
    List foldersList = ["variante/", "produto/",];
    String directory = (await getApplicationDocumentsDirectory()).path;

    for(int i=0; i < foldersList.length; i++){
      if (await Directory(directory + "/s3/"+foldersList[i]).exists() != true) {
        print("Diretório não existe.. criando");
        Directory(directory + "/s3/"+foldersList[i]).createSync(recursive: true);
        print("######### CRIADO #########");
      } else {
        print("Diretório já existe, ignorado");
      }
    }
  }

  Future<void> saveImage() async {
    Dio dio = Dio();
    List<String> imagesList = [
      "https://fluggy-images.s3-sa-east-1.amazonaws.com/variante/u8kl9gr9gbk31111.png",
      "https://fluggy-images.s3-sa-east-1.amazonaws.com/produto/coca_cola_101020171594836481.png"
    ];
    var directory = (await getApplicationDocumentsDirectory()).path;
    String folder = "";

    imagesList.forEach((imagem) async {
      await dio.download(imagem,
      """$directory/s3/${imagem.contains("/variante/") ? folder = "variante" : folder = "produto"}/teste.png""", onReceiveProgress: (rec, total) {
        setState(() {
          progress = ((rec / total) * 100).toStringAsFixed(0) + "%";
        });
      });
    });

    try {} catch (e) {
      throw e;
    }
    setState(() {
      progress = "Completo";
    });
  }

  amazon() async {
    String directory = (await getApplicationDocumentsDirectory()).path;
    File file = File("$directory/s3/produto/teste.png");
    upload(file);
  }

  upload(File imageFile) async {    
    var stream = new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();

    var uri = Uri.parse('https://fluggy-images.s3-sa-east-1.amazonaws.com/');

    var request = new http.MultipartRequest("POST", uri);
    request.fields['key'] = 'images/produto/1/zuma.png';
    var multipartFile = new http.MultipartFile('file', stream, length,
          filename: basename(imageFile.path));
          //contentType: new MediaType('image', 'png'));

      request.files.add(multipartFile);
      var response = await request.send();
      print(response.statusCode);
      response.stream.transform(utf8.decoder).listen((value) {
        print(value);
      });
    }
}