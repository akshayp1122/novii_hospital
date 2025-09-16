import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top background with logo
            Stack(
              children: [
                Container(
                  height: 250,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                          "lib/assets/images/login_background.png"), // top background
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.center,
                    child: Image.asset(
                      "lib/assets/images/logo_novi.png", // center logo
                      height: 100,
                      width: 100,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Login Or Register To Book\nYour Appointments",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 24,
                      fontWeight: FontWeight.w600, // SemiBold
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Email
                  const Text(
                    "Email",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.w400, // SemiBold
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.black.withOpacity(0.24))),
                      hintText: "Enter your email",
                      hintStyle: TextStyle(
                        color: Colors.black.withOpacity(0.44),
                      ),
                      // prefixIcon: const Icon(Icons.email_outlined),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Password
                  const Text(
                    "Password",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.w400, // SemiBold
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.black.withOpacity(0.24))),
                      hintText: "Enter password",
                      // prefixIcon: const Icon(Icons.lock_outline),
                      hintStyle: TextStyle(
                        color: Colors.black.withOpacity(0.44),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Login button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF006837),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        "Login",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          fontWeight: FontWeight.w600, // SemiBold
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Terms
                  const Text.rich(
                    TextSpan(
                      text:
                          "By creating or logging into an account you are agreeing with our ",
                      children: [
                        TextSpan(
                          text: "Terms and Conditions ",
                          style: TextStyle(color: Colors.blue),
                        ),
                        TextSpan(text: "and "),
                        TextSpan(
                          text: "Privacy Policy.",
                          style: TextStyle(color: Colors.blue),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
