class DiaryData {
  String id;
  String date;
  String title;
  String content;
  String day;

  DiaryData({this.id, this.date, this.title, this.content, this.day});

  DiaryData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    title = json['title'];
    content = json['content'];
    day = json['day'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['date'] = this.date;
    data['title'] = this.title;
    data['content'] = this.content;
    data['day'] = this.day;
    return data;
  }
}

class DiaryList {
  static final DiaryList _productList = new DiaryList._internal();

  factory DiaryList() {
    return _productList;
  }
  DiaryList._internal();

  List<DiaryData> diary = new List<DiaryData>();
}