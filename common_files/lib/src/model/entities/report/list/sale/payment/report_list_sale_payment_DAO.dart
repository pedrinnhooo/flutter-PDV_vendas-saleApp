import 'package:common_files/common_files.dart';
import 'package:common_files/src/model/entities/report/list/sale/payment/report_list_sale_payment_entity.dart';

class ReportListSalePaymentDAO {
  HasuraBloc _hasuraBloc;
  AppGlobalBloc _appGlobalBloc;
  int filterId = 0;
  String filterText = "";

  ReportListSalePaymentEntity reportListSalePaymentEntity;
  List<ReportListSalePaymentEntity> reportListSalePayment;

  @override
  Dao dao;

  ReportListSalePaymentDAO(this._hasuraBloc, this._appGlobalBloc, {this.reportListSalePaymentEntity}) {
    dao = Dao();
    //dao.createDb();
  }

  Future<List> getReportFromServer({int personId=0, DateTime initialDate, DateTime finalDate, int offset = 0,
    int rowsPerPage = 10}) async {
    String query = """ 
      {
        relatorio_lista_venda_tipo_pagamento(
          args: {
            ${personId > 0 ? 'person_id: ' + personId.toString() + ',' : ''}
            ${initialDate != null ? 'initial_date: "' + initialDate.toIso8601String() +'",' : ''}
            ${finalDate != null ? 'final_date: "' + finalDate.toIso8601String() +'",' : ''}
          },
          limit: $rowsPerPage, offset: $offset)
          {
            person_group_id
            payment_id
            payment_description
            sold_amount
            net_total
            percentage_sale
          }
        relatorio_lista_total(
          args: {
            ${personId > 0 ? 'person_id: ' + personId.toString() + ',' : ''}
            ${initialDate != null ? 'initial_date: "' + initialDate.toIso8601String() +'",' : ''}
            ${finalDate != null ? 'final_date: "' + finalDate.toIso8601String() +'",' : ''}
            report_name: "report_list_sale_payment"
          }
        )
        {
          register_count
        }
      }
    """;

    var data = await _hasuraBloc.hasuraConnect.query(query);
    reportListSalePayment = [];

      for(var i = 0; i < data['data']['relatorio_lista_venda_tipo_pagamento'].length; i++){
        reportListSalePayment.add(
          ReportListSalePaymentEntity(
            personGroupId:      data['data']['relatorio_lista_venda_tipo_pagamento'][i]['person_group_id'],
            paymentId:          data['data']['relatorio_lista_venda_tipo_pagamento'][i]['payment_id'],
            paymentDescription: data['data']['relatorio_lista_venda_tipo_pagamento'][i]['payment_description'],
            soldAmount:         double.parse(data['data']['relatorio_lista_venda_tipo_pagamento'][i]['sold_amount'].toString()),
            netTotal:           double.parse(data['data']['relatorio_lista_venda_tipo_pagamento'][i]['net_total'].toString()),
            percentageSale:     double.parse(data['data']['relatorio_lista_venda_tipo_pagamento'][i]['percentage_sale'].toString()),
            registerCount:      int.parse(data['data']['relatorio_lista_total'][0]['register_count'].toString())
          )       
        );
      }

      return reportListSalePayment;
    }
}
