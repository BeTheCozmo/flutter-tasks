class Task {
  String? id;
  String title;
  String description;
  String status;
  String priority;

  Task({
    this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.priority
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      status: json['status'],
      priority: json['priority']
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'status': status,
    'priority': priority,
  };
}