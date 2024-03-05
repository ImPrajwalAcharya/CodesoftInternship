import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todoapp/cubit/cubit_name.dart';
import 'package:todoapp/screens/add_task.dart';
import 'package:todoapp/screens/edittask.dart';
import 'package:todoapp/screens/login_page.dart';
import 'package:todoapp/screens/task_page.dart';

import '../cubit/cubit_task.dart';
import '../localstorage/storage.dart';
import '../model/task.dart';

int nooftasks = 0;
List<Task> tasks = [];
List<Task> searchedTasks = [];

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    gettasks();
  }

  gettasks() async {
    final storageHelper = Storage();
    storageHelper.open();
    tasks = await storageHelper.getTasks();
  }

  searchTask(query) async {
    searchedTasks = await Storage().searchTasks(query);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final nameCubit = BlocProvider.of<CubitNameCubit>(context);
    final taskCubit = BlocProvider.of<CubitTaskList>(context);
    taskCubit.getTask();
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.redAccent,
              ),
              child: BlocBuilder(
                bloc: nameCubit,
                builder: (context, name) {
                  return Text(
                    'Welcome ${name}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  );
                },
              ),
            ),
            ListTile(
              title: const Text('Logout'),
              onTap: () {
                nameCubit.removeName();
                Navigator.pop(context);
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const LoginPage()));
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Container(
            margin: const EdgeInsets.only(left: 10),
          ),
          Container(
              margin: const EdgeInsets.only(left: 10),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 5),
                    width: MediaQuery.of(context).size.width * 0.6,
                    height: 50,
                    child: TextFormField(
                      onFieldSubmitted: (value) {
                        searchTask(value);
                        if (searchedTasks.length > 0) {
                          showMenu(
                            context: context,
                            position: RelativeRect.fromLTRB(100, 100, 100, 10),
                            items: searchedTasks.map((t) {
                              return PopupMenuItem(
                                child: Text(t.title!),
                                // value: t,
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) {
                                      return EditTask(task: t);
                                    },
                                  ));
                                }, // You can pass the task object as the value
                              );
                            }).toList(),
                          );
                        } else {
                          AlertDialog(
                            title: Text('No Results Found'),
                            content: Text('No Results Found'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('OK'),
                              ),
                            ],
                          );
                        }
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        hintText: 'Search',
                        prefixIcon: Icon(Icons.search),
                      ),
                    ),
                  ),
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.notifications_none_outlined)),
                ],
              ))
        ]),
      ),
      body: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.9,
            padding: EdgeInsets.only(top: 20, left: 20),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BlocBuilder(
                      bloc: nameCubit,
                      builder: (context, name) {
                        return Text(
                          'Hello $name',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.redAccent,
                              fontWeight: FontWeight.bold),
                        );
                      },
                    ),
                    ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll(Colors.redAccent)),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const AddTask()));
                        },
                        child: const Text(
                          'Add new task',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ))
                  ],
                ),
                BlocBuilder(
                  bloc: taskCubit,
                  builder: (context, task) {
                    if (task == []) {
                      taskCubit.getTask();
                    }

                    return Text(
                      '${(task as List<Task>).where((tas) => !tas.done!).length} task pending',
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold),
                    );
                  },
                ),
              ],
            ),
          ),
          Expanded(child: TaskPage()),
        ],
      ),
    );
  }
}
