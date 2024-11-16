import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import './core/providers/city_provider.dart';
import './core/providers/institute_provider.dart';
import './ui/screens/city_list_screen.dart';
import './ui/screens/institute_list_screen.dart';

Future main() async {
  await dotenv.load(fileName: '.env');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CityProvider()), 
        ChangeNotifierProvider(create: (_) => InstituteProvider()),
      ],
      child: MaterialApp(
        title: 'Air Quality App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomeScreen(),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Air Quality App Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CityListScreen()),
                );
              },
              child: Text('View Cities'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InstituteListScreen(),
                  ),
                );
              },
              child: Text('View Institutes'),
            ),
          ],
        ),
      ),
    );
  }
}
