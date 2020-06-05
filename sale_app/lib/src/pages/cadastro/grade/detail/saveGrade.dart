import 'package:common_files/common_files.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:fluggy/generated/locale_base.dart';
import 'package:flutter/material.dart';
import 'package:fluggy/src/pages/cadastro/grade/grade_module.dart';

class GradeDetailPage extends StatefulWidget {
  @override
  _GradeDetailPageState createState() => _GradeDetailPageState();
}

class _GradeDetailPageState extends State<GradeDetailPage> {
  GradeBloc gradeBloc;
  TextEditingController nomeController;
  TextEditingController t1Controller;
  TextEditingController t2Controller;
  TextEditingController t3Controller;
  TextEditingController t4Controller;
  TextEditingController t5Controller;
  TextEditingController t6Controller;
  TextEditingController t7Controller;
  TextEditingController t8Controller;
  TextEditingController t9Controller;
  TextEditingController t10Controller;
  TextEditingController t11Controller;
  TextEditingController t12Controller;
  TextEditingController t13Controller;
  TextEditingController t14Controller;
  TextEditingController t15Controller;

  @override
  void initState() {
    gradeBloc = GradeModule.to.getBloc<GradeBloc>();
    nomeController = TextEditingController();
    nomeController.value =  nomeController.value.copyWith(text: gradeBloc.grade.nome); 
    t1Controller = TextEditingController();
    t1Controller.value =  t1Controller.value.copyWith(text: gradeBloc.grade.t1); 
    t2Controller = TextEditingController();
    t2Controller.value =  t2Controller.value.copyWith(text: gradeBloc.grade.t2); 
    t3Controller = TextEditingController();
    t3Controller.value =  t3Controller.value.copyWith(text: gradeBloc.grade.t3); 
    t4Controller = TextEditingController();
    t4Controller.value =  t4Controller.value.copyWith(text: gradeBloc.grade.t4); 
    t5Controller = TextEditingController();
    t5Controller.value =  t5Controller.value.copyWith(text: gradeBloc.grade.t5); 
    t6Controller = TextEditingController();
    t6Controller.value =  t6Controller.value.copyWith(text: gradeBloc.grade.t6); 
    t7Controller = TextEditingController();
    t7Controller.value =  t7Controller.value.copyWith(text: gradeBloc.grade.t7); 
    t8Controller = TextEditingController();
    t8Controller.value =  t8Controller.value.copyWith(text: gradeBloc.grade.t8); 
    t9Controller = TextEditingController();
    t9Controller.value =  t9Controller.value.copyWith(text: gradeBloc.grade.t9); 
    t10Controller = TextEditingController();
    t10Controller.value =  t10Controller.value.copyWith(text: gradeBloc.grade.t10); 
    t11Controller = TextEditingController();
    t11Controller.value =  t11Controller.value.copyWith(text: gradeBloc.grade.t11); 
    t12Controller = TextEditingController();
    t12Controller.value =  t12Controller.value.copyWith(text: gradeBloc.grade.t12); 
    t13Controller = TextEditingController();
    t13Controller.value =  t13Controller.value.copyWith(text: gradeBloc.grade.t13); 
    t14Controller = TextEditingController();
    t14Controller.value =  t14Controller.value.copyWith(text: gradeBloc.grade.t14); 
    t15Controller = TextEditingController();
    t15Controller.value =  t15Controller.value.copyWith(text: gradeBloc.grade.t15); 
    super.initState();
  } 
  
  @override
  Widget build(BuildContext context) {
    const double sizeBox = 92;
    final locale = Localizations.of<LocaleBase>(context, LocaleBase);

    return Scaffold(
      appBar: AppBar(
        title: Text(locale.cadastroGrade.titulo, 
          style: Theme.of(context).textTheme.title,
        )
      ),      
      body: Container(
        color: Theme.of(context).primaryColor,
        child: Column(
          children: <Widget>[
            Container(
              height: 60,
              padding: const EdgeInsets.only(bottom: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                   Container(
                     padding: EdgeInsets.only(left: 10),
                     child: Text(gradeBloc.grade.id != null 
                       ? locale.palavra.alterar + " " + locale.cadastroGrade.titulo.toLowerCase()
                       : locale.cadastro.incluirNovo,
                       style: Theme.of(context).textTheme.subhead,
                     ),
                   ),
                   Container(
                     padding: EdgeInsets.only(right: 15),
                     child: InkWell(
                         child: Text(gradeBloc.grade.id != null ? locale.palavra.excluir : locale.palavra.limpar,
                         style: Theme.of(context).textTheme.subhead,
                       ),
                       onTap: () async {
                         if (gradeBloc.grade.id != null) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => CustomDialogConfirmation(
                              title: locale.palavra.confirmacao,
                              description: locale.mensagem.confirmarExcluirRegistro +
                                locale.palavra.artigo_a + " " +
                                locale.cadastroGrade.titulo.toLowerCase() + " ",
                              item: gradeBloc.grade.nome ,
                              buttonOkText: locale.palavra.excluir,
                              buttonCancelText: locale.palavra.cancelar,
                              funcaoBotaoOk: () async {
                                await gradeBloc.deleteGrade();
                                await gradeBloc.getAllGrade();
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              funcaoBotaoCancelar: () async {
                                Navigator.pop(context);
                              }
                            ),
                          );                           
                         } else {
                           await gradeBloc.newGrade();
                           nomeController.clear();
                         }
                       },
                     ),
                   )  
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left: 10, right: 10, bottom: 20),  
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Theme.of(context).accentColor,
                  ),
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: SingleChildScrollView (
                          child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10, right: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    StreamBuilder<bool>(
                                      initialData: false,
                                      stream: gradeBloc.nomeInvalidoOut,
                                      builder: (context, snapshot) {
                                        return customTextField(
                                          context,
                                          autofocus: gradeBloc.grade.id != null ? false : true,
                                          controller: nomeController,
                                          labelText: locale.palavra.nome,
                                          errorText: snapshot.data ? locale.mensagem.nomeNaoNulo : null,
                                          onChanged: (text) {
                                              gradeBloc.grade.nome = text;
                                          }   
                                        );
                                      }
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(top: 15),
                                      child: StreamBuilder<Grade>(
                                        stream: gradeBloc.gradeOut,
                                        builder: (context, snapshot) {
                                          if (!snapshot.hasData) {
                                            return Center(child: CircularProgressIndicator());
                                          }
                                          Grade grade = snapshot.data;
                                          return Column(
                                            children: <Widget>[
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: <Widget>[
                                                  Stack(
                                                    children:<Widget>[
                                                      DottedBorder(
                                                        dashPattern: [8,4],
                                                        borderType: BorderType.RRect,
                                                        radius: Radius.circular(4),
                                                        color: Colors.blue[300],
                                                        child: Container(
                                                          height: sizeBox,
                                                          width: sizeBox,
                                                          child: StreamBuilder<bool>(
                                                            initialData: false,
                                                            stream: gradeBloc.t1InvalidoOut,
                                                            builder: (context, snapshot) {
                                                              return Padding(
                                                                padding: const EdgeInsets.all(8),
                                                                child: Center(
                                                                  child: gridTextField(context,
                                                                    controller: t1Controller,
                                                                    errorText: snapshot.data ? locale.palavra.erro : null,
                                                                    onChanged: (text) {
                                                                      gradeBloc.grade.t1 = text;
                                                                      gradeBloc.updateStream();
                                                                    },
                                                                    onTap: () {
                                                                      print("Tap1");
                                                                    }
                                                                  )
                                                                ),
                                                              );
                                                            }
                                                          ),
                                                        ),
                                                      ),
                                                      Align(
                                                        alignment: Alignment.topLeft,
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(6.0),
                                                          child: Text(locale.palavra.posicao + " 1",
                                                            style: Theme.of(context).textTheme.body2,
                                                          ),
                                                        ),
                                                      ),
                                                    ]  
                                                  ),
                                                  Stack(
                                                    children:<Widget>[
                                                      Container(
                                                        height: sizeBox,
                                                        width: sizeBox,
                                                        decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.all(Radius.circular(6)),
                                                            border: Border.all(
                                                              width: 0.2,
                                                              color: Theme.of(context).textTheme.title.color
                                                            ),
                                                            color: Theme.of(context).primaryColor
                                                        ),
                                                        child: StreamBuilder<Object>(
                                                          initialData: false,
                                                          stream: gradeBloc.t2InvalidoOut,
                                                          builder: (context, snapshot) {
                                                            return Padding(
                                                              padding: const EdgeInsets.all(8),
                                                              child: Center(
                                                                child: gridTextField(context,
                                                                  enabled: gradeBloc.grade.t1 != "" ? true : false,
                                                                  errorText: snapshot.data ? locale.palavra.erro : null,
                                                                  controller: t2Controller,
                                                                  onChanged: (text) {
                                                                    gradeBloc.grade.t2 = text;    
                                                                    gradeBloc.updateStream();
                                                                  },
                                                                  onTap: () {
                                                                    gradeBloc.validat1();    
                                                                  }
                                                                )
                                                              ),
                                                            );
                                                          }
                                                        ),
                                                      ),
                                                      Align(
                                                        alignment: Alignment.topLeft,
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(6.0),
                                                          child: Text(locale.palavra.posicao + " 2",
                                                            style: Theme.of(context).textTheme.body2,
                                                          ),
                                                        ),
                                                      ),
                                                    ]  
                                                  ),
                                                  Stack(
                                                    children:<Widget>[
                                                      Container(
                                                        height: sizeBox,
                                                        width: sizeBox,
                                                        decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.all(Radius.circular(6)),
                                                            border: Border.all(
                                                              width: 0.2,
                                                              color: Theme.of(context).textTheme.title.color
                                                            ),
                                                            color: Theme.of(context).primaryColor
                                                        ),
                                                        child: StreamBuilder<bool>(
                                                          initialData: false,
                                                          stream: gradeBloc.t3InvalidoOut,
                                                          builder: (context, snapshot) {
                                                            return Padding(
                                                              padding: const EdgeInsets.all(8.0),
                                                              child: Center(
                                                                child: gridTextField(context,
                                                                  enabled: gradeBloc.grade.t2 != "" ? true : false,
                                                                  errorText: snapshot.data ? locale.palavra.erro : null,
                                                                  controller: t3Controller,
                                                                  onChanged: (text) {
                                                                    gradeBloc.grade.t3 = text;    
                                                                    gradeBloc.updateStream();
                                                                  },
                                                                  onTap: () {
                                                                    gradeBloc.validat1();    
                                                                    gradeBloc.validat2();    
                                                                    gradeBloc.validat3();    
                                                                  }
                                                                )
                                                              ),
                                                            );
                                                          }
                                                        )  
                                                      ),
                                                      Align(
                                                        alignment: Alignment.topLeft,
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(6.0),
                                                          child: Text(locale.palavra.posicao + " 3",
                                                            style: Theme.of(context).textTheme.body2,
                                                          ),
                                                        ),
                                                      ),
                                                    ]  
                                                  ),
                                                ],
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(top: 15),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  children: <Widget>[
                                                    Stack(
                                                      children:<Widget>[
                                                        Container(
                                                          height: sizeBox,
                                                          width: sizeBox,
                                                          decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.all(Radius.circular(6)),
                                                              border: Border.all(
                                                                width: 0.2,
                                                                color: Theme.of(context).textTheme.title.color
                                                              ),
                                                              color: Theme.of(context).primaryColor
                                                          ),
                                                          child: StreamBuilder<Object>(
                                                            initialData: false,
                                                            stream: gradeBloc.t4InvalidoOut,
                                                            builder: (context, snapshot) {
                                                              return Padding(
                                                                padding: const EdgeInsets.all(8.0),
                                                                child: Center(
                                                                  child: gridTextField(context,
                                                                    enabled: gradeBloc.grade.t3 != "" ? true : false,
                                                                    errorText: snapshot.data ? locale.palavra.erro : null,
                                                                    controller: t4Controller,
                                                                    onChanged: (text) {
                                                                      gradeBloc.grade.t4 = text;    
                                                                      gradeBloc.updateStream();
                                                                    },
                                                                    onTap: () {
                                                                      gradeBloc.validat1();    
                                                                      gradeBloc.validat2();    
                                                                      gradeBloc.validat3();    
                                                                    }
                                                                  )
                                                                ),
                                                              );
                                                            }
                                                          ),
                                                        ),
                                                        Align(
                                                          alignment: Alignment.topLeft,
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(6.0),
                                                            child: Text(locale.palavra.posicao + " 4",
                                                              style: Theme.of(context).textTheme.body2,
                                                            ),
                                                          ),
                                                        ),
                                                      ]  
                                                    ),
                                                    Stack(
                                                      children:<Widget>[
                                                        Container(
                                                          height: sizeBox,
                                                          width: sizeBox,
                                                          decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.all(Radius.circular(6)),
                                                              border: Border.all(
                                                                width: 0.2,
                                                                color: Theme.of(context).textTheme.title.color
                                                              ),
                                                              color: Theme.of(context).primaryColor
                                                          ),
                                                          child: StreamBuilder<Object>(
                                                            initialData: false,
                                                            stream: gradeBloc.t5InvalidoOut,
                                                            builder: (context, snapshot) {
                                                              return Padding(
                                                                padding: const EdgeInsets.all(8.0),
                                                                child: Center(
                                                                  child: gridTextField(context,
                                                                    enabled: gradeBloc.grade.t4 != "" ? true : false,
                                                                    errorText: snapshot.data ? locale.palavra.erro : null,
                                                                    controller: t5Controller,
                                                                    onChanged: (text) {
                                                                      gradeBloc.grade.t5 = text;    
                                                                      gradeBloc.updateStream();
                                                                    },
                                                                    onTap: () {
                                                                      gradeBloc.validat1();    
                                                                      gradeBloc.validat2();    
                                                                      gradeBloc.validat3();    
                                                                      gradeBloc.validat4();    
                                                                    }
                                                                  )
                                                                ),
                                                              );
                                                            }
                                                          ),
                                                        ),
                                                        Align(
                                                          alignment: Alignment.topLeft,
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(6.0),
                                                            child: Text(locale.palavra.posicao + " 5",
                                                              style: Theme.of(context).textTheme.body2,
                                                            ),
                                                          ),
                                                        ),
                                                      ]  
                                                    ),
                                                    Stack(
                                                      children:<Widget>[
                                                        Container(
                                                          height: sizeBox,
                                                          width: sizeBox,
                                                          decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.all(Radius.circular(6)),
                                                              border: Border.all(
                                                                width: 0.2,
                                                                color: Theme.of(context).textTheme.title.color
                                                              ),
                                                              color: Theme.of(context).primaryColor
                                                          ),
                                                          child: StreamBuilder<Object>(
                                                            initialData: false,
                                                            stream: gradeBloc.t6InvalidoOut,
                                                            builder: (context, snapshot) {
                                                              return Padding(
                                                                padding: const EdgeInsets.all(8.0),
                                                                child: Center(
                                                                  child: gridTextField(context,
                                                                    enabled: gradeBloc.grade.t5 != "" ? true : false,
                                                                    controller: t6Controller,
                                                                    errorText: snapshot.data ? locale.palavra.erro : null,
                                                                    onChanged: (text) {
                                                                      gradeBloc.grade.t6 = text;    
                                                                      gradeBloc.updateStream();
                                                                    },
                                                                    onTap: () {
                                                                      gradeBloc.validat1();    
                                                                      gradeBloc.validat2();    
                                                                      gradeBloc.validat3();    
                                                                      gradeBloc.validat4();    
                                                                      gradeBloc.validat5();    
                                                                    }
                                                                  )
                                                                ),
                                                              );
                                                            }
                                                          ),
                                                        ),
                                                        Align(
                                                          alignment: Alignment.topLeft,
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(6.0),
                                                            child: Text(locale.palavra.posicao + " 6",
                                                              style: Theme.of(context).textTheme.body2,
                                                            ),
                                                          ),
                                                        ),
                                                      ]  
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(top: 15),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  children: <Widget>[
                                                    Stack(
                                                      children:<Widget>[
                                                        Container(
                                                          height: sizeBox,
                                                          width: sizeBox,
                                                          decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.all(Radius.circular(6)),
                                                              border: Border.all(
                                                                width: 0.2,
                                                                color: Theme.of(context).textTheme.title.color
                                                              ),
                                                              color: Theme.of(context).primaryColor
                                                          ),
                                                          child: StreamBuilder<Object>(
                                                            initialData: false,
                                                            stream: gradeBloc.t7InvalidoOut,
                                                            builder: (context, snapshot) {
                                                              return Padding(
                                                                padding: const EdgeInsets.all(8.0),
                                                                child: Center(
                                                                  child: gridTextField(context,
                                                                    enabled: gradeBloc.grade.t6 != "" ? true : false,
                                                                    errorText: snapshot.data ? locale.palavra.erro : null,
                                                                    controller: t7Controller,
                                                                    onChanged: (text) {
                                                                      gradeBloc.grade.t7 = text;    
                                                                      gradeBloc.updateStream();
                                                                    },
                                                                    onTap: () {
                                                                      gradeBloc.validat1();    
                                                                      gradeBloc.validat2();    
                                                                      gradeBloc.validat3();    
                                                                      gradeBloc.validat4();    
                                                                      gradeBloc.validat5();    
                                                                      gradeBloc.validat6();    
                                                                    }
                                                                  )
                                                                ),
                                                              );
                                                            }
                                                          ),
                                                        ),
                                                        Align(
                                                          alignment: Alignment.topLeft,
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(6.0),
                                                            child: Text(locale.palavra.posicao + " 7",
                                                              style: Theme.of(context).textTheme.body2,
                                                            ),
                                                          ),
                                                        ),
                                                      ]  
                                                    ),
                                                    Stack(
                                                      children:<Widget>[
                                                        Container(
                                                          height: sizeBox,
                                                          width: sizeBox,
                                                          decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.all(Radius.circular(6)),
                                                              border: Border.all(
                                                                width: 0.2,
                                                                color: Theme.of(context).textTheme.title.color
                                                              ),
                                                              color: Theme.of(context).primaryColor
                                                          ),
                                                          child: StreamBuilder<Object>(
                                                            initialData: false,
                                                            stream: gradeBloc.t8InvalidoOut,
                                                            builder: (context, snapshot) {
                                                              return Padding(
                                                                padding: const EdgeInsets.all(8.0),
                                                                child: Center(
                                                                  child: gridTextField(context,
                                                                    enabled: gradeBloc.grade.t7 != "" ? true : false,
                                                                    errorText: snapshot.data ? locale.palavra.erro : null,
                                                                    controller: t8Controller,
                                                                    onChanged: (text) {
                                                                      gradeBloc.grade.t8 = text;    
                                                                      gradeBloc.updateStream();
                                                                    },
                                                                    onTap: () {
                                                                      gradeBloc.validat1();    
                                                                      gradeBloc.validat2();    
                                                                      gradeBloc.validat3();    
                                                                      gradeBloc.validat4();    
                                                                      gradeBloc.validat5();    
                                                                      gradeBloc.validat6();    
                                                                      gradeBloc.validat7();    
                                                                    }
                                                                  )
                                                                ),
                                                              );
                                                            }
                                                          ),
                                                        ),
                                                        Align(
                                                          alignment: Alignment.topLeft,
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(6.0),
                                                            child: Text(locale.palavra.posicao + " 8",
                                                              style: Theme.of(context).textTheme.body2,
                                                            ),
                                                          ),
                                                        ),
                                                      ]  
                                                    ),
                                                    Stack(
                                                      children:<Widget>[
                                                        Container(
                                                          height: sizeBox,
                                                          width: sizeBox,
                                                          decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.all(Radius.circular(6)),
                                                              border: Border.all(
                                                                width: 0.2,
                                                                color: Theme.of(context).textTheme.title.color
                                                              ),
                                                              color: Theme.of(context).primaryColor
                                                          ),
                                                          child: StreamBuilder<Object>(
                                                            initialData: false,
                                                            stream: gradeBloc.t9InvalidoOut,
                                                            builder: (context, snapshot) {
                                                              return Center(
                                                                child: gridTextField(context,
                                                                  enabled: gradeBloc.grade.t8 != "" ? true : false,
                                                                  errorText: snapshot.data ? locale.palavra.erro : null,
                                                                  controller: t9Controller,
                                                                  onChanged: (text) {
                                                                    gradeBloc.grade.t9 = text;    
                                                                    gradeBloc.updateStream();
                                                                  },
                                                                  onTap: () {
                                                                    gradeBloc.validat1();    
                                                                    gradeBloc.validat2();    
                                                                    gradeBloc.validat3();    
                                                                    gradeBloc.validat4();    
                                                                    gradeBloc.validat5();    
                                                                    gradeBloc.validat6();    
                                                                    gradeBloc.validat7();    
                                                                    gradeBloc.validat8();    
                                                                  }
                                                                )
                                                              );
                                                            }
                                                          ),
                                                        ),
                                                        Align(
                                                          alignment: Alignment.topLeft,
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(6.0),
                                                            child: Text(locale.palavra.posicao + " 9",
                                                              style: Theme.of(context).textTheme.body2,
                                                            ),
                                                          ),
                                                        ),
                                                      ]  
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(top: 15),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  children: <Widget>[
                                                    Stack(
                                                      children:<Widget>[
                                                        Container(
                                                          height: sizeBox,
                                                          width: sizeBox,
                                                          decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.all(Radius.circular(6)),
                                                              border: Border.all(
                                                                width: 0.2,
                                                                color: Theme.of(context).textTheme.title.color
                                                              ),
                                                              color: Theme.of(context).primaryColor
                                                          ),
                                                          child: StreamBuilder<Object>(
                                                            initialData: false,
                                                            stream: gradeBloc.t10InvalidoOut,
                                                            builder: (context, snapshot) {
                                                              return Padding(
                                                                padding: const EdgeInsets.all(8.0),
                                                                child: Center(
                                                                  child: gridTextField(context,
                                                                    enabled: gradeBloc.grade.t9 != "" ? true : false,
                                                                    errorText: snapshot.data ? locale.palavra.erro : null,
                                                                    controller: t10Controller,
                                                                    onChanged: (text) {
                                                                      gradeBloc.grade.t10 = text;    
                                                                      gradeBloc.updateStream();
                                                                    },
                                                                    onTap: () {
                                                                      gradeBloc.validat1();    
                                                                      gradeBloc.validat2();    
                                                                      gradeBloc.validat3();    
                                                                      gradeBloc.validat4();    
                                                                      gradeBloc.validat5();    
                                                                      gradeBloc.validat6();    
                                                                      gradeBloc.validat7();    
                                                                      gradeBloc.validat8();    
                                                                      gradeBloc.validat9();    
                                                                    }
                                                                  )
                                                                ),
                                                              );
                                                            }
                                                          ),
                                                        ),
                                                        Align(
                                                          alignment: Alignment.topLeft,
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(6.0),
                                                            child: Text(locale.palavra.posicao + " 10",
                                                              style: Theme.of(context).textTheme.body2,
                                                            ),
                                                          ),
                                                        ),
                                                      ]  
                                                    ),
                                                    Stack(
                                                      children:<Widget>[
                                                        Container(
                                                          height: sizeBox,
                                                          width: sizeBox,
                                                          decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.all(Radius.circular(6)),
                                                              border: Border.all(
                                                                width: 0.2,
                                                                color: Theme.of(context).textTheme.title.color
                                                              ),
                                                              color: Theme.of(context).primaryColor
                                                          ),
                                                          child: StreamBuilder<Object>(
                                                            initialData: false,
                                                            stream: gradeBloc.t11InvalidoOut,
                                                            builder: (context, snapshot) {
                                                              return Padding(
                                                                padding: const EdgeInsets.all(8.0),
                                                                child: Center(
                                                                  child: gridTextField(context,
                                                                    enabled: gradeBloc.grade.t10 != "" ? true : false,
                                                                    errorText: snapshot.data ? locale.palavra.erro : null,
                                                                    controller: t11Controller,
                                                                    onChanged: (text) {
                                                                      gradeBloc.grade.t11 = text;    
                                                                      gradeBloc.updateStream();
                                                                    },
                                                                    onTap: () {
                                                                      gradeBloc.validat1();    
                                                                      gradeBloc.validat2();    
                                                                      gradeBloc.validat3();    
                                                                      gradeBloc.validat4();    
                                                                      gradeBloc.validat5();    
                                                                      gradeBloc.validat6();    
                                                                      gradeBloc.validat7();    
                                                                      gradeBloc.validat8();    
                                                                      gradeBloc.validat9();    
                                                                      gradeBloc.validat10();    
                                                                    }
                                                                  )
                                                                ),
                                                              );
                                                            }
                                                          ),
                                                        ),
                                                        Align(
                                                          alignment: Alignment.topLeft,
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(6.0),
                                                            child: Text(locale.palavra.posicao + " 11",
                                                              style: Theme.of(context).textTheme.body2,
                                                            ),
                                                          ),
                                                        ),
                                                      ]  
                                                    ),
                                                    Stack(
                                                      children:<Widget>[
                                                        Container(
                                                          height: sizeBox,
                                                          width: sizeBox,
                                                          decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.all(Radius.circular(6)),
                                                              border: Border.all(
                                                                width: 0.2,
                                                                color: Theme.of(context).textTheme.title.color
                                                              ),
                                                              color: Theme.of(context).primaryColor
                                                          ),
                                                          child: StreamBuilder<bool>(
                                                            initialData: false,
                                                            stream: gradeBloc.t12InvalidoOut,
                                                            builder: (context, snapshot) {
                                                              return Padding(
                                                                padding: const EdgeInsets.all(8.0),
                                                                child: Center(
                                                                  child: gridTextField(context,
                                                                    enabled: gradeBloc.grade.t11 != "" ? true : false,
                                                                    errorText: snapshot.data ? locale.palavra.erro : null,
                                                                    controller: t12Controller,
                                                                    onChanged: (text) {
                                                                      gradeBloc.grade.t12 = text;    
                                                                      gradeBloc.updateStream();
                                                                    },
                                                                    onTap: () {
                                                                      gradeBloc.validat1();    
                                                                      gradeBloc.validat2();    
                                                                      gradeBloc.validat3();    
                                                                      gradeBloc.validat4();    
                                                                      gradeBloc.validat5();    
                                                                      gradeBloc.validat6();    
                                                                      gradeBloc.validat7();    
                                                                      gradeBloc.validat8();    
                                                                      gradeBloc.validat9();    
                                                                      gradeBloc.validat10();    
                                                                      gradeBloc.validat11();    
                                                                    }
                                                                  )
                                                                ),
                                                              );
                                                            }
                                                          ),
                                                        ),
                                                        Align(
                                                          alignment: Alignment.topLeft,
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(6.0),
                                                            child: Text(locale.palavra.posicao + " 12",
                                                              style: Theme.of(context).textTheme.body2,
                                                            ),
                                                          ),
                                                        ),
                                                      ]  
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(top: 15),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  children: <Widget>[
                                                    Stack(
                                                      children:<Widget>[
                                                        Container(
                                                          height: sizeBox,
                                                          width: sizeBox,
                                                          decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.all(Radius.circular(6)),
                                                              border: Border.all(
                                                                width: 0.2,
                                                                color: Theme.of(context).textTheme.title.color
                                                              ),
                                                              color: Theme.of(context).primaryColor
                                                          ),
                                                          child: StreamBuilder<bool>(
                                                            initialData: false,
                                                            stream: gradeBloc.t13InvalidoOut,
                                                            builder: (context, snapshot) {
                                                              return Center(
                                                                child: gridTextField(context,
                                                                  enabled: gradeBloc.grade.t12 != "" ? true : false,
                                                                  errorText: snapshot.data ? locale.palavra.erro : null,
                                                                  controller: t13Controller,
                                                                  onChanged: (text) {
                                                                    gradeBloc.grade.t13 = text;    
                                                                    gradeBloc.updateStream();
                                                                  },
                                                                  onTap: () {
                                                                    gradeBloc.validat1();    
                                                                    gradeBloc.validat2();    
                                                                    gradeBloc.validat3();    
                                                                    gradeBloc.validat4();    
                                                                    gradeBloc.validat5();    
                                                                    gradeBloc.validat6();    
                                                                    gradeBloc.validat7();    
                                                                    gradeBloc.validat8();    
                                                                    gradeBloc.validat9();    
                                                                    gradeBloc.validat10();    
                                                                    gradeBloc.validat11();    
                                                                    gradeBloc.validat12();    
                                                                  }
                                                                )
                                                              );
                                                            }
                                                          ),
                                                        ),
                                                        Align(
                                                          alignment: Alignment.topLeft,
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(6.0),
                                                            child: Text(locale.palavra.posicao + " 13",
                                                              style: Theme.of(context).textTheme.body2,
                                                            ),
                                                          ),
                                                        ),
                                                      ]  
                                                    ),
                                                    Stack(
                                                      children:<Widget>[
                                                        Container(
                                                          height: sizeBox,
                                                          width: sizeBox,
                                                          decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.all(Radius.circular(6)),
                                                              border: Border.all(
                                                                width: 0.2,
                                                                color: Theme.of(context).textTheme.title.color
                                                              ),
                                                              color: Theme.of(context).primaryColor
                                                          ),
                                                          child: StreamBuilder<Object>(
                                                            initialData: false,
                                                            stream: gradeBloc.t14InvalidoOut,
                                                            builder: (context, snapshot) {
                                                              return Padding(
                                                                padding: const EdgeInsets.all(8.0),
                                                                child: Center(
                                                                  child: gridTextField(context,
                                                                    enabled: gradeBloc.grade.t13 != "" ? true : false,
                                                                    errorText: snapshot.data ? locale.palavra.erro : null,
                                                                    controller: t14Controller,
                                                                    onChanged: (text) {
                                                                      gradeBloc.grade.t14 = text;    
                                                                      gradeBloc.updateStream();
                                                                    },
                                                                    onTap: () {
                                                                      gradeBloc.validat1();    
                                                                      gradeBloc.validat2();    
                                                                      gradeBloc.validat3();    
                                                                      gradeBloc.validat4();    
                                                                      gradeBloc.validat5();    
                                                                      gradeBloc.validat6();    
                                                                      gradeBloc.validat7();    
                                                                      gradeBloc.validat8();    
                                                                      gradeBloc.validat9();    
                                                                      gradeBloc.validat10();    
                                                                      gradeBloc.validat11();    
                                                                      gradeBloc.validat12();    
                                                                      gradeBloc.validat13();    
                                                                    }
                                                                  )
                                                                ),
                                                              );
                                                            }
                                                          ),
                                                        ),
                                                        Align(
                                                          alignment: Alignment.topLeft,
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(6.0),
                                                            child: Text(locale.palavra.posicao + " 14",
                                                              style: Theme.of(context).textTheme.body2,
                                                            ),
                                                          ),
                                                        ),
                                                      ]  
                                                    ),
                                                    Stack(
                                                      children:<Widget>[
                                                        Container(
                                                          height: sizeBox,
                                                          width: sizeBox,
                                                          decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.all(Radius.circular(6)),
                                                              border: Border.all(
                                                                width: 0.2,
                                                                color: Theme.of(context).textTheme.title.color
                                                              ),
                                                              color: Theme.of(context).primaryColor
                                                          ),
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(8.0),
                                                            child: Center(
                                                              child: gridTextField(context,
                                                                enabled: gradeBloc.grade.t14 != "" ? true : false,
                                                                controller: t15Controller,
                                                                onChanged: (text) {
                                                                  gradeBloc.grade.t15 = text;    
                                                                  gradeBloc.updateStream();
                                                                },
                                                                onTap: () {
                                                                  gradeBloc.validat1();    
                                                                  gradeBloc.validat2();    
                                                                  gradeBloc.validat3();    
                                                                  gradeBloc.validat4();    
                                                                  gradeBloc.validat5();    
                                                                  gradeBloc.validat6();    
                                                                  gradeBloc.validat7();    
                                                                  gradeBloc.validat8();    
                                                                  gradeBloc.validat9();    
                                                                  gradeBloc.validat10();    
                                                                  gradeBloc.validat11();    
                                                                  gradeBloc.validat12();    
                                                                  gradeBloc.validat13();    
                                                                  gradeBloc.validat14();    
                                                                }
                                                              )
                                                            ),
                                                          ),
                                                        ),  
                                                        Align(
                                                          alignment: Alignment.topLeft,
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(6.0),
                                                            child: Text(locale.palavra.posicao + " 15",
                                                              style: Theme.of(context).textTheme.body2,
                                                            ),
                                                          ),
                                                        ),
                                                      ]  
                                                    ),
                                                  ],
                                                ),
                                              ),                                                                                                                                          
                                            ],
                                          );
                                        }
                                      )    
                                    ),
                                  ],
                                ),
                              ),
                            )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            ButtonTheme(
                              height: 40,
                              minWidth: 50,
                              child: RaisedButton(
                                color: Colors.grey,//Theme.of(context).primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)
                                ),
                                child: Text(locale.palavra.cancelar,
                                  style: Theme.of(context).textTheme.title,
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              )
                            ),
                            ButtonTheme(
                              height: 40,
                              minWidth: 200,
                              child: RaisedButton(
                                color: Theme.of(context).primaryIconTheme.color,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)
                                ),
                                child: Text(locale.palavra.gravar,
                                  style: Theme.of(context).textTheme.title,
                                ),
                                onPressed: () async {
                                  await gradeBloc.validaForm();
                                  if (!gradeBloc.formInvalido){
                                    print("Nome: "+gradeBloc.grade.nome);
                                    await gradeBloc.saveGrade();
                                    await gradeBloc.getAllGrade();
                                    Navigator.pop(context);
                                  } else {
                                    print("Error form invalido: ");
                                  }
                                },
                              )
                            ),
                          ],
                        ),
                      )
                    ]  
                  )
                )    
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    print("Dispose Grade Detail");
    gradeBloc.limpaValidacoes();
    super.dispose();
  }  
}
