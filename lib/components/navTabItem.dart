import 'package:weather_interview/components/tabStyle.dart';
import 'package:weather_interview/components/textStyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class NavTabItems extends StatelessWidget {
  final bool isSelected;
  final String text;
  final IconData iconName;
  final Function onTabTap;

  NavTabItems({this.isSelected, this.text, this.onTabTap, this.iconName});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTabTap,
      child: AnimatedContainer(
          width: 180,
          padding: EdgeInsets.symmetric(
              horizontal: 2.0,
              vertical: 11),
          decoration: isSelected ? selectedTabStyle : defaultTabStyle,
          duration: const Duration(milliseconds: 300),
          child: Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(
                    top: 4.0, left: 17),
                child: Text(text,
                  textScaleFactor: 0.81,
                  style: isSelected ? selectedMenuTextStyle : menuTextStyle,),
              )
            ],
          )),
    );
  }
}
