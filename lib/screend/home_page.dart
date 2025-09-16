import 'package:flutter/material.dart';
import 'package:noviindus_patients/presentation/providers/auth_provider.dart';
import 'package:noviindus_patients/presentation/providers/patient_provider.dart';
import 'package:provider/provider.dart';
import '../../domain/models/patient_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final patientProvider = Provider.of<PatientProvider>(context, listen: false);
      if (authProvider.token != null) {
        patientProvider.fetchPatients(authProvider.token!);
      }
    });
  }

  Future<void> _refresh() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final patientProvider = Provider.of<PatientProvider>(context, listen: false);
    if (authProvider.token != null) {
      await patientProvider.fetchPatients(authProvider.token!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final patientProvider = Provider.of<PatientProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Patient List"),
        backgroundColor: const Color(0xFF006837),
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: patientProvider.loading
            ? const Center(child: CircularProgressIndicator())
            : patientProvider.error != null
                ? Center(child: Text("Error: ${patientProvider.error}"))
                : patientProvider.patients.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Image.asset(
                            //   "lib/assets/images/empty_list.png",
                            //   height: 200,
                            // ),
                            const SizedBox(height: 20),
                            const Text(
                              "No patients found",
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: patientProvider.patients.length,
                        itemBuilder: (context, index) {
                          final Patient patient = patientProvider.patients[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: ListTile(
                              title: Text(patient.name),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Phone: ${patient.phone}"),
                                  Text("Branch: ${patient.branch.name}"),
                                  Text("Treatment: ${patient.details.treatmentName}"),
                                  Text("Date: ${patient.date}"),
                                  Text("Balance: \$${patient.balanceAmount}"),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
      ),
    );
  }
}
