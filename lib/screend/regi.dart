import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

const Color kAccentGreen = Color(0xFF0F7A48);
const Color kLightGrey = Color(0xFFF3F3F3);
const Color kFieldBg = Color(0xFFF5F5F5);
const Color kBorderGrey = Color(0xFFE8E6E6);

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Register UI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const RegisterPage(),
    );
  }
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameController = TextEditingController();
  final _whatsappController = TextEditingController();
  final _addressController = TextEditingController();

  String locationValue = 'Choose your location';
  String branchValue = 'Select the branch';

  @override
  void dispose() {
    _nameController.dispose();
    _whatsappController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Widget formLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(text,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
    );
  }

  Widget inputField({required String hint, TextEditingController? ctl, Widget? suffix}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: kFieldBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kBorderGrey),
      ),
      height: 56,
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: ctl,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 16),
                border: InputBorder.none,
                isCollapsed: true,
              ),
              style: const TextStyle(fontSize: 16),
            ),
          ),
          if (suffix != null) suffix,
        ],
      ),
    );
  }

  Widget dropdownField(String text, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: kFieldBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kBorderGrey),
      ),
      height: 56,
      child: Row(
        children: [
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ),
          // green check-down style icon similar to image
          const Icon(Icons.keyboard_arrow_down_rounded, color: kAccentGreen),
        ],
      ),
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
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Couple Combo package i..',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                // male/female row
                Row(
                  children: [
                    const Text('Male', style: TextStyle(color: kAccentGreen, fontSize: 16)),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: kBorderGrey),
                        color: Colors.white,
                      ),
                      child: const Text('2', style: TextStyle(color: kAccentGreen, fontWeight: FontWeight.w700)),
                    ),
                    const SizedBox(width: 22),
                    const Text('Female', style: TextStyle(color: kAccentGreen, fontSize: 16)),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: kBorderGrey),
                        color: Colors.white,
                      ),
                      child: const Text('2', style: TextStyle(color: kAccentGreen, fontWeight: FontWeight.w700)),
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

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top + 8;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top bar with back arrow and bell icon
            Padding(
              padding: EdgeInsets.only(left: 16, right: 16, top: topPadding - 8, bottom: 8),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {},
                    borderRadius: BorderRadius.circular(24),
                    child: const Icon(Icons.arrow_back_ios_new, size: 26),
                  ),
                  const Spacer(),
                  // bell with red dot
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
                            shape: BoxShape.circle,
                            color: Colors.red,
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),

            // Title and divider
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 2),
              child: Row(
                children: const [
                  Text(
                    'Register',
                    style: TextStyle(fontSize: 38, fontWeight: FontWeight.w800),
                  ),
                ],
              ),
            ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
              child: Divider(height: 1, thickness: 1, color: Color(0xFFEDEDED)),
            ),

            // Form contents
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    formLabel('Name'),
                    inputField(hint: 'Enter your full name', ctl: _nameController),
                    const SizedBox(height: 22),

                    formLabel('Whatsapp Number'),
                    inputField(hint: 'Enter your Whatsapp number', ctl: _whatsappController),
                    const SizedBox(height: 22),

                    formLabel('Address'),
                    inputField(hint: 'Enter your full address', ctl: _addressController),
                    const SizedBox(height: 22),

                    formLabel('Location'),
                    dropdownField('Location', locationValue),
                    const SizedBox(height: 22),

                    formLabel('Branch'),
                    dropdownField('Branch', branchValue),
                    const SizedBox(height: 26),

                    formLabel('Treatments'),
                    const SizedBox(height: 8),
                    treatmentCard(),
                    const SizedBox(height: 30),
                    // filler bottom space
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}