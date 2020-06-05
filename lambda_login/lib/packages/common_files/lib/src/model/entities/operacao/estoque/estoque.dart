import '../../interfaces.dart';

class Estoque extends IEntity{
  int _id;
  int _idProduto;
  double _estoqueTotal;
  
  Estoque({id, idProduto, double estoqueTotal}){
    this._id = id;
    this._idProduto = idProduto;
    this._estoqueTotal = estoqueTotal;
  }

  int get id => _id;
  set id(int id) => _id = id;
  int get idProduto => _idProduto;
  set idProduto(int idProduto) => _idProduto = idProduto;
  double get estoqueTotal => _estoqueTotal;
  set estoqueTotal(double estoqueTotal) => _estoqueTotal = estoqueTotal;

  Estoque.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _idProduto = json['id_produto'];
    _estoqueTotal = json['estoque_total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['id_produto'] = this._idProduto;
    data['estoque_total'] = this._estoqueTotal;
    return data;
  }
}