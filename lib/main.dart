import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mock Sensor App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _counter = 0; // State variable

  void _increment() {
    setState(() {
      _counter++; // Updates the UI automatically
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold( // Basic UI layout
      appBar: AppBar(title: const Text('Sensor Dashboard')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Manual Readings Logged:', style: TextStyle(fontSize: 20)),
            Text('$_counter', style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _increment,
              child: const Text('Log Reading'),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TelemetryScreen()),
                );
              },
              child: const Text('View Live Telemetry'),
            ),
          ],
        ),
      ),
    );
  }
}

class TelemetryScreen extends StatelessWidget {
  const TelemetryScreen({super.key});

  Future<String> _fetchServerStatus() async {
    await Future.delayed(const Duration(seconds: 2));
    return "Server Connected: OK";
  }

  Stream<int> _liveDataStream() {
    return Stream.periodic(const Duration(seconds: 1), (count) => count * 5);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Live Telemetry')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FutureBuilder<String>(
              future: _fetchServerStatus(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                return Text(snapshot.data ?? 'Error', style: const TextStyle(fontSize: 18, color: Colors.green));
              },
            ),
            const SizedBox(height: 40),
            const Text('Live RPM Sensor:', style: TextStyle(fontSize: 20)),
            // StreamBuilder handles the continuous updates
            StreamBuilder<int>(
              stream: _liveDataStream(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Text('Starting sensor...');
                }
                return Text('${snapshot.data} RPM', style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold));
              },
            ),
          ],
        ),
      ),
    );
  }
}
