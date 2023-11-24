class TimeDecisionModel {
  int? employeeShiftHistoryId;
  String? message;
  int? status;

  TimeDecisionModel({
    this.employeeShiftHistoryId,
    this.message,
    this.status,
  });

  factory TimeDecisionModel.fromJson(Map<String, dynamic> json) {
    return TimeDecisionModel(
      employeeShiftHistoryId: json["EmployeeShiftHistoryId"],
      message: json["Message"],
      status: json["Status"],
    );
  }

  Map<String, dynamic> toJson() => {
        "employeeShiftHistoryId": employeeShiftHistoryId,
        "message": message,
        "status": status,
      };
}
