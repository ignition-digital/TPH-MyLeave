class Employee {
  final int employeeID;
  final String name;
  final String role;
  final int id;


Employee ({
  required this.employeeID,
  required this.name,
  required this.role,
  required this.id,
});

  factory Employee.fromJson(Map<String, dynamic> json) {
  return Employee(
    employeeID: json['employeeID'],
    name: json['name'],
    role: json['role'],
    id: json['id'],
  );
}
}