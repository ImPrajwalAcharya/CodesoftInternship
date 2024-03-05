class Task {
  int? id;
  String? title;
  String? date;
  String? time;
  bool? done;
  String? description;

  Task(
      {required this.id,
      required this.title,
      required this.date,
      required this.time,
      required this.done,
      required this.description});

  Task.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    title = json['title'];
    date = json['date'];
    time = json['time'];
    done = json['done'];
    description = json['description'];
  }

  Map<String, dynamic> toMap() {
    var Map = <String, dynamic>{
      'id': id,
      'title': title,
      'date': date,
      'time': time,
      'done': done == true ? 1 : 0,
      'description': description
    };
    return Map;
  }
}
