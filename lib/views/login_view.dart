import 'package:flutter/material.dart';
import 'package:ukl1/services/user.dart';
import 'package:ukl1/widgets/alert.dart';
import 'register_user_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  UserService user = UserService();
  final formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  bool showPass = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          "Login",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const RegisterUserView()),
              );
            },
            child: const Text(
              "Daftar",
              style: TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(width: 10),
          IconButton(
            icon: const Icon(Icons.dashboard, color: Colors.white),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/dashboard');
            },
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Bank Sinar Jaya",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Selamat datang kembali!",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 25),
                  TextFormField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      labelText: "Username",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: const Icon(Icons.account_circle),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? 'Username harus diisi' : null,
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: passwordController,
                    obscureText: showPass,
                    decoration: InputDecoration(
                      labelText: "Password",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            showPass = !showPass;
                          });
                        },
                        icon: Icon(
                          showPass ? Icons.visibility : Icons.visibility_off,
                        ),
                      ),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? 'Password harus diisi' : null,
                  ),
                  const SizedBox(height: 25),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          setState(() {
                            isLoading = true;
                          });
                          var data = {
                            "username": usernameController.text,
                            "password": passwordController.text,
                          };
                          var result = await user.loginUser(data);
                          setState(() {
                            isLoading = false;
                          });
                          if (result.status == true) {
                            AlertMessage()
                                .showAlert(context, result.message, true);
                            Future.delayed(const Duration(seconds: 2), () {
                              Navigator.pushReplacementNamed(
                                  context, '/dashboard');
                            });
                          } else {
                            AlertMessage()
                                .showAlert(context, result.message, false);
                          }
                        }
                      },
                      child: isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "LOGIN",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}