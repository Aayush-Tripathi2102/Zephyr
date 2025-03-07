import 'package:flutter/material.dart';

import '../dashboard.dart';
import '../services/appwrite.dart';
import 'login_field.dart';

class LoginCard extends StatefulWidget {
  const LoginCard({super.key});

  @override
  State<LoginCard> createState() => _LoginCardState();
}

class _LoginCardState extends State<LoginCard> {
  TextEditingController emailController = TextEditingController();
  TextEditingController pwdController = TextEditingController();
  final AppWriteService appWriteService = AppWriteService();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5, // Keep the shadow effect
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 42, 0, 107),
              Colors.transparent
            ],
            begin: Alignment.topLeft,
            end: Alignment.center
            // center: Alignment.topLeft,
          ),
          borderRadius: BorderRadius.circular(12), // Match Card border
        ),
        padding: const EdgeInsets.all(8.0), // Move padding inside
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              child: Text(
                'Log in',
                style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Access your account and explore the Decentralised P2P Network',
                style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w300),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: LoginField(controller: emailController, text: 'Email', isObscureText: false,),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: LoginField(controller: pwdController, text: 'Password', isObscureText: true,),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () async {
                    String email = emailController.text;
                    String pwd = pwdController.text;
                    final user = await appWriteService.login(email, pwd);
                    emailController.clear();
                    pwdController.clear();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) => DashboardPage(user: user),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child:  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Login',
                      style: TextStyle(fontWeight: FontWeight.w300, color: Colors.white70),
                    ),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'New to the network?',
                  style: TextStyle(fontWeight: FontWeight.w300,),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'Sign up',
                    style: TextStyle(
                        fontWeight: FontWeight.w300, fontStyle: FontStyle.italic,  color: Theme.of(context).primaryColor.withAlpha(150)),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
