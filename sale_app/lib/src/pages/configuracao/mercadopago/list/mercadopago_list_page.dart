// import 'package:common_files/common_files.dart';
// import 'package:fluggy/generated/locale_base.dart';
// import 'package:fluggy/src/pages/configuracao/mercadopago/detail/mercadopago_detail_page.dart';
// import 'package:fluggy/src/pages/configuracao/mercadopago/mercadopago_module.dart';
// import 'package:flutter/material.dart';
// import '../mercadopago_module.dart';


// class MercadopagoListPage extends StatefulWidget {
//   @override
//    _MercadopagoListPageState createState() => _MercadopagoListPageState();
     
//    }
   
//    class _MercadopagoListPageState  extends State<MercadopagoListPage> {
//   MercadopagoBloc mercadopagoBloc;
  
//   @override
//   void initState() {
//     mercadopagoBloc = MercadopagoModule.to.getBloc<MercadopagoBloc>();
//     mercadopagoBloc.getAllMercadopago();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {  
//     final locale = Localizations.of<LocaleBase>(context, LocaleBase);

//     Future _initRequester() async {
//       return mercadopagoBloc.getAllMercadopago();
//     }

//     Future<List> _dataRequester() async {
//       return Future.delayed(Duration(milliseconds: 100), () async {
//         return await mercadopagoBloc.getAllMercadopago();
//       });
//     }

//     Function _itemBuilder = (List dataList, BuildContext context, int index) {
//       return ListTile(
//         title: Text("${dataList[index].id}",
//           style: Theme.of(context).textTheme.title,
//         ),
//         trailing: Container(
//           height: 30,
//           width: 30,
//           child: InkWell(
//             child: Icon(
//               Icons.edit, 
//               color: Theme.of(context).primaryIconTheme.color),
//             onTap: () async {
//               await mercadopagoBloc.getMercadopagoById(dataList[index].id);
//               Navigator.push( 
//                 context,
//                 PageRouteBuilder(
//                   pageBuilder: (c, a1, a2) => MercadopagoDetailPage(),
//                   settings: RouteSettings(name: '/DetalheCategoria'),
//                   transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
//                   transitionDuration: Duration(milliseconds: 180),
//                 ),
//               );
//             },
//           ),
//         )
//       );
//     };

//     Widget header = Container(
//       height: 60,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: <Widget>[
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: <Widget>[
//               Container(
//                 width: 300,
//                 padding: EdgeInsets.only(left: 15),
//                 child: TextField(
//                   style: Theme.of(context).textTheme.display3,
//                   decoration: InputDecoration(
//                     icon: Icon(Icons.search, color: Colors.white70),
//                     hintText: locale.palavra.pesquisar,
//                     hintStyle: Theme.of(context).textTheme.display3,
//                     focusedBorder: UnderlineInputBorder(
//                       borderSide: BorderSide(
//                         color: Colors.white70),
//                     ), 
//                     enabledBorder: UnderlineInputBorder(
//                       borderSide: BorderSide(
//                         color: Colors.white70),
//                     ), 
//                   ),
//                   onSubmitted: (text) async {
//                     mercadopagoBloc.filtroAcessToken = text;
//                     mercadopagoBloc.offset = 0;
//                     await mercadopagoBloc.getAllMercadopago();
//                   },
//                 ),
//               )
//             ],
//           ),
//           Container(
//             padding: EdgeInsets.only(right: 15),
//             child: Column(
//               children: <Widget>[
//                 Center(
//                   child: FloatingActionButton(
//                     mini: true,
//                     backgroundColor: Theme.of(context).primaryIconTheme.color,
//                     child: Icon(Icons.add,
//                       color: Colors.white,
//                     ),
//                     onPressed: () async {
//                       await mercadopagoBloc.newMercadopago();
//                       Navigator.push(context,
//                         PageRouteBuilder(
//                           pageBuilder: (c, a1, a2) => MercadopagoDetailPage(),
//                           settings: RouteSettings(name: '/DetalheCategoria'),
//                           transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
//                           transitionDuration:Duration(milliseconds: 180),
//                         ),
//                       );
//                     },
//                   ),
//                 )
//               ],
//             )
//           )
//         ],
//       ),
//     );

//     Widget body = Expanded(
//       child: Container(
//         padding: EdgeInsets.only(left: 10, right: 10, bottom: 20),  
//         child: Container(
//           width: double.infinity,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(12),
//             color: Theme.of(context).accentColor,
//           ),
//           child: Column(
//             children: <Widget>[
//               Expanded(
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[ 
//                     Expanded(
//                       child: DynamicListView.build(
//                         bloc: mercadopagoBloc,
//                         stream: mercadopagoBloc.mercadopagoListOut,
//                         itemBuilder: _itemBuilder,
//                         dataRequester: _dataRequester,
//                         initRequester: _initRequester,
//                         initLoadingWidget: Padding(
//                           padding: const EdgeInsets.only(top: 8.0),
//                           child: CircularProgressIndicator(backgroundColor: Colors.white,),
//                         ),
//                         moreLoadingWidget: Padding(
//                           padding: const EdgeInsets.only(top: 8.0),
//                           child: CircularProgressIndicator(backgroundColor: Colors.white,),
//                         ),
//                       ),
//                     )
//                   ]
//                 )
//               )
//             ]
//           )
//         )
//       )
//     );
    
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Cadastro Mercado Pago"),
//       ),      
//       body: Container(
//         color: Theme.of(context).primaryColor,
//         child: Column(
//           children: <Widget>[
//             header,
//             body
//           ],
//         ),
//       ),
//     );
//   }
// }
