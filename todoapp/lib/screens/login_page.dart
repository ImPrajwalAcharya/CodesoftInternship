import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todoapp/cubit/cubit_name.dart';
import 'package:todoapp/screens/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _namekey = TextEditingController();
  
 @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _namekey.dispose();
  }
  

  @override
  Widget build(BuildContext context) {
    final nameCubit = BlocProvider.of<CubitNameCubit>(context);
   
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // const Text(
            //   'Login Page',
            //   style: TextStyle(fontSize: 20),
            // ),
            Container(
              margin: const EdgeInsets.all(20),
              child: TextField(
                controller: _namekey,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter Your Name',
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
               nameCubit.saveName(_namekey.text);
               _namekey.clear();
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const HomePage()));
                   
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
