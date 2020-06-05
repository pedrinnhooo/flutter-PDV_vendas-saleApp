import 'package:flutter_bluetooth_basic/flutter_bluetooth_basic.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:common_files/common_files.dart';
import 'package:common_files/src/model/entities/configuracao/cupom_layout/cupom_layout.dart';
import 'package:common_files/src/model/entities/configuracao/cupom_layout/cupom_layoutDao.dart';
import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:rxdart/rxdart.dart';

class CupomLayoutBloc extends BlocBase{
  HasuraBloc _hasuraBloc;
  AppGlobalBloc _appGlobalBloc;
  bool formInvalido = true;
  bool nomeInvalido = false;
  bool tamanhoPapelnvalido = true;
  bool layoutInvalido = true;
  List<String> tamanhosList = ["58", "80"];
  List<String> layoutList = ["Padrão"];
  String filtroNome = "";
  int offset = 0;

  CupomLayout cupomLayout;
  BehaviorSubject<CupomLayout> cupomLayoutController;
  Stream<CupomLayout> get cupomLayoutOut => cupomLayoutController.stream;

  List<CupomLayout> cupomLayoutList;
  BehaviorSubject<List<CupomLayout>> cupomLayoutListController;
  Stream<List<CupomLayout>> get cupomLayoutListOut => cupomLayoutListController.stream;
  
  BehaviorSubject<bool> nomeInvalidoController;
  Stream<bool> get nomeInvalidoOut => nomeInvalidoController.stream;

  BehaviorSubject<bool> tamanhoPapelInvalidoController;
  Stream<bool> get tamanhoPapelInvalidoOut => tamanhoPapelInvalidoController.stream;

  BehaviorSubject<bool> layoutInvalidoController;
  Stream<bool> get layoutInvalidoOut => layoutInvalidoController.stream;

  CupomLayoutBloc(this._hasuraBloc, this._appGlobalBloc){
    cupomLayoutController = BehaviorSubject.seeded(cupomLayout);
    cupomLayoutListController = BehaviorSubject.seeded(cupomLayoutList);
    nomeInvalidoController = BehaviorSubject.seeded(nomeInvalido);
    tamanhoPapelInvalidoController = BehaviorSubject.seeded(tamanhoPapelnvalido);
    layoutInvalidoController = BehaviorSubject.seeded(layoutInvalido);
  }

  newCupomLayout() async {
    cupomLayout = CupomLayout();
    cupomLayoutController.add(cupomLayout);
  }

  getAllCupomLayout() async{
    CupomLayout _cupomLayout = CupomLayout();
    CupomLayoutDAO _cupomLayoutDAO = CupomLayoutDAO(_cupomLayout, _hasuraBloc, _appGlobalBloc);
    cupomLayoutList = await _cupomLayoutDAO.getAllFromServer(id: true);
    cupomLayoutListController.add(cupomLayoutList);
  }

  getCupomLayoutById(int id) async {
    CupomLayout _cupomLayout = CupomLayout();
    CupomLayoutDAO _cupomLayoutDAO = CupomLayoutDAO(_cupomLayout, _hasuraBloc, _appGlobalBloc);
    cupomLayout = await _cupomLayoutDAO.getByIdFromServer(id);
    cupomLayoutController.add(cupomLayout);
  }

  saveCupomLayout() async {
    cupomLayout.dataCadastro = cupomLayout.dataCadastro == null ? DateTime.now() : cupomLayout.dataCadastro;
    cupomLayout.dataAtualizacao = DateTime.now();
    CupomLayoutDAO _cupomLayoutDAO = CupomLayoutDAO(cupomLayout, _hasuraBloc, _appGlobalBloc);
    cupomLayout = await _cupomLayoutDAO.saveOnServer();
    offset = 0;
    await getAllCupomLayout();
    //await/ 
  }

  setTamanhoPapel(int tamanhoPapel) async {
    if(tamanhoPapel == 80 || tamanhoPapel == 58){
      cupomLayout.tamanhoPapel = tamanhoPapel;
      cupomLayoutController.add(cupomLayout);
    } else {
      print("TamanhoPapel diferente de 80 ou 58");
    }
  }

  setLayout(String layout){
    cupomLayout.layout = layout;
    cupomLayoutController.add(cupomLayout);
  }

  validaNome() async {
    nomeInvalido = cupomLayout.nome == "" ? true : false;
    formInvalido = nomeInvalido;
    nomeInvalidoController.add(nomeInvalido);
  }

  validaTamanhoPapel() async {
    tamanhoPapelnvalido = cupomLayout.tamanhoPapel == null ? true : false;
    formInvalido = tamanhoPapelnvalido;
    tamanhoPapelInvalidoController.add(tamanhoPapelnvalido);
  }

  validaLayout() async {
    layoutInvalido = cupomLayout.layout == "" ? true : false;
    formInvalido = layoutInvalido;
    layoutInvalidoController.add(layoutInvalido);
  }

  printTicketRede(String ip, Ticket _ticket) async {
    if(ip != null){
      final PrinterNetworkManager printerManager = PrinterNetworkManager();
      printerManager.selectPrinter(ip, port: 9100);
      final PosPrintResult res = await printerManager.printTicket(_ticket);
      return res.msg;
    }
  }

  printTicketBluetooth(String nome, String macAddress, Ticket _ticket) async {
    PrinterBluetoothManager printerManager = PrinterBluetoothManager();
    BluetoothDevice bluetoothDevice = BluetoothDevice();
    bluetoothDevice.address = macAddress;
    bluetoothDevice.name = nome;
    bluetoothDevice.type = 3;
    bluetoothDevice.connected = true;
    PrinterBluetooth printerBluetooth = PrinterBluetooth(bluetoothDevice);
    printerManager.selectPrinter(printerBluetooth);
    final PosPrintResult res = await printerManager.printTicket(_ticket);
    return res.msg;
  }

  @override
  void dispose() { 
    cupomLayoutController.close();
    cupomLayoutListController.close();
    nomeInvalidoController.close();
    tamanhoPapelInvalidoController.close();
    layoutInvalidoController.close();
    super.dispose();
  }
}