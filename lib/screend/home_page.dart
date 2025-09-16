import 'package:flutter/material.dart';
import 'package:noviindus_patients/presentation/providers/auth_provider.dart';
import 'package:noviindus_patients/presentation/providers/patient_provider.dart';
import 'package:noviindus_patients/screend/register_page.dart';
import 'package:provider/provider.dart';
import '../../domain/models/patient_model.dart';

class BookingListPage extends StatefulWidget {
  const BookingListPage({super.key});

  @override
  State<BookingListPage> createState() => _BookingListPageState();
}

class _BookingListPageState extends State<BookingListPage> {
  final TextEditingController _searchController = TextEditingController();
  String _sortValue = 'Date';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final patientProvider =
          Provider.of<PatientProvider>(context, listen: false);
      if (authProvider.token != null) {
        patientProvider.fetchPatients(authProvider.token!);
      }
    });
  }

  Future<void> _refresh() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final patientProvider =
        Provider.of<PatientProvider>(context, listen: false);
    if (authProvider.token != null) {
      await patientProvider.fetchPatients(authProvider.token!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final patientProvider = Provider.of<PatientProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // 🔹 Top bar
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).maybePop(),
                    child: const Icon(Icons.arrow_back, size: 28),
                  ),
                  const Spacer(),
                  Stack(
                    children: [
                      const Icon(Icons.notifications_none, size: 28),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),

            // 🔹 Search bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        // const Icon(Icons.search, color: Colors.grey),
                        // const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            decoration: const InputDecoration(
                              fillColor: Colors.white,
                              prefixIcon: const Icon(Icons.search,
                                  size: 25, color: Colors.grey),
                              hintText: 'Search for treatments',
                              hintStyle: TextStyle(
                                color: Colors.black26, // 👈 text inside color
                                fontSize: 16,
                              ),
                              border: InputBorder.none,
                              isDense: true,
                            ),
                            onChanged: (_) =>
                                setState(() {}), // trigger filtering
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    height: 48,
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    decoration: BoxDecoration(
                      color: const Color(0xFF116530),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        'Search',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 18),

            // 🔹 Sort dropdown
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Sort by :',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  const SizedBox(width: 32),
                  Container(
                    height: 44,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_sortValue, style: const TextStyle(fontSize: 16)),
                        const SizedBox(width: 44),
                        PopupMenuButton<String>(
                          itemBuilder: (context) => ['Date', 'Name', 'Package']
                              .map((e) =>
                                  PopupMenuItem(value: e, child: Text(e)))
                              .toList(),
                          onSelected: (v) => setState(() => _sortValue = v),
                          child: const Icon(Icons.keyboard_arrow_down,
                              color: Colors.green),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 14),

            // 🔹 Booking list
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refresh,
                child: patientProvider.loading
                    ? const Center(child: CircularProgressIndicator())
                    : patientProvider.error != null
                        ? Center(child: Text("Error: ${patientProvider.error}"))
                        : _buildList(patientProvider.patients),
              ),
            ),
          ],
        ),
      ),

      // 🔹 Bottom register button
      bottomSheet: Container(
        height: 66,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        color: Colors.transparent,
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const RegisterPage()),
      );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF116530),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text('Register Now',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700,color: Colors.white)),
        ),
      ),
    );
  }

  Widget _buildList(List<Patient> patients) {
    // Filter by search
    final search = _searchController.text.toLowerCase();
    List<Patient> filtered = patients.where((p) {
      return p.name.toLowerCase().contains(search) ||
          p.details.treatmentName.toLowerCase().contains(search) ||
          p.branch.name.toLowerCase().contains(search);
    }).toList();

    // Sort
    if (_sortValue == 'Name') {
      filtered.sort((a, b) => a.name.compareTo(b.name));
    } else if (_sortValue == 'Package') {
      filtered.sort(
          (a, b) => a.details.treatmentName.compareTo(b.details.treatmentName));
    } else {
      filtered.sort((a, b) => b.date.compareTo(a.date)); // latest first
    }

    if (filtered.isEmpty) {
      return const Center(child: Text("No bookings found"));
    }

    return ListView.separated(
      padding: const EdgeInsets.only(bottom: 90, top: 8),
      itemCount: filtered.length,
      separatorBuilder: (_, __) => const SizedBox(height: 18),
      itemBuilder: (context, index) {
        final item = filtered[index];
        return BookingCard(
          index: index + 1,
          name: item.name,
          packageText: item.details.treatmentName,
          date: item.date,
          by: item.branch.name,
        );
      },
    );
  }
}

class BookingCard extends StatelessWidget {
  final int index;
  final String name;
  final String packageText;
  final String date;
  final String by;

  const BookingCard({
    super.key,
    required this.index,
    required this.name,
    required this.packageText,
    required this.date,
    required this.by,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 18.0, vertical: 14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('$index.',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(name,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w800)),
                          const SizedBox(height: 6),
                          Text(packageText,
                              style: const TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF116530),
                                  fontWeight: FontWeight.w500)),
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined,
                        size: 18, color: Colors.deepOrange),
                    const SizedBox(width: 6),
                    Text(date,
                        style:
                            const TextStyle(fontSize: 14, color: Colors.grey)),
                    const SizedBox(width: 12),
                    const Icon(Icons.person_outline,
                        size: 18, color: Colors.deepOrange),
                    const SizedBox(width: 6),
                    Text(by,
                        style:
                            const TextStyle(fontSize: 14, color: Colors.grey)),
                  ],
                )
              ],
            ),
          ),
          const Divider(height: 1, color: Colors.grey),
          InkWell(
            onTap: () {
              // TODO: open booking detail page
            },
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 18.0, vertical: 14.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('View Booking details',
                      style: TextStyle(fontSize: 16)),
                  const Icon(Icons.arrow_forward_ios,
                      size: 18, color: Color(0xFF116530)),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
