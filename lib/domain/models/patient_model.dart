class Patient {
  final int id;
  final String name;
  final String phone;
  final String date;
  final double balanceAmount;
  final Branch branch;
  final PatientDetails details;

  Patient({
    required this.id,
    required this.name,
    required this.phone,
    required this.date,
    required this.balanceAmount,
    required this.branch,
    required this.details,
  });

 factory Patient.fromJson(Map<String, dynamic> json) {
  final detailsList = json['patientdetails_set'] as List<dynamic>? ?? [];

  final details = detailsList.isNotEmpty
      ? PatientDetails.fromJson(detailsList.first)
      : PatientDetails(
          treatmentName: "N/A",
          male: 0,
          female: 0,
        );

  return Patient(
    id: json['id'] ?? 0,
    name: json['name'] ?? '',
    phone: json['phone'] ?? '',
    date: json['date_nd_time'] ?? '',
    balanceAmount: (json['balance_amount'] ?? 0).toDouble(),
    branch: Branch.fromJson(json['branch'] ?? {}),
    details: details,
  );
}

}

class Branch {
  final String name;
  final String location;
  final String phone;

  Branch({required this.name, required this.location, required this.phone});

  factory Branch.fromJson(Map<String, dynamic> json) {
    return Branch(
      name: json['name'] ?? '',
      location: json['location'] ?? '',
      phone: json['phone'] ?? '',
    );
  }
}

class PatientDetails {
  final String treatmentName;
  final int male;
  final int female;

  PatientDetails({
    required this.treatmentName,
    required this.male,
    required this.female,
  });

  factory PatientDetails.fromJson(Map<String, dynamic> json) {
    return PatientDetails(
      treatmentName: json['treatment_name'] ?? '',
      male: int.tryParse(json['male'] ?? '0') ?? 0,
      female: int.tryParse(json['female'] ?? '0') ?? 0,
    );
  }
}
