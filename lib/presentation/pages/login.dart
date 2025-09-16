// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../providers/auth_provider.dart';

// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});

//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   final _usernameController = TextEditingController();
//   final _passwordController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     final provider = Provider.of<AuthProvider>(context);

//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               TextField(
//                 controller: _usernameController,
//                 decoration: const InputDecoration(labelText: "Username"),
//               ),
//               const SizedBox(height: 10),
//               TextField(
//                 controller: _passwordController,
//                 obscureText: true,
//                 decoration: const InputDecoration(labelText: "Password"),
//               ),
//               const SizedBox(height: 20),
//               provider.isLoading
//                   ? const CircularProgressIndicator()
//                   : ElevatedButton(
//                       onPressed: () async {
//                         try {
//                           await provider.login(
//                             _usernameController.text.trim(),
//                             _passwordController.text.trim(),
//                           );

//                           ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(content: Text("Login success!")),
//                           );

//                           // Navigate to home/dashboard
//                         } catch (e) {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(content: Text(e.toString())),
//                           );
//                         }
//                       },
//                       child: const Text("Login"),
//                     ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
