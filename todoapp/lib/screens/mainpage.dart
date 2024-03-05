import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todoapp/screens/home_page.dart';
import 'package:todoapp/screens/login_page.dart';

import '../cubit/cubit_name.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  final introKey = GlobalKey<IntroductionScreenState>();
  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final nameCubit=BlocProvider.of<CubitNameCubit>(context);
    nameCubit.getName().then((value) {
      if(value!='admin'){
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const HomePage()));
        nameCubit.loadname();
      }
    });
    return SafeArea(
        child: Scaffold(
            body: IntroductionScreen(
                key: introKey,
                showDoneButton: false,
                showSkipButton: false,
                showNextButton: false,
                globalBackgroundColor: Colors.white,
                allowImplicitScrolling: false,
                autoScrollDuration: 5000,
                animationDuration: 1000,
                infiniteAutoScroll: false,
                globalHeader: Align(
                  alignment: Alignment.topRight,
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 16, right: 16),
                      // child: AssetImage()
                    ),
                  ),
                ),
                globalFooter: Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: 60,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        'Let\'s go right away!',
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => const LoginPage()));
                      }),
                ),
                pages: [
          PageViewModel(
            title: "Manage Your Everyday Task List",
            body:
                "Stay on top of your daily tasks with ease by creating, organizing, and tracking your to-do list, ensuring nothing falls through the cracks of your busy schedule.",
            image: Image.asset('./assets/intro.png'),
          ),
          PageViewModel(
            title: "Task Creation and Editing",
            body:
                "Users can add new tasks to their lists, set due dates, add descriptions, and edit or delete tasks as needed.",
            image: Image.asset('./assets/intro.png'),
          ),
          PageViewModel(
            title: "Local Data Storage",
            body:
                "Enjoy peace of mind knowing that your data is securely stored locally on your device, ensuring privacy and accessibility even when offline.",
            image: Image.asset('./assets/intro.png'),
          ),
        ])));
  }
}
