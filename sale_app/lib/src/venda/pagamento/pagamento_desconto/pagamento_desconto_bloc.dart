import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';

class IsValue {
  bool isValue = true;
  String texto = "R\$";
}

class PagamentoDescontoBloc extends BlocBase {
  IsValue isValue = IsValue();
  BehaviorSubject<IsValue> _isValueController;
  Stream<IsValue> get isValueOut => _isValueController.stream;

  PagamentoDescontoBloc() {
    _isValueController = BehaviorSubject.seeded(isValue);
  }

  setValue() {
    isValue.isValue = isValue.isValue ? false : true;
    isValue.texto = isValue.texto == "R\$" ? "%" : "R\$";
    _isValueController.add(isValue);
  }

  //dispose will be called automatically by closing its streams
  @override
  void dispose() {
    _isValueController.close();
    super.dispose();
  }
}
