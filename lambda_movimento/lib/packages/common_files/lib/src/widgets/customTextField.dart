import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget customTextField(BuildContext context, {bool autofocus=false, double width=double.infinity, TextEditingController controller, 
  String labelText, String errorText, void Function(String) onChanged}) {
  return Container(
    //height: 50,
    child: TextField(
      autofocus: autofocus,
      controller: controller,
      style: Theme.of(context).textTheme.subtitle,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(bottom: 8),
        labelText: labelText,
        labelStyle: Theme.of(context).textTheme.caption,
        errorText: errorText,
        errorStyle: Theme.of(context).textTheme.body1,
        errorBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white38
          ),
        ),
        focusedErrorBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white38
          ),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white38
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white
          )
        )
      ),
      onChanged: onChanged,
    ),
  );
}

Widget numberTextField(BuildContext context, {bool autofocus=false, double width=double.infinity, TextEditingController controller, 
  String labelText, String errorText, String suffixText,  void Function(String) onChanged}) {
  return Container(
    child: TextField(
      autofocus: autofocus,
      controller: controller,
      keyboardType: TextInputType.number,
      style: Theme.of(context).textTheme.subtitle,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(bottom: 8, top: 3),
        labelText: labelText,
        labelStyle: Theme.of(context).textTheme.caption,
        suffixText: suffixText,
        suffixStyle: Theme.of(context).textTheme.caption,
        errorText: errorText,
        errorStyle: Theme.of(context).textTheme.body1,
        errorBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white38
          ),
        ),
        focusedErrorBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white38
          ),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white38
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white
          )
        )
      ),
      onChanged: onChanged,
    ),
  );
}

Widget gridTextField(BuildContext context, {bool enabled=true ,bool autofocus=false, double width=double.infinity, TextEditingController controller, 
  String labelText, String errorText, void Function(String) onChanged, void Function() onTap}) {
  return Container(
          child: TextField(
            enabled: enabled,
            textAlign: TextAlign.center,
            autofocus: autofocus,
            controller: controller,
            style: Theme.of(context).textTheme.title,
            decoration: InputDecoration(
              labelText: labelText,
              labelStyle: Theme.of(context).textTheme.caption,
              errorText: errorText,
              errorStyle: Theme.of(context).textTheme.body1,
              errorBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
            ),
            onChanged: onChanged,
            onTap: onTap,
            
          ),
        );
}
