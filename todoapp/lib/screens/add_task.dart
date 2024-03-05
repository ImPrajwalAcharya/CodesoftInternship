import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoapp/model/task.dart';

import '../cubit/cubit_task.dart';

class AddTask extends StatefulWidget {
  const AddTask({super.key});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final _title = TextEditingController();
  final _description = TextEditingController();
  TimeOfDay? time;
  DateTime? date;
  getdata() async {
    date = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2025));
    time = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final _taskcubit = BlocProvider.of<CubitTaskList>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Task'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.all(20),
              child: TextField(
                controller: _title,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Title',
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(20),
              child: TextField(
                maxLines: 3,
                controller: _description,
                decoration: const InputDecoration(
                  
                  border: OutlineInputBorder(),
                  labelText: 'Description',
                ),
              ),
            ),
            Container(
              height: 100,
              margin: const EdgeInsets.all(20),
              child: TextButton(
                onPressed: () {
                  getdata();
                },
                child: time != null && date != null
                    ? Text(
                        '${date!.day}/${date!.month}/${date!.year} ${time!.hour}:${time!.minute}')
                    : const Text('Select Date and time'),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Task task = Task(
                  id: Random().nextInt(99999),
                    title: _title.text,
                    description: _description.text,
                    date: date.toString(),
                    time: time.toString(),
                    done: false);
                _taskcubit.addTask(task);
                Navigator.pop(context);
              },
              child: const Text('Add Task'),
            ),
          ],
        ),
      ),
    );
  }
}
