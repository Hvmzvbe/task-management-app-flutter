import 'package:first_app/animation/FadeAnimation.dart';
import 'package:first_app/firebase_options.dart';
import 'package:first_app/models/user_model.dart';
import 'package:first_app/providers/auth_provider.dart';
import 'package:first_app/providers/task_provider.dart';
import 'package:first_app/providers/theme_provider.dart';
import 'package:first_app/screen/Auth/login_page.dart';
import 'package:first_app/screen/NavigationMenu.dart';
import 'package:first_app/utils/theme/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import '../models/task_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialiser Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Initialiser Hive
  await Hive.initFlutter();
  
  // Enregistrer les adapters
  Hive.registerAdapter(UserModelAdapter());
  Hive.registerAdapter(TaskAdapter());
  
  // Ouvrir les boxes nécessaires
  await Hive.openBox('preferences');
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthProvider()..initialize(),
        ),
        ChangeNotifierProvider(
          create: (context) => TaskProvider()..initializeWithDemoData(),
        ),
        ChangeNotifierProvider(
          create: (context) => ThemeProvider(),
        ),
      ],
      child: MyApp(),
    ),
  );
} 

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          theme: TAppTheme.lightTheme,
          darkTheme: TAppTheme.darkTheme,
          home: Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              if (authProvider.isLoading) {
                return Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              
              if (authProvider.isAuthenticated) {
                return NavigationMenu();
              }
              
              return MyWidget();
            },
          ),
        );
      },
    );
  }
}

class MyWidget extends StatefulWidget {
  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> with TickerProviderStateMixin{
  late AnimationController _scaleController;
  late AnimationController _scale2Controller;
  late AnimationController _widthController;
  late AnimationController _positionController;
  Animation<double>? _scaleAnimation;
  Animation<double>? _scale2Animation;
  Animation<double>? _widthAnimation;
  Animation<double>? _positionAnimation;
  bool HideIcon = false;
  
  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300)
    );  
    _scaleAnimation = Tween<double>( begin: 1.0,end: 0.8
    ).animate(_scaleController)..addStatusListener((status) {
      if(status == AnimationStatus.completed){
        _widthController.forward();
      }
    });
    _widthController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600)
    );
    _widthAnimation = Tween<double>(begin: 80 ,end: 300
    ).animate(_widthController)..addStatusListener((status) {
      if(status == AnimationStatus.completed){
        _positionController.forward();
      }
    });

    _positionController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000)
    );
    _positionAnimation = Tween<double>(begin: 0 ,end: 200)
    .animate(_positionController)..addStatusListener((status) {
      if(status == AnimationStatus.completed){
        setState(() {
          HideIcon = true;
        });
        _scale2Controller.forward();
      }
    });

    _scale2Controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300)
    );
    _scale2Animation = Tween<double>( begin: 1.0,end: 32.0
    ).animate(_scale2Controller)..addStatusListener((status) {
      if(status == AnimationStatus.completed){
        Navigator.push(context, PageTransition(
          type: PageTransitionType.fade,
          child: Loginpage()
        ));
      }
    });
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _scale2Controller.dispose();
    _widthController.dispose();
    _positionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color.fromRGBO(3, 9, 23, 1),
      body: Container(
        width : double.infinity,
        child: Stack(
          children: <Widget>[
            Positioned(
              top: -100,
              left:0,
              child:FadeAnimation(1, Container(
                width: width,
                height: 400,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/one.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              )), 
            ),
            Positioned(
              top: -150,
              left:0,
              child:FadeAnimation(1.3,Container(
                width: width,
                height: 400,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/one.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              )), 
            ),
            Positioned(
              top: -50,
              left:0,
              child: FadeAnimation(1.6,Container(
                width: width,
                height: 400,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/one.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              )), 
            ),
            Container(
              padding: EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  FadeAnimation(1,Text("Welcome",
                  style: TextStyle(color: Colors.white,fontSize: 40.0,fontWeight: FontWeight.bold),)),
                  SizedBox(height: 20.0,),
                  FadeAnimation(1.3,Text("Collaboration simplifiée pour vos équipes.\nCréez, assignez et suivez vos tâches.",
                  style: TextStyle(color: Colors.white),)),
                  SizedBox(height: 100,),
                  FadeAnimation(1.6,AnimatedBuilder(
                    animation: _scaleController,
                    builder: (context, child)=> Transform.scale(
                    scale: _scaleAnimation!.value,  
                    child:Center(
                    child:AnimatedBuilder(
                      animation: _widthController,
                      builder: (context, child)=> Container(                                 
                        width: _widthAnimation!.value,
                        height: 80,
                        padding: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50.0),
                          color: Colors.blue.withValues(alpha: 0.4)
                          ),
                          child: InkWell(
                            onTap: (){
                              _scaleController.forward();
                            },
                            child: Stack(
                              children:<Widget> [
                                AnimatedBuilder(
                                  animation: _positionController,
                                  builder: (context, child) => Positioned(
                                    left: _positionAnimation!.value,
                                    child: AnimatedBuilder(
                                      animation: _scale2Controller,
                                      builder: (context, child) => Transform.scale(
                                        scale: _scale2Animation!.value,
                                      child: Container(
                                        width: 60,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.blue
                                        ),
                                        child:HideIcon == false ? Icon(Icons.arrow_forward,color: Colors.white,) : Container(),
                                      )
                                      ),
                                    ),
                                  ),
                                ),
                                ]
                            ),
                          ),
                      ),
                    ),
                    )),
                    ) ),
                  SizedBox(height: 50)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}