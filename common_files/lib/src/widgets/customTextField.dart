import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget customTextField(BuildContext context, {bool autofocus=false, bool enabled=true, double width=double.infinity, TextEditingController controller, 
  String labelText, String errorText, bool obscureText=false, TextInputType keyboardType = TextInputType.text, void Function(String) onChanged, void Function() onTap}) {
  return Container(
    //height: 50,
    child: TextField(
      onTap: onTap,
      autofocus: autofocus,
      enabled: enabled,
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      style: Theme.of(context).textTheme.subhead,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(bottom: 8),
        labelText: labelText,
        labelStyle: Theme.of(context).textTheme.subhead,
        errorText: errorText,
        errorMaxLines: 1,
        errorStyle: TextStyle(
          fontSize: Theme.of(context).textTheme.subhead.fontSize,
          fontStyle: Theme.of(context).textTheme.subhead.fontStyle,
          fontWeight: Theme.of(context).textTheme.subhead.fontWeight,
          color: Colors.red,
        ),
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

Widget customCenteredField(BuildContext context, {bool autofocus=false, bool enabled=true, double width=double.infinity, TextEditingController controller, 
  String labelText, String errorText, bool obscureText=false, TextInputType keyboardType = TextInputType.text, void Function(String) onChanged}) {
  return TextField(
    textAlign: TextAlign.center,
    autofocus: autofocus,
    enabled: true,
    controller: controller,
    keyboardType: TextInputType.text,
    obscureText: false,
    style: Theme.of(context).textTheme.subtitle,
    decoration: InputDecoration(
      labelText: labelText,
      contentPadding: EdgeInsets.all(8),
      hintStyle: Theme.of(context).textTheme.subhead,
      labelStyle: Theme.of(context).textTheme.body2,
      errorText: errorText,
      errorStyle: TextStyle(
        fontStyle: Theme.of(context).textTheme.body2.fontStyle,
        color: Colors.red
      ),
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
  );
}

Widget customCenteredWebField(BuildContext context, {bool autofocus=false, bool enabled=true, double width=double.infinity, TextEditingController controller, 
  String labelText, String errorText, bool obscureText=false, TextInputType keyboardType = TextInputType.text, void Function(String) onChanged}) {
  return TextField(
    textAlign: TextAlign.center,
    autofocus: autofocus,
    enabled: true,
    controller: controller,
    keyboardType: TextInputType.text,
    obscureText: false,
    style: Theme.of(context).textTheme.subtitle,
    decoration: InputDecoration(
      labelText: labelText,
      contentPadding: EdgeInsets.all(8),
      hintStyle: Theme.of(context).textTheme.subhead,
      labelStyle: Theme.of(context).textTheme.body2,
      errorText: errorText,
      errorStyle: TextStyle(
        fontStyle: Theme.of(context).textTheme.body2.fontStyle,
        color: Colors.red
      ),
      errorBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.black
        ),
      ),
      focusedErrorBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.black
        ),
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.black
        ),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.black
        )
      )
    ),
   onChanged: onChanged,
  );
}

Widget customWebTextField(BuildContext context, {bool autofocus=false, double width=double.infinity, TextEditingController controller, 
  String labelText, String errorText, bool obscureText=false, void Function(String) onChanged}) {
  return Container(
    width: width,
    //height: 50,
    child: TextField(
      autofocus: autofocus,
      controller: controller,
      obscureText: obscureText,
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
            color: Colors.grey
          ),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey
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
      style: Theme.of(context).textTheme.subhead,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(bottom: 8, top: 3),
        labelText: labelText,
        labelStyle: Theme.of(context).textTheme.subhead,
        suffixText: suffixText,
        suffixStyle: Theme.of(context).textTheme.subhead,
        errorText: errorText,
        errorStyle: TextStyle(
          fontStyle: Theme.of(context).textTheme.body2.fontStyle,
          color: Colors.red
        ),
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

Widget numberTextFieldWeb(BuildContext context, {bool autofocus=false, double width=double.infinity, TextEditingController controller, 
  String labelText, String errorText, String suffixText,  void Function(String) onChanged}) {
  return Container(
    height: 40,
    child: TextField(
      autofocus: autofocus,
      controller: controller,
      keyboardType: TextInputType.number,
      style: Theme.of(context).textTheme.subhead,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(bottom: 8, top: 3),
        labelText: labelText,
        labelStyle: Theme.of(context).textTheme.caption,
        suffixText: suffixText,
        suffixStyle: Theme.of(context).textTheme.headline3,
        errorText: errorText,
        errorStyle: TextStyle(
          fontStyle: Theme.of(context).textTheme.body2.fontStyle,
          color: Colors.red
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey,
            width: 1
          )
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey,
            width: 1
          )
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey,
            width: 1
          )
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey,
            width: 1
          )
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey,
            width: 1
          )
        ),
      ),
      onChanged: onChanged,
    ),
  );
}

Widget gridTextField(BuildContext context, {int maxLength, bool enabled=true ,bool autofocus=false, double width=double.infinity, TextEditingController controller, 
  String labelText, String errorText, void Function(String) onChanged, void Function() onTap}) {
  return Container(
          child: TextField(
            enabled: enabled,
            maxLength: maxLength,
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

Widget customBorderTextField(BuildContext context, {bool autofocus=false, bool enabled=true, double width=double.infinity, int maxLines, TextEditingController controller, 
  String labelText, String hintText, String errorText, bool obscureText=false, TextInputType keyboardType = TextInputType.text, void Function(String) onChanged}) {
  return Container(
    //height: 50,
    child: TextField(
      autofocus: autofocus,
      enabled: enabled,
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      maxLines: 6,
      style: Theme.of(context).textTheme.subtitle,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.white,fontSize: 16),
        contentPadding: EdgeInsets.only(bottom: 8,left: 10),
        labelText: labelText,
        labelStyle: Theme.of(context).textTheme.caption,
        errorText: errorText,
        errorStyle: Theme.of(context).textTheme.body1,
        border: new OutlineInputBorder(
              borderSide: new BorderSide(color: Colors.white38)
        ),
        errorBorder: OutlineInputBorder(
              borderSide: new BorderSide(color: Colors.white)
        ),
        focusedErrorBorder: OutlineInputBorder(
              borderSide: new BorderSide(color: Colors.white)
        ),
        enabledBorder: OutlineInputBorder(
              borderSide: new BorderSide(color: Colors.white38)
        ),
        focusedBorder: OutlineInputBorder(
              borderSide: new BorderSide(color: Colors.white)
        ),
      ),
      onChanged: onChanged,
    ),
  );
}
