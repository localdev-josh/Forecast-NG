import 'package:achievement_view/achievement_view.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:page_transition/page_transition.dart';
import 'package:weather_interview/blocs/weatherBloc.dart';

import 'homeController.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  final WeatherBloc _weatherBloc = BlocProvider.getBloc<WeatherBloc>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailControllerSignUp = TextEditingController();
  final _passwordControllerSignUp = TextEditingController();
  bool _validate = false;
  bool _validatePassword = false;
  bool _signUpValidate = false;
  bool _signUpValidatePassword = false;
  bool _controlLoader = false;
  String _email, _password;
  int page = 0;
  LiquidController liquidController;
  UpdateType updateType;
  Animation _animationFirst,
      _animationSecond,
      _animationThird,
      _animationFourth;
  AnimationController _animationControllerFirst,
      _animationControllerSecond,
      _animationControllerThird,
      _animationControllerFourth;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Color(0xff6c33d3).withOpacity(0.9)
    ));
    liquidController = LiquidController();
    _animationControllerFirst =
        AnimationController(duration: Duration(seconds: 3), vsync: this);
    _animationFirst = Tween(begin: -1.0, end: 1.0).animate(CurvedAnimation(
        parent: _animationControllerFirst, curve: Curves.decelerate));
    _animationControllerSecond =
        AnimationController(duration: Duration(seconds: 5), vsync: this);
    _animationSecond = Tween(begin: -1.0, end: 1.0).animate(CurvedAnimation(
        parent: _animationControllerSecond, curve: Curves.fastOutSlowIn));
    _animationControllerThird =
        AnimationController(duration: Duration(seconds: 7), vsync: this);
    _animationThird = Tween(begin: -1.0, end: 1.0).animate(
        CurvedAnimation(parent: _animationControllerThird, curve: Curves.ease));
    _animationControllerFourth =
        AnimationController(duration: Duration(seconds: 7), vsync: this);
    _animationFourth = Tween(begin: -1.0, end: 1.0).animate(CurvedAnimation(
        parent: _animationControllerFourth, curve: Curves.easeIn));
    _animationControllerFirst.repeat();
    _animationControllerSecond.repeat();
    _animationControllerThird.repeat();
    _animationControllerFourth.repeat();
  }

  @override
  void dispose() {
    super.dispose();
    _animationControllerFirst.dispose();
    _animationControllerSecond.dispose();
    _animationControllerThird.dispose();
    _animationControllerFourth.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _emailControllerSignUp.dispose();
    _passwordControllerSignUp.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: LiquidSwipe(
          liquidController: liquidController,
          disableUserGesture: false,
          enableLoop: false,
          pages: [
            Container(
              color: Color(0xff6c33d3),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Stack(
                children: [
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Container(
                            height: MediaQuery.of(context).size.height,
                            width: 2,
                            child: AnimatedBuilder(
                              animation: _animationControllerFirst,
                              builder: (BuildContext context, Widget child) {
                                return Column(
                                  children: <Widget>[
                                    Transform(
                                      transform: Matrix4.translationValues(
                                          0.0, _animationFirst.value * height, 0.0),
                                      child: Container(
                                        height: 20,
                                        color: Color(0xffa281e0),
                                      ),
                                    ),
                                    Transform(
                                      transform: Matrix4.translationValues(
                                          0.0, _animationSecond.value * height, 0.0),
                                      child: Container(
                                        height: 20,
                                        color: Color(0xffa281e0),
                                      ),
                                    ),
                                    Transform(
                                      transform: Matrix4.translationValues(
                                          0.0, _animationFourth.value * height, 0.0),
                                      child: Container(
                                        height: 20,
                                        color: Color(0xffa281e0),
                                      ),
                                    )
                                  ],
                                );
                              },
                            )),
                        Container(
                            height: MediaQuery.of(context).size.height,
                            width: 2,
                            child: AnimatedBuilder(
                              animation: _animationControllerSecond,
                              builder: (BuildContext context, Widget child) {
                                return Column(
                                  children: <Widget>[
                                    Transform(
                                      transform: Matrix4.translationValues(
                                          0.0, _animationSecond.value * height, 0.0),
                                      child: Container(
                                        height: 20,
                                        color: Color(0xffa281e0),
                                      ),
                                    ),
                                    Transform(
                                      transform: Matrix4.translationValues(
                                          0.0, _animationFirst.value * height, 0.0),
                                      child: Container(
                                        height: 20,
                                        color: Color(0xffa281e0),
                                      ),
                                    ),
                                    Transform(
                                      transform: Matrix4.translationValues(
                                          0.0, _animationFourth.value * height, 0.0),
                                      child: Container(
                                        height: 20,
                                        color: Color(0xffa281e0),
                                      ),
                                    )
                                  ],
                                );
                              },
                            )),
                        Container(
                            height: MediaQuery.of(context).size.height,
                            width: 2,
                            child: AnimatedBuilder(
                              animation: _animationControllerThird,
                              builder: (BuildContext context, Widget child) {
                                return Column(
                                  children: <Widget>[
                                    Transform(
                                      transform: Matrix4.translationValues(
                                          0.0, _animationThird.value * height, 0.0),
                                      child: Container(
                                        height: 20,
                                        color: Color(0xffa281e0),
                                      ),
                                    )
                                  ],
                                );
                              },
                            )),
                        Container(
                            height: MediaQuery.of(context).size.height,
                            width: 2,
                            child: AnimatedBuilder(
                              animation: _animationControllerFourth,
                              builder: (BuildContext context, Widget child) {
                                return Column(
                                  children: <Widget>[
                                    Transform(
                                      transform: Matrix4.translationValues(
                                          0.0, _animationFourth.value * height, 0.0),
                                      child: Container(
                                        height: 20,
                                        color: Color(0xffa281e0),
                                      ),
                                    ),
                                    Transform(
                                      transform: Matrix4.translationValues(
                                          0.0, _animationSecond.value * height, 0.0),
                                      child: Container(
                                        height: 20,
                                        color: Color(0xffa281e0),
                                      ),
                                    ),
                                    Transform(
                                      transform: Matrix4.translationValues(
                                          0.0, _animationFirst.value * height, 0.0),
                                      child: Container(
                                        height: 20,
                                        color: Color(0xffa281e0),
                                      ),
                                    )
                                  ],
                                );
                              },
                            ))
                      ],
                    ),
                  ),
                  Positioned(
                      bottom: -10,
                      width: MediaQuery.of(context).size.width,
                      child: Container(
                        height: 250,
                        width: MediaQuery.of(context).size.width,
                        child: SvgPicture.asset(
                          "assets/images/buildings.svg",
                        ),
                      )),
                  Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 15, top: 27),
                            child: Text(
                              "Forecast - NG",
                              textScaleFactor: 0.81,
                              style: TextStyle(
                                  fontSize: 35,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 5),
                            child: Text(
                              "Login with your email and password",
                              textScaleFactor: 0.81,
                              style: GoogleFonts.lato(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xffAF8DEC)),
                            ),
                          ),
                          SizedBox(height: 40,),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                    Theme(
                                      data: Theme.of(context).copyWith(splashColor: Colors.transparent),
                                      child: TextFormField(
                                        controller: _emailController,
                                        autofocus: false,
                                        style: GoogleFonts.lato(fontSize: 16.0, color: Color(0xffffffff)),
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(Icons.email, color: Colors.white,),
                                          prefixStyle: TextStyle(color: Colors.white),
                                          filled: true,
                                          fillColor: Colors.white.withOpacity(0.4),
                                          hintText: 'Email',
                                          hintStyle: TextStyle(color: Colors.white),
                                          errorText: _validate ? 'Email Can\'t Be Empty' : null,
                                          errorStyle: TextStyle(color: Color(0xffFF6600)),
                                          isDense: true,
                                          contentPadding:
                                          const EdgeInsets.all(21),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: Color(0xffFAE2BE).withOpacity(0.7)),
                                            borderRadius: BorderRadius.circular(5),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: Colors.transparent),
                                            borderRadius: BorderRadius.circular(5),
                                          ),

                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 20,),
                                    Theme(
                                      data: Theme.of(context).copyWith(splashColor: Colors.transparent),
                                      child: TextFormField(
                                        controller: _passwordController,
                                        obscureText: true,
                                        autofocus: false,
                                        style: GoogleFonts.lato(fontSize: 16.0, color: Color(0xffffffff)),
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(Icons.lock, color: Colors.white,),
                                          prefixStyle: TextStyle(color: Colors.white),
                                          filled: true,
                                          fillColor: Colors.white.withOpacity(0.4),
                                          hintText: 'Password',
                                          hintStyle: TextStyle(color: Colors.white),
                                          errorText: _validatePassword ? 'Password Can\'t Be Empty' : null,
                                          errorStyle: TextStyle(color: Color(0xffFF6600)),
                                          isDense: true,
                                          contentPadding:
                                          const EdgeInsets.all(21),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: Color(0xffFAE2BE).withOpacity(0.7)),
                                            borderRadius: BorderRadius.circular(5),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: Colors.transparent),
                                            borderRadius: BorderRadius.circular(5),
                                          ),

                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10,),
                                    GestureDetector(
                                      onTap: () {
                                        liquidController.animateToPage(page: 1, duration: 500);
                                        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
                                            statusBarColor: Color(0xff2D2EC6).withOpacity(0.9)
                                        ));
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(vertical: 10),
                                        child: Text(
                                          "Create a new account",
                                          textScaleFactor: 0.81,
                                          style: GoogleFonts.lato(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 20,),
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: 60,
                                      child: RaisedButton(
                                        color: Color(0xffFAE2BE),
                                        onPressed: signIn,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            _controlLoader ? SpinKitDoubleBounce(
                                              color: Color(0xff6c33d3),
                                              size: 15.0,
                                            ) : Container(),
                                            SizedBox(width: 10,),
                                            Text('Sign In',
                                              textScaleFactor: 0.81,
                                              style: TextStyle(
                                                  color: Color(0xff6c33d3),
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 17
                                              ),),
                                          ],
                                        ),
                                      ),
                                    )
                                ]),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color: Color(0xff2D2EC6),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Stack(
                children: [
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Container(
                            height: MediaQuery.of(context).size.height,
                            width: 2,
                            child: AnimatedBuilder(
                              animation: _animationControllerFirst,
                              builder: (BuildContext context, Widget child) {
                                return Column(
                                  children: <Widget>[
                                    Transform(
                                      transform: Matrix4.translationValues(
                                          0.0, _animationFirst.value * height, 0.0),
                                      child: Container(
                                        height: 20,
                                        color: Color(0xffa281e0),
                                      ),
                                    ),
                                    Transform(
                                      transform: Matrix4.translationValues(
                                          0.0, _animationSecond.value * height, 0.0),
                                      child: Container(
                                        height: 20,
                                        color: Color(0xffa281e0),
                                      ),
                                    ),
                                    Transform(
                                      transform: Matrix4.translationValues(
                                          0.0, _animationFourth.value * height, 0.0),
                                      child: Container(
                                        height: 20,
                                        color: Color(0xffa281e0),
                                      ),
                                    )
                                  ],
                                );
                              },
                            )),
                        Container(
                            height: MediaQuery.of(context).size.height,
                            width: 2,
                            child: AnimatedBuilder(
                              animation: _animationControllerSecond,
                              builder: (BuildContext context, Widget child) {
                                return Column(
                                  children: <Widget>[
                                    Transform(
                                      transform: Matrix4.translationValues(
                                          0.0, _animationSecond.value * height, 0.0),
                                      child: Container(
                                        height: 20,
                                        color: Color(0xffa281e0),
                                      ),
                                    ),
                                    Transform(
                                      transform: Matrix4.translationValues(
                                          0.0, _animationFirst.value * height, 0.0),
                                      child: Container(
                                        height: 20,
                                        color: Color(0xffa281e0),
                                      ),
                                    ),
                                    Transform(
                                      transform: Matrix4.translationValues(
                                          0.0, _animationFourth.value * height, 0.0),
                                      child: Container(
                                        height: 20,
                                        color: Color(0xffa281e0),
                                      ),
                                    )
                                  ],
                                );
                              },
                            )),
                        Container(
                            height: MediaQuery.of(context).size.height,
                            width: 2,
                            child: AnimatedBuilder(
                              animation: _animationControllerThird,
                              builder: (BuildContext context, Widget child) {
                                return Column(
                                  children: <Widget>[
                                    Transform(
                                      transform: Matrix4.translationValues(
                                          0.0, _animationThird.value * height, 0.0),
                                      child: Container(
                                        height: 20,
                                        color: Color(0xffa281e0),
                                      ),
                                    )
                                  ],
                                );
                              },
                            )),
                        Container(
                            height: MediaQuery.of(context).size.height,
                            width: 2,
                            child: AnimatedBuilder(
                              animation: _animationControllerFourth,
                              builder: (BuildContext context, Widget child) {
                                return Column(
                                  children: <Widget>[
                                    Transform(
                                      transform: Matrix4.translationValues(
                                          0.0, _animationFourth.value * height, 0.0),
                                      child: Container(
                                        height: 20,
                                        color: Color(0xffa281e0),
                                      ),
                                    ),
                                    Transform(
                                      transform: Matrix4.translationValues(
                                          0.0, _animationSecond.value * height, 0.0),
                                      child: Container(
                                        height: 20,
                                        color: Color(0xffa281e0),
                                      ),
                                    ),
                                    Transform(
                                      transform: Matrix4.translationValues(
                                          0.0, _animationFirst.value * height, 0.0),
                                      child: Container(
                                        height: 20,
                                        color: Color(0xffa281e0),
                                      ),
                                    )
                                  ],
                                );
                              },
                            ))
                      ],
                    ),
                  ),
                  Positioned(
                      bottom: -10,
                      width: MediaQuery.of(context).size.width,
                      child: Container(
                        height: 250,
                        width: MediaQuery.of(context).size.width,
                        child: SvgPicture.asset(
                          "assets/images/farm.svg",
                        ),
                      )),
                  Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 15, top: 27),
                            child: Text(
                              "Forecast - NG",
                              textScaleFactor: 0.81,
                              style: TextStyle(
                                  fontSize: 35,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 5),
                            child: Text(
                              "Create an account with us",
                              textScaleFactor: 0.81,
                              style: GoogleFonts.lato(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xffAF8DEC)),
                            ),
                          ),
                          SizedBox(height: 40,),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Theme(
                                    data: Theme.of(context).copyWith(splashColor: Colors.transparent),
                                    child: TextFormField(
                                      controller: _emailControllerSignUp,
                                      autofocus: false,
                                      style: GoogleFonts.lato(fontSize: 16.0, color: Color(0xffffffff)),
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(Icons.email, color: Colors.white,),
                                        prefixStyle: TextStyle(color: Colors.white),
                                        filled: true,
                                        fillColor: Colors.white.withOpacity(0.4),
                                        hintText: 'Email',
                                        hintStyle: TextStyle(color: Colors.white),
                                        errorText: _signUpValidate ? 'Email Can\'t Be Empty' : null,
                                        isDense: true,
                                        contentPadding:
                                        const EdgeInsets.all(21),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Color(0xffFAE2BE).withOpacity(0.7)),
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.transparent),
                                          borderRadius: BorderRadius.circular(5),
                                        ),

                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20,),
                                  Theme(
                                    data: Theme.of(context).copyWith(splashColor: Colors.transparent),
                                    child: TextFormField(
                                      controller: _passwordControllerSignUp,
                                      autofocus: false,
                                      style: GoogleFonts.lato(fontSize: 16.0, color: Color(0xffffffff)),
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(Icons.lock, color: Colors.white,),
                                        prefixStyle: TextStyle(color: Colors.white),
                                        filled: true,
                                        fillColor: Colors.white.withOpacity(0.4),
                                        hintText: 'Password',
                                        hintStyle: TextStyle(color: Colors.white),
                                        errorText: _signUpValidatePassword ? 'Password Can\'t Be Empty' : null,
                                        isDense: true,
                                        contentPadding:
                                        const EdgeInsets.all(21),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Color(0xffFAE2BE).withOpacity(0.7)),
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.transparent),
                                          borderRadius: BorderRadius.circular(5),
                                        ),

                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10,),
                                  GestureDetector(
                                    onTap: () {
                                      liquidController.animateToPage(page: 0, duration: 500);
                                      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
                                          statusBarColor: Color(0xff6c33d3).withOpacity(0.9)
                                      ));
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(vertical: 10),
                                      child: Text(
                                        "Already have an account",
                                        textScaleFactor: 0.81,
                                        style: GoogleFonts.lato(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20,),
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 60,
                                    child: RaisedButton(
                                      color: Color(0xffFAE2BE),
                                      onPressed: signUp,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          _controlLoader ? SpinKitDoubleBounce(
                                            color: Color(0xff2D2EC6),
                                            size: 15.0,
                                          ) : Container(),
                                          SizedBox(width: 10,),
                                          Text('Create account',
                                            textScaleFactor: 0.81,
                                            style: TextStyle(
                                                color: Color(0xff2D2EC6),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 17
                                            ),),
                                        ],
                                      ),
                                    ),
                                  )
                                ]),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void signUp() async {
    setState(() {
      _emailControllerSignUp.text.isEmpty ? _signUpValidate = true : _signUpValidate = false;
      _passwordControllerSignUp.text.isEmpty ? _signUpValidatePassword = true : _signUpValidatePassword = false;
    });
    if(!_signUpValidate && !_signUpValidatePassword) {
      setState(() {
        _controlLoader = true;
      });
      try{
        UserCredential user = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _emailControllerSignUp.text, password: _passwordControllerSignUp.text);
        user.user.sendEmailVerification();
        setState(() {
          _controlLoader = false;
        });
        AchievementView(
          context,
          title: "Verification",
          subTitle: "Check your email for verification",
          alignment: Alignment.topRight,
          color: Color(0xff869986),
          isCircle: false,
          listener: (status) {
            print(status);
          },
        )..show();
        liquidController.animateToPage(page: 0, duration: 500);
      } catch(e) {
        print("Error ${e.message}");
        AchievementView(
          context,
          title: "Signup error!",
          subTitle: e.message,
          alignment: Alignment.topRight,
          color: Colors.red,

          isCircle: false,
          listener: (status) {
            print(status);
          },
        )..show();
        setState(() {
          _controlLoader = false;
        });
      }
    }
  }

  void signIn() async {
    print("Got here");
    setState(() {
      _emailController.text.isEmpty ? _validate = true : _validate = false;
      _passwordController.text.isEmpty ? _validatePassword = true : _validatePassword = false;
    });
    if(!_validate && !_validatePassword) {
      setState(() {
        _controlLoader = true;
      });
      print(_emailController.text);
      try{
        print(_emailController.text);
        UserCredential user = await FirebaseAuth.instance.signInWithEmailAndPassword(email: _emailController.text, password: _passwordController.text);
        setState(() {
          _controlLoader = false;
        });
        _weatherBloc.user = user;
        _weatherBloc.initialSharedWeatherPage();
        AchievementView(
          context,
          title: "Login Successful",
          subTitle: "User authentication successful",
          alignment: Alignment.topRight,
          color: Color(0xff4BB543),
          duration: Duration(seconds: 1),
          isCircle: false,
          listener: (status) {
            print(status);
          },
        )..show();
        Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.rightToLeft,
            child: HomeController(),
          ),
        );
      } catch(e) {
        print("Error ${e.message}");
        AchievementView(
          context,
          title: "Login error!",
          subTitle: e.message,
          alignment: Alignment.topRight,
          color: Colors.red,

          isCircle: false,
          listener: (status) {
            print(status);
          },
        )..show();
        setState(() {
          _controlLoader = false;
        });
      }
    }
  }
}
