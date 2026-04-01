enum LeaveType { mc, el }

class LeaveRequest {
  final int id;
  final DateTime dateStart;
  final DateTime dateEnd;
  final LeaveType leaveType;
  final int employeeID;
  final int totalLeave;
  final String approveBy;
  final String status; // pending / approved / rejected

  LeaveRequest({
    required this.id,
    required this.dateStart,
    required this.dateEnd,
    required this.leaveType,
    required this.employeeID,
    required this.totalLeave,
    required this.approveBy,
    this.status = "pending",
  });

  // ✅ Convert JSON → Object
  factory LeaveRequest.fromJson(Map<String, dynamic> json) {
    return LeaveRequest(
      id: json['id'],
      dateStart: DateTime.parse(json['date_start']),
      dateEnd: DateTime.parse(json['date_end']),
      leaveType:
          json['leave_type'] == 'mc' ? LeaveType.mc : LeaveType.el,
      employeeID: json['employeeID'],
      totalLeave: json['totalLeave'],
      approveBy: json['approveBy'] ?? "",
      status: json['status'] ?? "pending",
    );
  }

  // ✅ Convert Object → JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date_start': dateStart.toIso8601String(),
      'date_end': dateEnd.toIso8601String(),
      'leave_type': leaveType == LeaveType.mc ? 'mc' : 'el',
      'employeeID': employeeID,
      'totalLeave': totalLeave,
      'approveBy': approveBy,
      'status': status,
    };
  }

  // ✅ Auto calculate total leave
  static int calculateTotalLeave(DateTime start, DateTime end) {
    return end.difference(start).inDays + 1;
  }
}