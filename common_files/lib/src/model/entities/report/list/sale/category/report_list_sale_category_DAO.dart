import 'package:common_files/common_files.dart';
import 'package:common_files/src/model/entities/report/list/sale/category/report_list_sale_category_entity.dart';

class ReportListSaleCategoryDAO {
  HasuraBloc _hasuraBloc;
  AppGlobalBloc _appGlobalBloc;
  int filterId = 0;
  String filterText = "";

  ReportListSaleCategoryEntity reportListSaleCategoryEntity;
  List<ReportListSaleCategoryEntity> reportListSaleCategory;

  @override
  Dao dao;

  ReportListSaleCategoryDAO(this._hasuraBloc, this._appGlobalBloc, {this.reportListSaleCategoryEntity}) {
    dao = Dao();
    //dao.createDb();
  }

  Future<List> getReportFromServer({int personId=0, DateTime initialDate, DateTime finalDate, int offset = 0,
    int rowsPerPage = 10}) async {
    String query = """ 
      {
        relatorio_lista_venda_categoria(
          args: {
            ${personId > 0 ? 'person_id: ' + personId.toString() + ',' : ''}
            ${initialDate != null ? 'initial_date: "' + initialDate.toIso8601String() +'",' : ''}
            ${finalDate != null ? 'final_date: "' + finalDate.toIso8601String() +'",' : ''}
          },
          limit: $rowsPerPage, offset: $offset)
          {
            person_group_id
            category_id
            category_description
            sold_amount
            net_total
            percentage_sale
          }
        relatorio_lista_total(
          args: {
            ${personId > 0 ? 'person_id: ' + personId.toString() + ',' : ''}
            ${initialDate != null ? 'initial_date: "' + initialDate.toIso8601String() +'",' : ''}
            ${finalDate != null ? 'final_date: "' + finalDate.toIso8601String() +'",' : ''}
            report_name: "report_list_sale_category"
          }
        )
        {
          register_count
        }
      }
    """;

    var data = await _hasuraBloc.hasuraConnect.query(query);
    reportListSaleCategory = [];

    for(var i = 0; i < data['data']['relatorio_lista_venda_categoria'].length; i++){
      reportListSaleCategory.add(
        ReportListSaleCategoryEntity(
          personGroupId:      data['data']['relatorio_lista_venda_categoria'][i]['person_group_id'],
          categoryId:          data['data']['relatorio_lista_venda_categoria'][i]['category_id'],
          categoryDescription: data['data']['relatorio_lista_venda_categoria'][i]['category_description'],
          soldAmount:         double.parse(data['data']['relatorio_lista_venda_categoria'][i]['sold_amount'].toString()),
          netTotal:           double.parse(data['data']['relatorio_lista_venda_categoria'][i]['net_total'].toString()),
          percentageSale:     double.parse(data['data']['relatorio_lista_venda_categoria'][i]['percentage_sale'].toString()),
          registerCount:      int.parse(data['data']['relatorio_lista_total'][0]['register_count'].toString())
        )       
      );
    }
      return reportListSaleCategory;
    }
}
