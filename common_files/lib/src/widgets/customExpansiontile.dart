// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

const Duration _kExpand = Duration(milliseconds: 200);

/// A single-line [ListTile] with a trailing button that expands or collapses
/// the tile to reveal or hide the [children].
///
/// This widget is typically used with [ListView] to create an
/// "expand / collapse" list entry. When used with scrolling widgets like
/// [ListView], a unique [PageStorageKey] must be specified to enable the
/// [ExpansionTile] to save and restore its expanded state when it is scrolled
/// in and out of view.
///
/// See also:
///
///  * [ListTile], useful for creating expansion tile [children] when the
///    expansion tile represents a sublist.
///  * The "Expand/collapse" section of
///    <https://material.io/guidelines/components/lists-controls.html>.
class CustomExpansionTile extends StatefulWidget {
  /// Creates a single-line [ListTile] with a trailing button that expands or collapses
  /// the tile to reveal or hide the [children]. The [initiallyExpanded] property must
  /// be non-null.
  const CustomExpansionTile({
    Key key,
    this.leading,
    @required this.title,
    this.subtitle,
    this.backgroundColor,
    this.onExpansionChanged,
    this.children = const <Widget>[],
    this.trailing,
    this.initiallyExpanded = false,
  }) : assert(initiallyExpanded != null),
       super(key: key);

  /// A widget to display before the title.
  ///
  /// Typically a [CircleAvatar] widget.
  final Widget leading;

  /// The primary content of the list item.
  ///
  /// Typically a [Text] widget.
  final Widget title;

  /// Additional content displayed below the title.
  ///
  /// Typically a [Text] widget.
  final Widget subtitle;

  /// Called when the tile expands or collapses.
  ///
  /// When the tile starts expanding, this function is called with the value
  /// true. When the tile starts collapsing, this function is called with
  /// the value false.
  final ValueChanged<bool> onExpansionChanged;

  /// The widgets that are displayed when the tile expands.
  ///
  /// Typically [ListTile] widgets.
  final List<Widget> children;

  /// The color to display behind the sublist when expanded.
  final Color backgroundColor;

  /// A widget to display instead of a rotating arrow icon.
  final Widget trailing;

  /// Specifies if the list tile is initially expanded (true) or collapsed (false, the default).
  final bool initiallyExpanded;

  @override
  ExpansionTileState createState() => ExpansionTileState();
}

class ExpansionTileState extends State<CustomExpansionTile> with SingleTickerProviderStateMixin {
  static final Animatable<double> _easeOutTween = CurveTween(curve: Curves.easeOut);
  static final Animatable<double> _easeInTween = CurveTween(curve: Curves.easeIn);
  static final Animatable<double> _halfTween = Tween<double>(begin: 0.0, end: 0.5);

  final ColorTween _borderColorTween = ColorTween();
  final ColorTween _headerColorTween = ColorTween();
  final ColorTween _iconColorTween = ColorTween();
  final ColorTween _backgroundColorTween = ColorTween();

  AnimationController controller;
  Animation<double> _iconTurns;
  Animation<double> _heightFactor;
  Animation<Color> _borderColor;
  Animation<Color> _headerColor;
  Animation<Color> _iconColor;
  Animation<Color> _backgroundColor;

  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(duration: _kExpand, vsync: this);
    _heightFactor = controller.drive(_easeInTween);
    _iconTurns = controller.drive(_halfTween.chain(_easeInTween));
    _borderColor = controller.drive(_borderColorTween.chain(_easeOutTween));
    _headerColor = controller.drive(_headerColorTween.chain(_easeInTween));
    _iconColor = controller.drive(_iconColorTween.chain(_easeInTween));
    _backgroundColor = controller.drive(_backgroundColorTween.chain(_easeOutTween));

    isExpanded = PageStorage.of(context)?.readState(context) ?? widget.initiallyExpanded;
    if (isExpanded){
      setState(() {
        controller.value = 1.0;
      });
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void handleTap() {
    setState(() {
      isExpanded = !isExpanded;
      if (isExpanded) {
        controller.forward();
      } else {
        controller.reverse().then<void>((void value) {
          if (!mounted)
            return;
          setState(() {
            // Rebuild without widget.children.
          });
        });
      }
      PageStorage.of(context)?.writeState(context, isExpanded);
    });
    if (widget.onExpansionChanged != null)
      widget.onExpansionChanged(isExpanded);
  }

  Widget _buildChildren(BuildContext context, Widget child) {
    final Color borderSideColor = _borderColor.value ?? Colors.transparent;

    return Container(
      padding: EdgeInsets.only(right: 10, left: 10, top: 15, bottom: 15),
      decoration: BoxDecoration(
        color: Colors.transparent,
        //_backgroundColor.value ?? Colors.transparent,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        border: Border.all(color: Colors.white70, width: 1)
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTileTheme.merge(
            iconColor: Colors.white,
            //_iconColor.value,
            textColor: _headerColor.value,
            child: ListTile(
              contentPadding: EdgeInsets.all(1),
              onTap: handleTap,
              leading: widget.leading,
              title: widget.title,
              subtitle: widget.subtitle,
              trailing: widget.trailing ?? RotationTransition(
                turns: _iconTurns,
                child: Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: MaterialColor(
                      0xff2fa98d, {
                        50:Color.fromRGBO(136,14,79, .1),
                        100:Color.fromRGBO(136,14,79, .2),
                        200:Color.fromRGBO(136,14,79, .3),
                        300:Color.fromRGBO(136,14,79, .4),
                        400:Color.fromRGBO(136,14,79, .5),
                        500:Color.fromRGBO(136,14,79, .6),
                        600:Color.fromRGBO(136,14,79, .7),
                        700:Color.fromRGBO(136,14,79, .8),
                        800:Color.fromRGBO(136,14,79, .9),
                        900:Color.fromRGBO(136,14,79, 1),
                      }
                    )
                  ),
                  child: Icon(Icons.expand_more, color: Colors.white, size: 20,),
                )
              ),
            ),
          ),
          ClipRect(
            child: Align(
              heightFactor: _heightFactor.value,
              child: child,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void didChangeDependencies() {
    final ThemeData theme = Theme.of(context);
    _borderColorTween
      ..end = theme.dividerColor;
    _headerColorTween
      ..begin = theme.textTheme.subhead.color
      ..end = theme.accentColor;
    _iconColorTween
      ..begin = theme.unselectedWidgetColor
      ..end = theme.accentColor;
    _backgroundColorTween
      ..end = widget.backgroundColor;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final bool closed = !isExpanded && controller.isDismissed;
    return AnimatedBuilder(
      animation: controller.view,
      builder: _buildChildren,
      child: closed ? null : Column(children: widget.children),
    );
  }
}