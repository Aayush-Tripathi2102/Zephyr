import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zephyr/borrow_screen.dart';
import 'package:zephyr/collateral_screen.dart';
import 'package:zephyr/dashboard_screen.dart';
import 'package:zephyr/profile_screen.dart';
import 'package:zephyr/repay_screen.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class AppNavigator extends StatefulWidget {
  const AppNavigator({Key? key}) : super(key: key);

  @override
  State<AppNavigator> createState() => _AppNavigatorState();
}

class _AppNavigatorState extends State<AppNavigator> {
  late IO.Socket _socket;
  bool _isConnected = false;
  int _selectedIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _socket =
        IO.io('https://zephyr-server-remx.onrender.com', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      'extraHeaders': {'Content-Type': 'application/json'},
    });

    _socket.onConnect((_) {
      print('Socket connected');
      setState(() => _isConnected = true);
    });

    _socket.onDisconnect((_) {
      print('Socket disconnected');
      setState(() => _isConnected = false);
    });

    _socket.onError((error) => print('Socket error: $error'));
    _socket.onConnectError((error) => print('Connect error: $error'));
  }

  Future<double> getInterestRate() async {

  }


  Future<void> createLoan(double amount, double collateralValue) async {

  }


  @override
  void dispose() {
    _socket.dispose();
    super.dispose();
  }

  // Placeholder widgets for each tab
  // Replace these with your actual screens
  // final List<Widget> _screens = [
  //   const DashboardScreen(),
  //   BorrowScreen(getInterestRate:()=>getInterestRate, callCollateral: addCollateral, borrow: borrow,);
  //   const RepayScreen(),
  //   const CollateralScreen(),
  //   const ProfileScreen(),
  // ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // Add haptic feedback for better UX
      HapticFeedback.lightImpact();
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      const DashboardScreen(),
      BorrowScreen(
        getInterestRate: getInterestRate, // No need for `()=>`
        createLoan: createLoan,
      ),
      const RepayScreen(),
      const CollateralScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard_rounded), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet), label: 'Borrow'),
          BottomNavigationBarItem(icon: Icon(Icons.payments_rounded), label: 'Repay'),
          BottomNavigationBarItem(icon: Icon(Icons.shield_rounded), label: 'Collateral'),
          BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Profile'),
        ],
      ),
    );
  }

}

// Placeholder widgets - replace these with your actual screens
class DashboardPlaceholder extends StatelessWidget {
  const DashboardPlaceholder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildPlaceholderScreen(
      'Dashboard',
      Icons.dashboard_rounded,
      'View your active loans and financial overview',
    );
  }
}

class BorrowPlaceholder extends StatelessWidget {
  const BorrowPlaceholder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildPlaceholderScreen(
      'Borrow',
      Icons.account_balance_wallet,
      'Apply for a new loan with crypto collateral',
    );
  }
}

class RepayPlaceholder extends StatelessWidget {
  const RepayPlaceholder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildPlaceholderScreen(
      'Repay',
      Icons.payments_rounded,
      'Make payments on your existing loans',
    );
  }
}

class CollateralPlaceholder extends StatelessWidget {
  const CollateralPlaceholder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildPlaceholderScreen(
      'Collateral',
      Icons.shield_rounded,
      'Manage and top-up your collateral assets',
    );
  }
}

class ProfilePlaceholder extends StatelessWidget {
  const ProfilePlaceholder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildPlaceholderScreen(
      'Profile',
      Icons.person_rounded,
      'View your credit score and account settings',
    );
  }
}

// Helper method to build placeholder screens
Widget _buildPlaceholderScreen(
    String title, IconData icon, String description) {
  return SafeArea(
    child: Scaffold(
      backgroundColor: const Color.fromARGB(255, 20, 0, 50),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 80,
              color: const Color(0xFFA855F7),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade400,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
