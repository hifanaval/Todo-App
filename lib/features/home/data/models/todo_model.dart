// To parse this JSON data, do
//
//     final todoDataModel = todoDataModelFromJson(jsonString);

import 'dart:convert';

List<TodoDataModel> todoDataModelFromJson(String str) => List<TodoDataModel>.from(json.decode(str).map((x) => TodoDataModel.fromJson(x)));

String todoDataModelToJson(List<TodoDataModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TodoDataModel {
    int? userId;
    int? id;
    String? title;
    bool? completed;

    TodoDataModel({
        this.userId,
        this.id,
        this.title,
        this.completed,
    });

    factory TodoDataModel.fromJson(Map<String, dynamic> json) => TodoDataModel(
        userId: json["userId"],
        id: json["id"],
        title: json["title"],
        completed: json["completed"],
    );

    Map<String, dynamic> toJson() => {
        "userId": userId,
        "id": id,
        "title": title,
        "completed": completed,
    };

    TodoDataModel copyWith({
        int? userId,
        int? id,
        String? title,
        bool? completed,
    }) {
        return TodoDataModel(
            userId: userId ?? this.userId,
            id: id ?? this.id,
            title: title ?? this.title,
            completed: completed ?? this.completed,
        );
    }

    // Convert to Drift companion
    Map<String, dynamic> toCompanionJson() {
        return {
            'id': id,
            'title': title ?? '',
            'completed': completed ?? false,
            'isFavorite': false,
        };
    }
}
