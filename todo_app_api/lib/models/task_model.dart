class TaskModel {
  String? id;
  String? name;
  String? description;
  String? startTime;
  String? endTime;
  String? status;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;
  int? v;

  bool isEditing = false;
  bool isDeleting = false;
  bool isConfirmDelete = false;

  TaskModel({
    this.id,
    this.name,
    this.description,
    this.startTime,
    this.endTime,
    this.status,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'description': description,
      'start_time': startTime,
      'end_time': endTime,
      'status': status,
      'deletedAt': deletedAt,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
    };
  }

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['_id'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      startTime: json['start_time'] as String?,
      endTime: json['end_time'] as String?,
      status: json['status'] as String?,
      deletedAt: json['deletedAt'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      v: json['__v'] as int?,
    );
  }
}