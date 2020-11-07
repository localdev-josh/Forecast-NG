import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import 'package:weather_interview/blocs/weatherBloc.dart';
import 'package:weather_interview/components/animUtils.dart';
import 'package:weather_interview/components/navTabItem.dart';
import 'package:weather_interview/pages/loginPage.dart';
import 'package:weather_interview/pages/weatherHome.dart';

class PagesCheckPoint extends StatefulWidget {
  final AnimationController controller;

  const PagesCheckPoint(this.controller);

  @override
  _PagesCheckPointState createState() => _PagesCheckPointState();
}

class _PagesCheckPointState extends State<PagesCheckPoint>
    with TickerProviderStateMixin {
  final WeatherBloc _weatherBloc = BlocProvider.getBloc<WeatherBloc>();
  Widget pageName;
  bool controlPadding;
  int selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Color(0xff2D2EC6).withOpacity(0.9)
    ));
    controlPadding = true;
    pageName = WeatherHome();
  }

  Future<bool> _onBackPressed() {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Do you want to exit the app?"),
              actions: <Widget>[
                FlatButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: Text("No")),
                FlatButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: Text("Yes")),
              ],
            ));
  }

  onTabTap(int index) {
    setState(() {
      selectedTabIndex = index;
    });
  }

  startAnimation(AnimationController controller) {
    controller.fling(
        velocity: AnimUtil.isBackpanelVisible(controller) ? -1.0 : 1.0);
    if (AnimUtil.isBackpanelVisible(controller) == true) {
      setState(() {
        controlPadding = true;
      });
    } else {
      setState(() {
        controlPadding = false;
      });
    }
    print(AnimUtil.isBackpanelVisible(controller));
  }

  void animate(Widget page) {
    setState(() {
      pageName = page;
    });
    startAnimation(widget.controller);
  }

  void _backViewOnClick(int position) {
    switch (position) {
      case 0:
        animate(WeatherHome());
        break;
      default:
        break;
    }
  }

  Widget activityContainer(BuildContext context, BoxConstraints constraint) {

    final ThemeData _theme = Theme.of(context);
    return SafeArea(
      child: Container(
        child: Stack(
          children: <Widget>[_backView(_theme), _frontView()],
        ),
      ),
    );
  }

  Widget _frontView() {
    return SlideTransition(
        position: _getSlideAnimation(),
        child: ScaleTransition(
          alignment: Alignment.centerLeft,
          scale: _getScaleAnimation(),
          child: _frontViewBody(),
        ));
  }

  Widget _backView(ThemeData theme) {
    return Material(
      child: Container(
        color: Color(0xff0A0BAA),
        width: MediaQuery.of(context).size.width,
        child: SafeArea(
          child: Theme(
            data: ThemeData(brightness: Brightness.dark),
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  width: MediaQuery.of(context).size.width,
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 25, left: 17),
                          child: Text(
                            "Forecast - NG",
                            textScaleFactor: 0.81,
                            style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                          ),
                        ),
                        SizedBox(
                          height: 70,
                        ),
                        NavTabItems(
                          isSelected: selectedTabIndex == 0,
                          onTabTap: () {
                            onTabTap(0);
                            _backViewOnClick(0);
                          },
                          iconName: Icons.home,
                          text: "Weather page",
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: () {
                            _weatherBloc.initialSharedLoginPage().whenComplete(() {
                              startAnimation(widget.controller);
                              Navigator.push(
                                context,
                                PageTransition(
                                  type: PageTransitionType.leftToRight,
                                  child: LoginPage(),
                                ),
                              );
                            });
                          },
                          child: Container(
                            alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.only(bottom: 35),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5.0, vertical: 20.0),
                              decoration:
                              BoxDecoration(color: Color(0xffFAE2BE)),
                              child: Text(
                                "Log Out",
                                style: TextStyle(
                                  color: Color(0xff2D2EC6),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              )
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  width: 50,
                  height: 50,
                  right: 10,
                  top: 20,
                  child: GestureDetector(
                    onTap: () => startAnimation(widget.controller),
                    child: Card(
                      color: Color(0xffFDDCA9),
                      child: Container(
                        height: 20,
                        decoration: BoxDecoration(
                            border: Border.all(color: Color(0xffF8F1F1)),
                            borderRadius: BorderRadius.circular(10)),
                        child: Icon(
                          Icons.close,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _frontViewBody() {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Material(
        elevation: 1,
          borderRadius: BorderRadius.all(
              Radius.circular(controlPadding ? 0 : 10)),
          color: Color(0xff2D2EC6),
          child: Stack(
            children: <Widget>[
              Positioned(
                top: 0,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: pageName,
              ),
              Positioned(
                top: 10,
                left: 5,
                child: IconButton(
                  color: Colors.black,
                  onPressed: () => startAnimation(widget.controller),
                  icon: Icon(Icons.menu),
                ),
              ),
            ],
          )),
    );
  }

  Animation<Offset> _getSlideAnimation() {
    return Tween(begin: Offset(0.4, 0.0), end: Offset(0, 0)).animate(
        CurvedAnimation(parent: widget.controller, curve: Curves.linear));
  }

/*
Front View Scale Animation
*/

  Animation<double> _getScaleAnimation() {
    return Tween(begin: 0.7, end: 1.0).animate(
        CurvedAnimation(parent: widget.controller, curve: Curves.linear));
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: activityContainer,
    );
  }
}
