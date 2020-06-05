import 'dart:io';
import 'package:common_files/common_files.dart';
import 'package:flutter_bluetooth_basic/flutter_bluetooth_basic.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:ping_discover_network/ping_discover_network.dart';
import 'package:wifi/wifi.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

class ImpressoraBloc extends BlocBase {
  int offset = 0;
  int port = 9100;
  String filtroNome = "";
  HasuraBloc _hasuraBloc;
  bool formInvalido = true;
  AppGlobalBloc _appGlobalBloc;
  TextEditingController portController = TextEditingController(text: '9100');
  PrinterBluetoothManager printerManager;
  TextEditingController nomeTextEditingController;
  TextEditingController ipTextEditingController;
  TextEditingController macAddressTextEditingController;
  TextEditingController textoCabecalhoController;
  TextEditingController textoRodapeController;

  bool nomeInvalido = false;
  BehaviorSubject<bool> nomeInvalidoController;
  Stream<bool> get nomeInvalidoOut => nomeInvalidoController.stream;
  
  bool macInvalido = false;
  BehaviorSubject<bool> macInvalidoController;
  Stream<bool> get macInvalidoOut => macInvalidoController.stream;

  bool ipInvalido = false;
  BehaviorSubject<bool> ipInvalidoController;
  Stream<bool> get ipInvalidoOut => ipInvalidoController.stream;

  bool testeConexao = false;
  BehaviorSubject<bool> testeConexaoController;
  Stream<bool> get testeConexaoOut => testeConexaoController.stream;

  TerminalImpressora terminalImpressora;
  BehaviorSubject<TerminalImpressora> terminalImpressoraController;
  Stream<TerminalImpressora> get impressoraOut => terminalImpressoraController.stream;

  List<TerminalImpressora> terminalImpressoraList = [];
  BehaviorSubject<List<TerminalImpressora>> terminalImpressoraListController;
  Stream<List<TerminalImpressora>> get impressoraListOut => terminalImpressoraListController.stream;

  BluetoothDevice printer;
  BehaviorSubject<BluetoothDevice> printerController;
  Stream<BluetoothDevice> get printerOut => printerController.stream;

  List<PrinterBluetooth> _impressoraBluetoothList = [];
  BehaviorSubject<List<PrinterBluetooth>> impressoraBluetoothListController;
  Stream<List<PrinterBluetooth>> get impressoraBluetoothListOut  => impressoraBluetoothListController.stream; 

  NetworkAnalyzer networkAnalyzer;
  BehaviorSubject networkScanController;
  Stream get networkScan => networkScanController.stream;
  
  String localIp = '';
  BehaviorSubject<String> localIpController;
  Stream<String> get localIpOut => localIpController.stream;

  bool pesquisando = false;
  BehaviorSubject<bool> pesquisaController;
  Stream<bool> get pesquisaOut => pesquisaController.stream;

  ImpressoraBloc(this._hasuraBloc, this._appGlobalBloc){
    printerManager = PrinterBluetoothManager();
    nomeInvalidoController = BehaviorSubject.seeded(nomeInvalido);
    macInvalidoController = BehaviorSubject.seeded(macInvalido);
    ipInvalidoController = BehaviorSubject.seeded(ipInvalido);
    testeConexaoController = BehaviorSubject.seeded(testeConexao);
    impressoraBluetoothListController = BehaviorSubject.seeded(_impressoraBluetoothList);
    localIpController = BehaviorSubject.seeded(localIp);
    networkScanController = BehaviorSubject.seeded(networkAnalyzer);
    terminalImpressoraListController = BehaviorSubject.seeded(terminalImpressoraList);
    pesquisaController = BehaviorSubject.seeded(pesquisando);
    terminalImpressora = TerminalImpressora();
    terminalImpressoraController = BehaviorSubject.seeded(terminalImpressora);
    printerController = BehaviorSubject.seeded(printer);
    nomeTextEditingController = TextEditingController();
    ipTextEditingController = TextEditingController();
    macAddressTextEditingController = TextEditingController();
    textoCabecalhoController = TextEditingController();
    textoRodapeController = TextEditingController();
  }

  setImpressora(TerminalImpressora _terminalImpressora){
    terminalImpressora = _terminalImpressora;
    nomeTextEditingController.text = nomeTextEditingController.text != "" ? nomeTextEditingController.text : terminalImpressora.ip;
    ipTextEditingController.text = terminalImpressora.ip;
    terminalImpressoraController.add(terminalImpressora);
  }

  setImpressoraBluetooth(PrinterBluetooth _printerBluetooth){
    TerminalImpressora _terminalImpressora = TerminalImpressora(
      nome: _printerBluetooth.name,
      macAddress: _printerBluetooth.address,
    );
    terminalImpressora = _terminalImpressora;
    nomeTextEditingController.text = nomeTextEditingController.text != "" ? nomeTextEditingController.text : terminalImpressora.nome;
    terminalImpressoraController.add(terminalImpressora);
  }

  getAllImpressora() async {
    TerminalImpressora _terminalImpressora = TerminalImpressora();
    TerminalImpressoraDAO configuracaoImpressoraDao = TerminalImpressoraDAO(_hasuraBloc, _terminalImpressora, _appGlobalBloc);
    terminalImpressoraList = await configuracaoImpressoraDao.getAllFromServer(id: true, macAddress: true, ip: true, tipoImpressora: true, dataCadastro: true);
    terminalImpressoraListController.add(terminalImpressoraList);
  }

  getImpressoraById(int id) async {
    TerminalImpressora _terminalImpressora = TerminalImpressora();
    TerminalImpressoraDAO _configuracaoImpressoraDao = TerminalImpressoraDAO(_hasuraBloc, _terminalImpressora, _appGlobalBloc);
    terminalImpressora = await _configuracaoImpressoraDao.getByIdFromServer(id);
    terminalImpressoraController.add(terminalImpressora);
  }

  newImpressora(){
    terminalImpressora = TerminalImpressora();
    terminalImpressoraController.add(terminalImpressora);
  }

  saveImpressora() async  {
    terminalImpressora.idTerminal = 0;
    terminalImpressora.ehDeletado = 0;
    terminalImpressora.dataCadastro = terminalImpressora.dataCadastro == null ? DateTime.now() : terminalImpressora.dataCadastro;
    terminalImpressora.dataAtualizacao = DateTime.now();
    TerminalImpressoraDAO _configuracaoImpressoraDao = TerminalImpressoraDAO(_hasuraBloc, terminalImpressora, _appGlobalBloc);
    terminalImpressora = await _configuracaoImpressoraDao.saveOnServer();
    offset = 0;
    await getAllImpressora();
    await resetBloc();
  }

  deleteImpressora() async {
    terminalImpressora.ehDeletado = 1; 
    terminalImpressora.dataAtualizacao = DateTime.now();
    TerminalImpressoraDAO _configuracaoImpressoraDao = TerminalImpressoraDAO(_hasuraBloc, terminalImpressora, _appGlobalBloc);
    terminalImpressora = await _configuracaoImpressoraDao.saveOnServer();
    await resetBloc();
  }

  Future _runDelayed(int seconds) {
    return Future<dynamic>.delayed(Duration(seconds: seconds));
  }

  setCupomImpressora(CupomLayout cupomLayout) async {
    terminalImpressora.idCupomLayout = cupomLayout.id;
    terminalImpressora.cupomLayout = cupomLayout;
    terminalImpressoraController.add(terminalImpressora);
  }

  getlocalIp() async {
    try {
      localIp = await Wifi.ip;
      scanNetwork();
    } catch (e) {
      print('WiFi não está conectado, verifique a sua conexão.');
      return;
    }
  }

  scanNetwork() async {
    final String subnet = localIp.substring(0, localIp.lastIndexOf('.'));
    port = 9100;
    try {
      port = int.parse(portController.text);
    } catch (e) {
      portController.text = port.toString();
    }
    final networkStream = NetworkAnalyzer.discover2(subnet, port);
    networkStream.listen((NetworkAddress address) {
      pesquisando = true;
      pesquisaController.add(pesquisando);
      if (address.exists) {
        terminalImpressora = TerminalImpressora(
          nome: address.ip,
          ip: address.ip
        );
        terminalImpressoraList.add(terminalImpressora);
        terminalImpressoraListController.add(terminalImpressoraList);
        pesquisando = false;
        pesquisaController.add(pesquisando);
      }
    })..onDone(() {
      pesquisando = false;
      pesquisaController.add(pesquisando);
    })..onError((dynamic e) { 
      print("Error"); 
    });
  }

  scanBluetoothDevices() async {
    printerManager.startScan(Duration(seconds: 5));
    _runDelayed(5).then((onValue) async {
      printerManager.stopScan();
    });
    printerManager.scanResults.listen((_impressoraList) async {
      pesquisando = true;
      pesquisaController.add(pesquisando);

      if(_impressoraList.length > 0){
        pesquisando = false;
        pesquisaController.add(pesquisando);
        _impressoraBluetoothList = [];
        _impressoraBluetoothList.addAll(_impressoraList);
        impressoraBluetoothListController.add(_impressoraBluetoothList);
      } else {
        pesquisando = false;
        pesquisaController.add(pesquisando);
        printerManager.stopScan();
      }
    })..onDone(() async {
      pesquisando = false;
      pesquisaController.add(pesquisando);
      printerManager.stopScan();
    })..onError((dynamic e) async { 
      pesquisando = false;
      pesquisaController.add(pesquisando);
      printerManager.stopScan();
    });
  }

  Future<Ticket> printTicket() async {
    final Ticket ticket = Ticket(PaperSize.mm80);
    ticket.text('Teste de impressao Fluggy'.toUpperCase(), 
      styles: PosStyles(
        align: PosTextAlign.center,
        fontType: PosFontType.fontB
      )
    );
    ticket.cut();
    return ticket;
  }  

  void testPrint(String ip) async {
    final PrinterNetworkManager printerManager = PrinterNetworkManager();
    printerManager.selectPrinter(ip, port: 9100);
    final PosPrintResult res = await printerManager.printTicket(await printTicket());
    print(res.msg);
  }

  void testBluetoothPrint(PrinterBluetooth printer) async {
    printerManager.selectPrinter(printer);
    final PosPrintResult res = await printerManager.printTicket(await printTicket());
    print(res.msg);
  }

  testConnection(String ip, BuildContext context) async {
    // '192.168.0.184'
    Socket.connect(ip, 9100, timeout: Duration(seconds: 5)).then((Socket socket) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text("Conexão estabelecida"),
        )
      );
      testeConexao = true;
      testeConexaoController.add(testeConexao);
    }).catchError((dynamic e) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text("Não foi possível conectar com o dispositivo."),
        )
      );
      testeConexao = false;
      testeConexaoController.add(testeConexao);
    });
  }
  
  testBluetoothConnection(PrinterBluetooth printer, BuildContext context) async {
    final BluetoothManager _bluetoothManager = BluetoothManager.instance;
    BluetoothDevice bluetoothDevice = BluetoothDevice();
    bluetoothDevice.address = printer.address;
    bluetoothDevice.name = printer.name;
    bluetoothDevice.type = printer.type;

    await _bluetoothManager.connect(bluetoothDevice);

    _bluetoothManager.state.listen((state) async {
      switch (state) {
        case BluetoothManager.CONNECTED:
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text("Conexão estabelecida"),
            )
          );
          testeConexao = true;
          testeConexaoController.add(testeConexao);
          _runDelayed(3).then((dynamic v) async {
            await _bluetoothManager.disconnect();
          });
          break;
        case BluetoothManager.DISCONNECTED:
          // testeConexao = false;
          // testeConexaoController.add(testeConexao);
          break;
        default:
          break;
      }
    });
  }

  validaNome() async {
    nomeInvalido = terminalImpressora.nome == "" ? true : false;
    formInvalido = !formInvalido ? nomeInvalido : formInvalido;
    nomeInvalidoController.add(nomeInvalido);
  }
  
  validaMac() async {
    macInvalido = terminalImpressora.macAddress == "" ? true : false;
    formInvalido = !formInvalido ? macInvalido : formInvalido;
    macInvalidoController.add(macInvalido);
  }

  validaIp() async {
    ipInvalido = terminalImpressora.ip == "" ? true : false;
    formInvalido = !formInvalido ? ipInvalido : formInvalido;
    ipInvalidoController.add(ipInvalido);
  }

  limpaValidacoes() async {
    nomeTextEditingController.clear();
    ipTextEditingController.clear();
    macAddressTextEditingController.clear();
  }

  resetBloc() {
    terminalImpressora = TerminalImpressora();
    terminalImpressoraList = [];
    _impressoraBluetoothList = [];
    impressoraBluetoothListController.add(_impressoraBluetoothList);
    terminalImpressoraController.add(terminalImpressora);
    terminalImpressoraListController.add(terminalImpressoraList);
  }

  @override
  void dispose() {
    localIpController.close();
    nomeInvalidoController.close();
    macInvalidoController.close();
    ipInvalidoController.close();
    testeConexaoController.close();
    terminalImpressoraController.close();
    printerController.close();
    impressoraBluetoothListController.close();
    networkScanController.close();
    terminalImpressoraListController.close();
    pesquisaController.close();
    super.dispose();
  }
}
