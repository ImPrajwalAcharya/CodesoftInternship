import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:todoapp/screens/edittask.dart';

import '../cubit/cubit_task.dart';
import '../model/task.dart';
import 'package:intl/intl.dart';
import 'package:dashed_circular_progress_bar/dashed_circular_progress_bar.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  updateTaskStatus(taskcubit, index) {
    taskcubit.updateTaskStatus(index);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final taskcubit = BlocProvider.of<CubitTaskList>(context);

    return BlocBuilder(
      bloc: taskcubit,
      builder: (context, task) {
        if ((task as List<Task>).isEmpty) {
          return const Center(
            child: Text('No Task Added Yet'),
          );
        }
        task.sort((a, b) => a.time!.compareTo(b.time!));
        task.sort((a, b) => a.date!.compareTo(b.date!));
        return Column(
          children: [
            Container(
                padding: EdgeInsets.all(8),
                child: Text(
                  'Task Progress',
                  style: TextStyle(
                      fontFamily: 'OpenSans', fontWeight: FontWeight.w500),
                )),
            Container(
                height: 100,
                width: 100,
                child: DashedCircularProgressBar.aspectRatio(
                  aspectRatio: 1, // width ÷ height
                  valueNotifier: ValueNotifier(
                      task.where((task) => task.done!).length /
                          task.length *
                          100),
                  progress: task.where((task) => task.done!).length /
                      task.length *
                      100,
                  maxProgress: 100,
                  corners: StrokeCap.butt,
                  foregroundColor: Colors.deepPurpleAccent,
                  backgroundColor: const Color(0xffeeeeee),
                  foregroundStrokeWidth: 15,
                  backgroundStrokeWidth: 15,
                  animation: true,
                  child: Center(
                    child: ValueListenableBuilder(
                      valueListenable: ValueNotifier(
                          task.where((task) => task.done!).length /
                              task.length *
                              100),
                      builder: (_, double value, __) => Text(
                        '${value.toInt()}%',
                        style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w300,
                            fontSize: 25),
                      ),
                    ),
                  ),
                )),
            Container(
              margin: EdgeInsets.all(8),
              width: double.infinity,
              height: 1,
              color: Colors.grey,
            ),
            Container(
              child: Text(
                'Your Tasks',
                style: TextStyle(
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Expanded(
              // height: MediaQuery.of(context).size.height*0.7,
              child: ListView.builder(
                itemCount: (task).length,
                itemBuilder: (context, index) {
                  bool done = (task)[index].done!;
                  return InkWell(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.only(top: 20),
                            child: IconButton(
                              onPressed: () {
                                updateTaskStatus(taskcubit, index);
                              },
                              icon: done
                                  ? Icon(
                                      Icons.circle,
                                      size: 25,
                                      color: Colors.redAccent,
                                    )
                                  : Icon(
                                      Icons.circle_outlined,
                                      size: 25,
                                      color: Colors.redAccent,
                                    ),
                            ),
                          ),
                          Container(
                            constraints: BoxConstraints(minHeight: 200),
                            padding: EdgeInsets.all(10),
                            width: MediaQuery.of(context).size.width * 0.65,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                              color: Colors.deepPurpleAccent.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  (task)[index].title.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontFamily: 'OpenSans',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Text(
                                    (task)[index].description.toString(),
                                    style: const TextStyle(
                                        fontFamily: 'OpenSans',
                                        fontSize: 15,
                                        color: Colors.white),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                child: Text(
                                    ((task)[index].time)
                                        .toString()
                                        .substring(10, 15),
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: Colors.deepPurpleAccent,
                                      fontFamily: 'OpenSans',
                                      fontWeight: FontWeight.bold,
                                    )),
                              ),
                              Container(
                                padding: const EdgeInsets.all(2),
                                child: Text(
                                    DateFormat('yyyy-MM-dd').format(
                                        DateTime.parse((task)[index].date!)),
                                    style: const TextStyle(
                                      color: Colors.deepPurpleAccent,

                                      fontSize: 10,
                                      fontFamily: 'OpenSans',
                                      // fontWeight: FontWeight.bold,
                                    )),
                              ),
                              IconButton(
                                  onPressed: () {
                                    taskcubit.removeTask(task[index]);
                                    setState(() {});
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.redAccent,
                                  )),
                              IconButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) {
                                        return EditTask(task: task[index]);
                                      },
                                    ));
                                    setState(() {});
                                  },
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.deepPurpleAccent,
                                  )),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
