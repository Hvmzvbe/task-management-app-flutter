import 'package:first_app/animation/FadeAnimation.dart';
import 'package:first_app/screen/Auth/login_page.dart';
import 'package:first_app/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:page_transition/page_transition.dart';
void main()=> runApp(
  GetMaterialApp(
    debugShowCheckedModeBanner: false,
    themeMode: ThemeMode.system, // Détecte automatiquement le mode système
    theme: TAppTheme.lightTheme,  // Thème clair
    darkTheme: TAppTheme.darkTheme, // Thème sombre
    home: MyWidget(),
  )
);
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
    // TODO: implement initState
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