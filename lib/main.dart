import 'package:flutter/material.dart';
import './screens/host.dart';

void main() {
  runApp(const SudukoSolver());
}

class SudukoSolver extends StatelessWidget {
  const SudukoSolver({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HostPage(),
    );
  }
}
