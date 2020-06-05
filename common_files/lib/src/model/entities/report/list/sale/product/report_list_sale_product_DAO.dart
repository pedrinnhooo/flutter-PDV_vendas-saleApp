import 'package:common_files/common_files.dart';
import 'package:common_files/src/model/entities/report/list/sale/product/report_list_sale_product_entity.dart';

class ReportListSaleProductDAO {
  HasuraBloc _hasuraBloc;
  AppGlobalBloc _appGlobalBloc;
  int filterId = 0;
  String filterText = "";

  ReportListSaleProductEntity reportListSaleProductEntity;
  List<ReportListSaleProductEntity> reportListSaleProduct;

  @override
  Dao dao;

  ReportListSaleProductDAO(this._hasuraBloc, this._appGlobalBloc, {this.reportListSaleProductEntity}) {
    dao = Dao();
    //dao.createDb();
  }

  Future<List> getReportFromServer({int personId=0, DateTime initialDate, DateTime finalDate, int offset = 0,
    int rowsPerPage = 10}) async {
    String query = """ 
      {
        relatorio_lista_venda_produto(
          args: {
            ${personId > 0 ? 'person_id: ' + personId.toString() + ',' : ''}
            ${initialDate != null ? 'initial_date: "' + initialDate.toIso8601String() +'",' : ''}
            ${finalDate != null ? 'final_date: "' + finalDate.toIso8601String() +'",' : ''}
          },
          limit: $rowsPerPage, offset: $offset)
          {
            person_group_id
            product_id
            product_apparent_id
            product_name
            sold_amount
            net_total
          }
        relatorio_lista_total(
          args: {
            ${personId > 0 ? 'person_id: ' + personId.toString() + ',' : ''}
            ${initialDate != null ? 'initial_date: "' + initialDate.toIso8601String() +'",' : ''}
            ${finalDate != null ? 'final_date: "' + finalDate.toIso8601String() +'",' : ''}
            report_name: "report_list_sale_product"
          }
        )
        {
          register_count
        }
      }
    """;

    var data = await _hasuraBloc.hasuraConnect.query(query);
    reportListSaleProduct = [];

      for(var i = 0; i < data['data']['relatorio_lista_venda_produto'].length; i++){
        reportListSaleProduct.add(
          ReportListSaleProductEntity(
            personGroupId:      data['data']['relatorio_lista_venda_produto'][i]['person_group_id'],
            productId:          data['data']['relatorio_lista_venda_produto'][i]['product_id'],
            productApparentId:  data['data']['relatorio_lista_venda_produto'][i]['product_apparent_id'],
            productName:        data['data']['relatorio_lista_venda_produto'][i]['product_name'],
            soldAmount:         double.parse(data['data']['relatorio_lista_venda_produto'][i]['sold_amount'].toString()),
            netTotal:           double.parse(data['data']['relatorio_lista_venda_produto'][i]['net_total'].toString()),
            registerCount:  int.parse(data['data']['relatorio_lista_total'][0]['register_count'].toString())
          )       
        );
      }

      return reportListSaleProduct;
    }
}
