import 'package:flutter/material.dart';
import 'package:ui_notes_app/services/notes_data.dart';
import 'package:ui_notes_app/routes/notes/notes_part.dart';
import 'package:ui_notes_app/routes/auth/signup.dart';

class Login extends StatefulWidget {
  Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  String? email, password;
  String _errorMessage = "";

  Future<void> handleForm(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        await login(email!, password!);
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NotesPart()),
        );
      } catch (e) {
        print(e);
        setState(() {
          _errorMessage = "Please enter a valid email and password";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 300,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Login",
                  style: TextStyle(fontSize: 30),
                ),
                if (_errorMessage.isNotEmpty)
                  Text(
                    _errorMessage,
                    style: TextStyle(color: Colors.red),
                  ),
                SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Email",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    email = value;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  obscureText: true, // Hide password text
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Password",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    password = value;
                  },
                ),
                SizedBox(height: 20),
                Column(
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                        fixedSize: Size.fromWidth(200),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Signup()),
                        );
                      },
                      child: Center(
                        child: Text("No account? Go signup"),
                      ),
                    ),
                    SizedBox(height: 40),
                    TextButton(
                      style: TextButton.styleFrom(
                        fixedSize: Size.fromWidth(100),
                        side: BorderSide(color: Colors.blue, width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        handleForm(context);
                      },
                      child: Center(
                        child: Text("Submit"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
