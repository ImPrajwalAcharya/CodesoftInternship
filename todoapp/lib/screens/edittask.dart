import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoapp/model/task.dart';
import 'package:todoapp/screens/home_page.dart';

import '../cubit/cubit_task.dart';

class EditTask extends StatefulWidget {
  final Task task;
  const EditTask({super.key, required this.task});

  @override
  State<EditTask> createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
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
  void initState() {
    super.initState();
    date = DateTime.parse(widget.task.date as String);
    int hour = int.parse(widget.task.time!.substring(10, 12));
    int minute = int.parse(widget.task.time!.substring(13, 15));
    time = TimeOfDay(hour: hour, minute: minute);
    _title.text = widget.task.title as String;
    _description.text = widget.task.description as String;
  }

  @override
  Widget build(BuildContext context) {
    // time = widget.task.time;
    // date = widget.task.date as DateTime;

    final _taskcubit = BlocProvider.of<CubitTaskList>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Task'),
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
                maxLines: 4,
                controller: _description,
                textInputAction: TextInputAction.done,
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
                    id: widget.task.id,
                    title: _title.text,
                    description: _description.text,
                    date: date.toString(),
                    time: time.toString(),
                    done: widget.task.done);
                _taskcubit.updateTask(task);
                Navigator.pop(context);
              },
              child: const Text('Update Task'),
            ),
          ],
        ),
      ),
    );
  }
}
