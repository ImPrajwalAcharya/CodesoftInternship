class Quote {
  String? content;
  String? author;

  Quote({required this.content, required this.author});

  Quote.fromJson(Map<dynamic, dynamic> json) {
    content = json['content'];
    author = json['author'];
  }
  Map<String, dynamic> toMap() {
    var Map = <String, dynamic>{
      'content': content,
      'author': author,
    };
    return Map;
  }
}
