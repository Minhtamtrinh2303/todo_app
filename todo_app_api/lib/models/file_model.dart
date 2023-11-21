class FileModel {
  String? file;

  FileModel({
    this.file,
  });

  Map<String, dynamic> toJson() {
    return {
      'file': file,
    };
  }

  factory FileModel.fromJson(Map<String, dynamic> json) {
    return FileModel(
      file: json['file'] as String?,
    );
  }
}