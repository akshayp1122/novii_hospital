import 'package:flutter/material.dart';
import 'package:noviindus_patients/presentation/providers/auth_provider.dart';
import 'package:noviindus_patients/presentation/providers/branch_provider.dart';
import 'package:noviindus_patients/presentation/providers/treatment_provider.dart';
import 'package:noviindus_patients/services/patient_service.dart';
import 'package:noviindus_patients/util/pdf_generator.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String? location;
  String? branch;
  List<Map<String, dynamic>> treatments = [];

  final TextEditingController nameController = TextEditingController();
  final TextEditingController whatsappController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController totalController = TextEditingController();
  final TextEditingController discountController = TextEditingController();
  final TextEditingController advanceController = TextEditingController();
  final TextEditingController balanceController = TextEditingController();
  final TextEditingController _datecontroller = TextEditingController();
  DateTime? treatmentDate;
  String? paymentOption;
  int hour = 0;
  int minute = 0;

  final PatientService _patientService = PatientService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final branchProvider =
          Provider.of<BranchProvider>(context, listen: false);
      final treatmentProvider =
          Provider.of<TreatmentProvider>(context, listen: false);

      if (authProvider.token != null) {
        branchProvider.fetchBranches(authProvider.token!);
        treatmentProvider.fetchTreatments(authProvider.token!);
      }
    });
  }

  Future<void> _savePatient() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final treatmentProvider =
        Provider.of<TreatmentProvider>(context, listen: false);

    if (authProvider.token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No auth token found")),
      );
      return;
    }

    if (treatments.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please add at least one treatment")),
      );
      return;
    }

    // Parse numeric fields
    double total = double.tryParse(totalController.text) ?? 0;
    double discount = double.tryParse(discountController.text) ?? 0;
    double advance = double.tryParse(advanceController.text) ?? 0;

    // Calculate balance automatically
    double balance = total - discount - advance;
    if (balance < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Error: Total amount must be >= discount + advance")),
      );
      return;
    }

    // Collect treatment IDs
    List<String> treatmentIds = [];
    List<String> maleIds = [];
    List<String> femaleIds = [];

    for (var t in treatments) {
      try {
        final treatment = treatmentProvider.treatments
            .firstWhere((tr) => tr.name == t["name"]);
        final treatmentId = treatment.id.toString();
        treatmentIds.add(treatmentId);
        if ((t["male"] ?? 0) > 0) maleIds.add(treatmentId);
        if ((t["female"] ?? 0) > 0) femaleIds.add(treatmentId);
      } catch (e) {
        // treatment not found, skip
        continue;
      }
    }

    if (treatmentIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No valid treatments selected")),
      );
      return;
    }

    // Build request map
    Map<String, dynamic> formMap = {
      "name": nameController.text.trim(),
      "excecutive": "Admin",
      "payment": paymentOption ?? "Cash",
      "phone": whatsappController.text.trim(),
      "address": addressController.text.trim(),
      "total_amount": total,
      "discount_amount": discount,
      "advance_amount": advance,
      "balance_amount": balance,
      "date_nd_time": treatmentDate != null
          ? _patientService.formatDateTime(treatmentDate!, hour, minute)
          : "",
      "id": "",
      "male": maleIds.join(","), // e.g., "2,3"
      "female": femaleIds.join(","), // e.g., "2,3"
      "branch": branch ?? "",
      "treatments": treatmentIds.join(","), // e.g., "2,3,5"
    };

    debugPrint("📤 Sending data to backend:");
    formMap.forEach((k, v) => debugPrint("   $k: $v"));

    // Call API
    final success =
        await _patientService.registerPatient(formMap, authProvider.token!);
    if (success) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //       content: Text(success
      //           ? "✅ Patient registered successfully"
      //           : "")),
      // );
    }

    if (mounted) {
      final pdfService = PdfService();
      final pdfData = await pdfService.generateInvoice(
        name: nameController.text,
        address: addressController.text,
        whatsapp: whatsappController.text,
        bookedOn: DateTime.now().toString(),
        treatmentDate: treatmentDate != null
            ? "${treatmentDate!.day}/${treatmentDate!.month}/${treatmentDate!.year}"
            : "",
        treatmentTime: "$hour:$minute",
        treatments: treatments,
        total: total,
        discount: discount,
        advance: advance,
        balance: balance,
      );

      pdfService.previewPdf(pdfData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.arrow_back),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12.0),
            child: Icon(Icons.notifications, color: Colors.black),
          )
        ],
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 22.0, vertical: 2),
              child: Text(
                'Register',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.w600),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: Divider(height: 2, thickness: 3, color: Color(0xFFEDEDED)),
            ),
            const SizedBox(height: 10),
            formLabel('Name'),
            _inputField(
                "Enter your full name", "Enter your full name", nameController),
            formLabel('Whatsapp Number'),
            _inputField("Enter your Whatsapp number",
                "Enter your Whatsapp number", whatsappController),
            formLabel('Address'),
            _inputField("Enter your full address", "Enter your full address",
                addressController),
            formLabel('Location'),
            _dropdownField("Choose your Location",
                ["Kozhikode", "Kannur", "Thrissur"], location, (val) {
              setState(() => location = val);
            }),
            formLabel('Branch'),
            Consumer<BranchProvider>(
              builder: (context, branchProvider, child) {
                if (branchProvider.loading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (branchProvider.error != null) {
                  return Text("Error: ${branchProvider.error}");
                }

                return DropdownButtonFormField<String>(
                  decoration:
                      const InputDecoration(labelText: "Select the Branch"),
                  value: branch,
                  items: branchProvider.branches
                      .map((branchItem) => DropdownMenuItem<String>(
                            value: branchItem.id.toString(),
                            child: Text(branchItem.name),
                          ))
                      .toList(),
                  onChanged: (val) {
                    setState(() {
                      branch = val;
                    });
                  },
                );
              },
            ),
            formLabel('Treatments'),
            // treatmentCard(),
            Column(
              children: treatments
                  .asMap()
                  .entries
                  .map((entry) => Card(
                        child: ListTile(
                          title: Text(
                            entry.value["name"],
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w700),
                          ),
                          subtitle: Text(
                            "Male ${entry.value["male"]},     Female ${entry.value["female"]}",
                            style: const TextStyle(
                                fontSize: 16, color: Colors.green),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon:
                                    const Icon(Icons.edit, color: Colors.green),
                                onPressed: () =>
                                    _addTreatment(editIndex: entry.key),
                              ),
                              IconButton(
                                icon:
                                    const Icon(Icons.close, color: Colors.red),
                                onPressed: () {
                                  setState(() {
                                    treatments.removeAt(entry.key);
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => _addTreatment(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade100,
                foregroundColor: Colors.black,
              ),
              child: const Text("+ Add Treatments"),
            ),
            const SizedBox(height: 12),
            _inputField("Total Amount", "Enter amount", totalController),
            _inputField(
                "Discount Amount", "Enter discount", discountController),
            const SizedBox(height: 12),
            const Text("Payment Option"),
            Row(
              children: [
                _radioOption("Cash"),
                _radioOption("Card"),
                _radioOption("UPI"),
              ],
            ),
            _inputField("Advance Amount", "Enter advance", advanceController),
            _inputField("Balance Amount", "Enter balance", balanceController),
            const SizedBox(height: 12),
            const Text("Treatment Date"),
            TextField(
              controller: _datecontroller,
              readOnly: true,
              decoration: const InputDecoration(
                hintText: "Select Date",
                suffixIcon: Icon(Icons.calendar_today),
              ),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (picked != null) {
                  setState(() => treatmentDate = picked);
                  _datecontroller.text =
                      "${picked.day}/${picked.month}/${picked.year}";
                }
              },
            ),
            const SizedBox(height: 12),
            const Text("Treatment Time"),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<int>(
                    decoration: const InputDecoration(hintText: "Hour"),
                    value: hour,
                    items: List.generate(
                        24,
                        (index) => DropdownMenuItem(
                            value: index, child: Text(index.toString()))),
                    onChanged: (val) => setState(() => hour = val!),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<int>(
                    decoration: const InputDecoration(hintText: "Minutes"),
                    value: minute,
                    items: List.generate(
                        60,
                        (index) => DropdownMenuItem(
                            value: index, child: Text(index.toString()))),
                    onChanged: (val) => setState(() => minute = val!),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _savePatient,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child:
                    const Text("Save", style: TextStyle(color: Colors.white)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget formLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 10),
      child: Text(text,
          style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.w400, color: Colors.black)),
    );
  }

  Widget treatmentCard() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF6F6F6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E2E2)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      child: Row(
        children: const [
          Expanded(
            child: Text(
              "No treatments added yet",
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  Widget _inputField(
      String label, String hint, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(labelText: label, hintText: hint),
      ),
    );
  }

  Widget _dropdownField(String label, List<String> items, String? value,
      Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(labelText: label),
        value: value,
        items: items
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _radioOption(String option) {
    return Row(
      children: [
        Radio<String>(
          value: option,
          groupValue: paymentOption,
          onChanged: (val) => setState(() => paymentOption = val),
        ),
        Text(option),
      ],
    );
  }

  void _addTreatment({int? editIndex}) {
    final treatmentProvider =
        Provider.of<TreatmentProvider>(context, listen: false);
    String? selectedTreatment;
    int male = 0, female = 0;

    if (editIndex != null) {
      selectedTreatment = treatments[editIndex]["name"];
      male = treatments[editIndex]["male"];
      female = treatments[editIndex]["female"];
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          content: StatefulBuilder(
            builder: (context, setStateDialog) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text("Choose treatment"),
                    const SizedBox(height: 8),
                    treatmentProvider.loading
                        ? const Center(child: CircularProgressIndicator())
                        : DropdownButtonFormField<String>(
                            isExpanded: true,
                            value: selectedTreatment,
                            decoration: const InputDecoration(
                              labelText: "Choose preferred Treatment",
                              labelStyle:
                                  TextStyle(overflow: TextOverflow.ellipsis),
                            ),
                            items: treatmentProvider.treatments.map((t) {
                              return DropdownMenuItem(
                                value: t.name,
                                child: Text(
                                  "${t.name} (${t.duration}) - ₹${t.price}",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              );
                            }).toList(),
                            onChanged: (val) =>
                                setStateDialog(() => selectedTreatment = val),
                          ),
                    const SizedBox(height: 16),

                    // Male Counter
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Male"),
                        IconButton(
                          icon: const Icon(Icons.remove_circle,
                              color: Colors.green),
                          onPressed: () {
                            if (male > 0) setStateDialog(() => male--);
                          },
                        ),
                        Text(male.toString()),
                        IconButton(
                          icon:
                              const Icon(Icons.add_circle, color: Colors.green),
                          onPressed: () => setStateDialog(() => male++),
                        ),
                      ],
                    ),

                    // Female Counter
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Female"),
                        IconButton(
                          icon: const Icon(Icons.remove_circle,
                              color: Colors.green),
                          onPressed: () {
                            if (female > 0) setStateDialog(() => female--);
                          },
                        ),
                        Text(female.toString()),
                        IconButton(
                          icon:
                              const Icon(Icons.add_circle, color: Colors.green),
                          onPressed: () => setStateDialog(() => female++),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    ElevatedButton(
                      onPressed: () {
                        if (selectedTreatment != null) {
                          final newTreatment = {
                            "name": selectedTreatment!,
                            "male": male,
                            "female": female,
                          };
                          setState(() {
                            if (editIndex != null) {
                              treatments[editIndex] = newTreatment;
                            } else {
                              treatments.add(newTreatment);
                            }
                          });
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      child: const Text(
                        "Save",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
