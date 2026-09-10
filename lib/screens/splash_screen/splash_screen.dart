import 'package:flutter/material.dart';
import 'package:subsync/utils/colors.dart';
import 'package:go_router/go_router.dart';
import 'package:subsync/utils/route/route_names.dart';
import 'package:subsync/utils/text_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  double _progressIndicatorValue = 0;
  bool _isProgressCompleted = false;

  @override
  void initState() {
   _startProgress();
    super.initState();
  }

  void _startProgress() async {
    while (!_isProgressCompleted){
      await Future.delayed(const Duration(milliseconds: 20), (){
        if (mounted) {_updateProgress();}
      });
    }
  }

  void _updateProgress() {
    if(_progressIndicatorValue < 1){
      setState(() => _progressIndicatorValue += 0.01);
    }
    else{
      setState(() => (
        _isProgressCompleted = true
      ));
      _navigateToNextScreen();
    }
  }

  void _navigateToNextScreen() async {
    await Future.delayed(const Duration(milliseconds: 40));
      if (mounted) {GoRouter.of(context).go(RouteNames.signInScreen);}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SubSyncColors.backgroundColor,
      body: Stack(
        children: [
          Center(
            child: Text(
              'SubSync',
              style: TextStyle(
                fontSize: 44,
                color: SubSyncColors.brand50,
                fontWeight: FontWeight.w900
              ),
            ),
          ),
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Align(
              alignment: Alignment.center,
              child: Column(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: LinearProgressIndicator(
                      value: _progressIndicatorValue,
                      borderRadius: BorderRadius.circular(14),
                      color: SubSyncColors.brand50,
                      backgroundColor: SubSyncColors.brand80,
                      minHeight: 14,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${(_progressIndicatorValue*100).round()}',
                    style: Theme.of(context).textTheme.labelMd.copyWith(
                        color: SubSyncColors.brand50
                     ) 
                  )
                ],
              ),
            )
          )
        ],
      ),
    );
  }
}