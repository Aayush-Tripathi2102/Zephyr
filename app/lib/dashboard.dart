import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:zephyr/services/appwrite.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key, required this.user});

  final User user;

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final AppWriteService appWriteService = AppWriteService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Image.asset('assets/zephyr.jpg', scale: 3,),
            const Text('ephyr'),
          ],
        ),
      ),
      body: Column(
        children: [
          Center(
            child: Text('Name: ${widget.user.name}'),
          ),
          OutlinedButton(
              onPressed: () async {
                await appWriteService.logout();
                Navigator.of(context).pop();
              },
              child: const Text('Logout'))
        ],
      ),
    );
  }
}
