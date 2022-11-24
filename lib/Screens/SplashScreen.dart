import 'package:gard_msg_flutter/Helper/LocalDatabase.dart';
import 'package:flutter/material.dart';
import 'HomeScreen.dart';
import 'LoginScreen.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = '/SplashScreen';

  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  AnimationController? controller;
  Animation? animation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    animation = CurvedAnimation(parent: controller!, curve: Curves.decelerate);
    controller?.forward();
    animation?.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        // todo: check Internet Package with Google to access User Data
        //Navigator.of(context).pushNamed(LoginScreen.routeName);
        print('checking login......');
        LocalDatabase.isUserLogined().then((value) => {
        print('login.value is...$value'),
              if (value)
                {
                  Navigator.of(context).pushNamed(HomeScreen.routeName),
                }
              else
                {
                  Navigator.of(context).pushNamed(LoginScreen.routeName),
                }
            });
      }
    });
    controller?.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    var _hight = mediaQueryData.size.height;
    var _width = mediaQueryData.size.width;

    return Scaffold(
      body: Container(
        width: _width,
        height: _hight,
        child: Image.asset(
            width: _width,
            height: _hight,
            fit: BoxFit.fill,
            'assets/images/ic_splash.png'),
      ),
    );
  }
}
