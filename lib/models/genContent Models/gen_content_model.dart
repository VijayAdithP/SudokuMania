// ignore_for_file: public_member_api_docs, sort_constructors_first
class GenContent {
  String? explanation;
  int? possibleNumber;
  int? row;
  int? column;

  GenContent({this.explanation, this.possibleNumber, this.row, this.column});

  GenContent.fromJson(Map<String, dynamic> json) {
    explanation = json['explanation'];
    possibleNumber = json['possible_number'];
    row = json['row'];
    column = json['column'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['explanation'] = explanation;
    data['possible_number'] = possibleNumber;
    data['row'] = row;
    data['column'] = column;
    return data;
  }

  // @override
  // String toString() {
  //   return 'GenContent(explanation: $explanation, possibleNumber: $possibleNumber, row: $row, column: $column)';
  // }
}
