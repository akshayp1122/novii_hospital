import 'package:flutter/material.dart';
import 'package:noviindus_patients/presentation/providers/auth_provider.dart';
import 'package:noviindus_patients/presentation/providers/branch_provider.dart';
import 'package:noviindus_patients/presentation/providers/treatment_provider.dart';
import 'package:noviindus_patients/screend/regi.dart';
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
  DateTime? treatmentDate;
  String? paymentOption;
  int hour = 0;
  int minute = 0;
  @override
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final branchProvider = Provider.of<BranchProvider>(context, listen: false);
     final treatmentProvider = Provider.of<TreatmentProvider>(context, listen: false);

    if (authProvider.token != null) {
      branchProvider.fetchBranches(authProvider.token!);
      treatmentProvider.fetchTreatments(authProvider.token!);
    }
  });
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.arrow_back),
        // title: const Text("Register"),
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
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 22.0, vertical: 2),
              child: Row(
                children: const [
                  Text(
                    'Register',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: Divider(height: 2, thickness: 3, color: Color(0xFFEDEDED)),
            ),
            SizedBox(height: 10),
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
                            value: branchItem.name,
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
            treatmentCard(),
            Column(
              children: treatments
                  .asMap()
                  .entries
                  .map((entry) => Card(
                        child: ListTile(
                          title: Text(entry.value["name"],style: TextStyle(fontSize: 18 , fontWeight: FontWeight.w700),
                       ),
                          subtitle: Text(
                              "Male ${entry.value["male"]},     Female ${entry.value["female"]}" ,style: TextStyle(fontSize: 16 ,color: Colors.green)),
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
                onPressed: () {},
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
        children: [
          // Left text column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Row with numbering and title
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      '1.',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Couple Combo package i..',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w700),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                // male/female row
                Row(
                  children: [
                    const Text('Male',
                        style: TextStyle(color: kAccentGreen, fontSize: 16)),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: kBorderGrey),
                        color: Colors.white,
                      ),
                      child: const Text('2',
                          style: TextStyle(
                              color: kAccentGreen,
                              fontWeight: FontWeight.w700)),
                    ),
                    const SizedBox(width: 22),
                    const Text('Female',
                        style: TextStyle(color: kAccentGreen, fontSize: 16)),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: kBorderGrey),
                        color: Colors.white,
                      ),
                      child: const Text('2',
                          style: TextStyle(
                              color: kAccentGreen,
                              fontWeight: FontWeight.w700)),
                    ),
                  ],
                )
              ],
            ),
          ),

          // Right side icons column
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // round red delete button
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: Color(0xFFF9D6D6),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.clear, color: Color(0xFFB40000)),
              ),
              const SizedBox(height: 14),
              // pencil icon
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.edit, color: kAccentGreen),
              ),
            ],
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
      return AlertDialog(backgroundColor: Colors.white,
        content: StatefulBuilder(
          builder: (context, setStateDialog) {
            return SingleChildScrollView( // 👈 prevents vertical overflow
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Choose treatment",style: TextStyle(fontSize: 16),),
                  SizedBox(height: 8,),
                  treatmentProvider.loading
                      ? const Center(child: CircularProgressIndicator())
                      : DropdownButtonFormField<String>(
                          isExpanded: true, // 👈 fixes horizontal overflow
                          value: selectedTreatment,
                          decoration: const InputDecoration(
                            labelText: "Choose prefered Treatment",
                            labelStyle: TextStyle(overflow: TextOverflow.ellipsis),
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
                        icon: const Icon(Icons.remove_circle, color: Colors.green),
                        onPressed: () {
                          if (male > 0) setStateDialog(() => male--);
                        },
                      ),
                      Text(male.toString()),
                      IconButton(
                        icon: const Icon(Icons.add_circle, color: Colors.green),
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
                        icon: const Icon(Icons.remove_circle, color: Colors.green),
                        onPressed: () {
                          if (female > 0) setStateDialog(() => female--);
                        },
                      ),
                      Text(female.toString()),
                      IconButton(
                        icon: const Icon(Icons.add_circle, color: Colors.green),
                        onPressed: () => setStateDialog(() => female++),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Save Button
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
}}

