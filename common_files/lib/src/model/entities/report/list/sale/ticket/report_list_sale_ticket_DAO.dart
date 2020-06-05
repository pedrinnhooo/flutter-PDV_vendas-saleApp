import 'package:common_files/common_files.dart';
import 'package:common_files/src/model/entities/report/list/sale/ticket/report_list_sale_ticket_entity.dart';

class ReportListSaleTicketDAO {
  HasuraBloc _hasuraBloc;
  AppGlobalBloc _appGlobalBloc;
  int filterId = 0;
  String filterText = "";

  ReportListSaleTicketEntity reportListSaleTicketEntity;
  List<ReportListSaleTicketEntity> reportListSaleTicket;
  
  @override
  Dao dao;

  ReportListSaleTicketDAO(this._hasuraBloc, this._appGlobalBloc, {this.reportListSaleTicketEntity}) {
    dao = Dao();
    //dao.createDb();
  }

  Future<List> getReportFromServer({int personId=0, DateTime initialDate, DateTime finalDate, int offset = 0,
    int rowsPerPage = 10}) async {
    String query = """ 
      {
        relatorio_lista_venda_boleto(
          args: {
            ${personId > 0 ? 'person_id: ' + personId.toString() + ',' : ''}
            ${initialDate != null ? 'initial_date: "' + initialDate.toIso8601String() +'",' : ''}
            ${finalDate != null ? 'final_date: "' + finalDate.toIso8601String() +'",' : ''}
          },
          limit: $rowsPerPage, offset: $offset)
          {
            person_group_id
            sale_id
            date_sale
            net_total_value
            client_id
            client_name
            seller_id
            seller_name
          }
        relatorio_lista_total(
          args: {
            ${personId > 0 ? 'person_id: ' + personId.toString() + ',' : ''}
            ${initialDate != null ? 'initial_date: "' + initialDate.toIso8601String() +'",' : ''}
            ${finalDate != null ? 'final_date: "' + finalDate.toIso8601String() +'",' : ''}
            report_name: "report_list_sale_ticket"
          }
        )
        {
          register_count
        }
      }
    """;

    var data = await _hasuraBloc.hasuraConnect.query(query);
    reportListSaleTicket = [];

      for(var i = 0; i < data['data']['relatorio_lista_venda_boleto'].length; i++){
        reportListSaleTicket.add(
          ReportListSaleTicketEntity(
            personGroupId:  data['data']['relatorio_lista_venda_boleto'][i]['person_group_id'],
            saleId:         data['data']['relatorio_lista_venda_boleto'][i]['sale_id'],
            dateSale:       data['data']['relatorio_lista_venda_boleto'][i]['date_sale'] != null ? DateTime.parse(data['data']['relatorio_lista_venda_boleto'][i]['date_sale']) : null,
            totalNetAmount: double.parse(data['data']['relatorio_lista_venda_boleto'][i]['net_total_value'].toString()),
            clientId:       data['data']['relatorio_lista_venda_boleto'][i]['client_id'],
            clientName:     data['data']['relatorio_lista_venda_boleto'][i]['client_name'] != null ? data['data']['relatorio_lista_venda_boleto'][i]['client_name']: 'Sem Cliente',
            sellerId:       data['data']['relatorio_lista_venda_boleto'][i]['seller_id'],
            sellerName:     data['data']['relatorio_lista_venda_boleto'][i]['seller_name'] != null ? data['data']['relatorio_lista_venda_boleto'][i]['seller_name']: 'Sem Vendedor',
            registerCount:  int.parse(data['data']['relatorio_lista_total'][0]['register_count'].toString())
          )       
        );
      }
      return reportListSaleTicket;
    }
}
