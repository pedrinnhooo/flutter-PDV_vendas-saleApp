import 'dart:async';
import 'package:common_files/common_files.dart';
import 'package:fluggy/src/venda/movimento_caixa/movimento_caixa_valor/movimento_caixa_valor_page.dart';
import 'package:flutter/material.dart';

class Animator extends StatefulWidget {
  final Widget child;
  final Duration time;
  final Function onTap;
  final GestureLongPressCallback onLongPress;
  final SharedVendaBloc bloc; 
  Animator(this.child, this.time, this.onTap, this.onLongPress, this.bloc);

  @override
  _AnimatorState createState() => _AnimatorState();
}

class _AnimatorState extends State<Animator> with TickerProviderStateMixin {
  OverlayEntry overlayEntry;
  AnimationController animationController;
  AnimationController fadeTransitionController;
  Animation<double> animationGridItemdx;
  Animation<double> animationGridItemdy;
  Animation animation, fadeAnimation;
  Animation<double> endDx;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(duration: Duration(milliseconds: 250), vsync: this);
    fadeTransitionController = AnimationController(duration: Duration(milliseconds: 250), vsync: this);
    fadeAnimation = fadeTransitionController.drive(Tween<double>(begin: 0.95, end: 0.0));
    animation = CurvedAnimation(parent: animationController, curve: Curves.easeInOut);
    animationGridItemdx = Tween<double>(begin: 0, end: 0).animate(animation);
    animationGridItemdy = Tween<double>(begin: 0, end: 420.0).animate(animation);
  }

  showOverlay(BuildContext context) async {
    RenderBox renderBox = context.findRenderObject();
    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);
    //Coluna do meio
    if(offset.dx > 8 && offset.dx < 200){
      animationGridItemdy = Tween<double>(begin: 0, end: 90.0).animate(animation);
      if(offset.dy >= 470 && offset.dy < 550){
        animationGridItemdy = Tween<double>(begin: 0, end: 200.0).animate(animation);
      } else if(offset.dy >= 350 && offset.dy < 470){
        animationGridItemdy = Tween<double>(begin: 0, end: 350.0).animate(animation);
      } else if(offset.dy >= 225 && offset.dy < 350){
        animationGridItemdy = Tween<double>(begin: 0, end: 430.0).animate(animation);
      }
    } else if(offset.dx == 8){ //Primeira Coluna
      animationGridItemdx = Tween<double>(begin: 0, end: 90.0).animate(animation);
      animationGridItemdy = Tween<double>(begin: 0, end: 430.0).animate(animation);
      if(offset.dy >= 470 && offset.dy < 550){
        animationGridItemdy = Tween<double>(begin: 0, end: 200.0).animate(animation);
      } else if(offset.dy >= 350 && offset.dy < 470){
        animationGridItemdy = Tween<double>(begin: 0, end: 350.0).animate(animation);
      } else if(offset.dy >= 225 && offset.dy < 350){
        animationGridItemdy = Tween<double>(begin: 0, end: 430.0).animate(animation);
      } else if(offset.dy >= 550){
        animationGridItemdx = Tween<double>(begin: 0, end: 90.0).animate(animation);
        animationGridItemdy = Tween<double>(begin: 0, end: 90.0).animate(animation);
        fadeAnimation = fadeTransitionController.drive(Tween<double>(begin: 0.6, end: 0.0));
      }
    } else if(offset.dx >= 256){ // Ultima coluna
      animationGridItemdx = Tween<double>(begin: 0, end: -90.0).animate(animation);
      animationGridItemdy = Tween<double>(begin: 0, end: 430.0).animate(animation);
      if(offset.dy >= 470 && offset.dy < 550){
        animationGridItemdy = Tween<double>(begin: 0, end: 200.0).animate(animation);
      } else if(offset.dy >= 350 && offset.dy < 470){
        animationGridItemdy = Tween<double>(begin: 0, end: 350.0).animate(animation);
      } else if(offset.dy >= 225 && offset.dy < 350){
        animationGridItemdy = Tween<double>(begin: 0, end: 430.0).animate(animation);
      } else if(offset.dy >= 550){
        animationGridItemdx = Tween<double>(begin: 0, end: -90.0).animate(animation);
        animationGridItemdy = Tween<double>(begin: 0, end: 90.0).animate(animation);
        fadeAnimation = fadeTransitionController.drive(Tween<double>(begin: 0.6, end: 0.0));
      }
    }
    
    OverlayState overlayState = Overlay.of(context);
    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx,
        top: offset.dy + 5,
        width: size.width,
        child: Material( 
          color: Colors.transparent,
          child: AnimatedBuilder(
            animation: animation,
            builder: (BuildContext context, Widget child) {
              print(animationGridItemdy.value.toString());
              return Transform.translate(
                offset: Offset(animationGridItemdx.value, animationGridItemdy.value),
                child: AnimatedContainer(
                  height: (size.height - (fadeAnimation.value * 30)),
                  width: (size.width - (fadeAnimation.value * 130)),
                  duration: animationController.duration,
                  child: FadeTransition(
                    opacity: fadeAnimation,
                    child: widget.child
                  )
                ),
              );
            },
          )
        )
      )
    );
    overlayState.insert(overlayEntry);
    await Future.delayed(animationController.duration);
    try {
      overlayEntry.remove();
    } catch (e) {
      overlayState.dispose();
    }
    animationController.reset();
    fadeTransitionController.reset();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: widget.child,
      onLongPress: widget.onLongPress,
      onTap: () {
        // if(widget.bloc.statusCaixa == StatusCaixa.fechado){
        //   showDialog(
        //     context: context,
        //     child: CustomDialogConfirmation(
        //       title: "Alerta",
        //       description: "Não é possível realizar a venda pois o caixa está fechado.",
        //       buttonOkText: "Sair",
        //       funcaoBotaoCancelar: () {
        //         Navigator.pop(context);
        //       },                                                                                 
        //       funcaoBotaoOk: () {
        //         Navigator.pop(context);
        //       }, 
        //       buttonCancelText: "",
        //     )
        //   );
        // } else if(widget.bloc.statusCaixa == StatusCaixa.necessitaAbertura){
        //   showDialog(
        //     context: context,
        //     child: CustomDialogConfirmation(
        //       title: "Alerta",
        //       description: "O caixa ainda não foi aberto, deseja realizar a abertura agora?",
        //       buttonOkText: "Abrir caixa",
        //       funcaoBotaoOk: () {
        //         Navigator.pop(context);
        //         Navigator.push(context, 
        //           MaterialPageRoute(
        //             settings: RouteSettings(name: '/MovimentoCaixaValor'),
        //             builder: (context) => MovimentoCaixaValorPage(tipoMovimentoCaixa: TipoMovimentoCaixa.abertura)
        //           )
        //         );
        //       }, 
        //       buttonCancelText: "Cancelar",
        //       funcaoBotaoCancelar: () {
        //         Navigator.pop(context);
        //       },
        //     )
        //   );
        // } else
        if(animationController.isAnimating == false){
          widget.onTap();
          showOverlay(context);
          animationController.forward();
          fadeTransitionController.forward();
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
    fadeTransitionController.dispose();
  }
}


class GridItemBuilder extends StatelessWidget {
  final Widget child;
  final Function onTap;
  final GestureLongPressCallback onLongPress;
  final SharedVendaBloc bloc;
  GridItemBuilder({this.child, this.onTap, this.onLongPress, this.bloc});

  @override
  Widget build(BuildContext context) {
    return Animator(child, Duration(milliseconds: 250), onTap, onLongPress, bloc);
  }
}