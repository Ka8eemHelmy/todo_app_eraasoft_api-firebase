class TaskModelFireBase {
  String? id;
  String? title;
  String? description;
  String? startDate;
  String? endDate;

  TaskModelFireBase({
    this.id,
    this.title,
    this.description,
    this.startDate,
    this.endDate,
  });

  TaskModelFireBase.fromJson(Map<String, dynamic> json){
    title = json['title'];
    description = json['description'];
    startDate = json['startDate'];
    endDate = json['endDate'];
  }

  Map<String, dynamic> toJson(){
    return {
      'title' : title,
      'description' : description,
      'startDate' : startDate,
      'endDate' : endDate,
    };
  }
}
