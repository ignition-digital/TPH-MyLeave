class Company {
  final int id;
  final String companyName;

Company ({
  required this.id,
  required this.companyName,
});

factory Company.fromJson(Map<String,dynamic> json) {
return Company(
  id: json['id'] as int,
  companyName: json['companyName'],
);
}
}
