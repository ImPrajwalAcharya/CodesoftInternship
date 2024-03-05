import 'package:bloc/bloc.dart';
import 'package:todoapp/localstorage/storage.dart';
import '../model/task.dart';

class CubitTaskList extends Cubit<List<Task>> {
  CubitTaskList() : super([]);

  void addTask(Task task) async {
    state.add(task);
    emit(state);
    var storage = Storage();
    await storage.open();
    await storage.addTask(task);
  }

  getTask() async {
    List<Task> state = await Storage().getTasks();

    emit(state);
  }

  refresh() async {}

  void removeTask(Task task) async {
    state.remove(task);
    emit(state);
    await Storage().deleteTask(task.id);
  }

  void updateTaskStatus(index) async {
    state.elementAt(index).done = !(state.elementAt(index).done)!;
    await Storage().updateTaskStatus(
        state.elementAt(index).id, state.elementAt(index).done);
    emit(state);
  }

  void updateTask(Task task) async {
    await Storage().updateTask(task);
    state.forEach((element) {
      if (element.id == task.id) {
        element = task;
      }
    });
    emit(state);
  }

 
}
