// main.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Registration App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Registration Form'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController(); // New controller
  final TextEditingController passwordController = TextEditingController(); // New controller
  final TextEditingController countryController = TextEditingController(); // New controller
  String message = '';

  Future<void> registerUser() async {
    final String apiUrl = 'http://your_contabo_vps_ip:8080/api/users/register'; // Updated endpoint to /register
    final Map<String, dynamic> registrationData = {
      'name': nameController.text,
      'email': emailController.text,
      'phone': phoneController.text, // Include phone
      'password': passwordController.text, // Include password
      'country': countryController.text, // Include country
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(registrationData),
      );

      if (response.statusCode == 201) {
        setState(() {
          message = 'Registration successful! Status Code: ${response.statusCode}';
        });
        print('Registration successful! Response body: ${response.body}');
      } else {
        setState(() {
          message = 'Registration failed. Status Code: ${response.statusCode}';
        });
        print('Registration failed. Status Code: ${response.statusCode}, Response body: ${response.body}');
      }
    } catch (error) {
      setState(() {
        message = 'Error during registration: $error';
      });
      print('Error during registration: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView( // Wrap Column with SingleChildScrollView to prevent overflow
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: phoneController, // New TextField for Phone
                decoration: const InputDecoration(labelText: 'Phone'),
                keyboardType: TextInputType.phone, // Suggest phone keyboard
              ),
              TextField(
                controller: passwordController, // New TextField for Password
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true, // Hide password characters
              ),
              TextField(
                controller: countryController, // New TextField for Country
                decoration: const InputDecoration(labelText: 'Country'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: registerUser, // Updated function name to registerUser
                child: const Text('Register'), // Updated button text
              ),
              const SizedBox(height: 20),
              Text(message),
            ],
          ),
        ),
      ),
    );
  }
}