import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CubitNameCubit extends Cubit<String> {
  CubitNameCubit() : super('admin');
  void loadname() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    var name = _prefs.getString('name') ?? 'admin';
    emit(name);
  }

  void saveName(String name) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.setString('name', name);
    emit(name);
  }

  void removeName() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    _prefs.remove('name');
    emit('');
  }

  Future<String> getName() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    var name = _prefs.getString('name') ?? 'admin';
    return name;
  }
}
