import 'package:flutter/material.dart';
import 'package:zephyr/components/login_card.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/zephyr.jpg',
              scale: 3,
            ),
            const Text('ephyr'),
          ],
        ),
      ),
      body:  Padding(
        padding:  const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: LoginCard(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
