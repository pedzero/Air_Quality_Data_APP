
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'package:air_quality_data_app/core/providers/favorites_provider.dart';
import 'package:air_quality_data_app/core/providers/selection_provider.dart';
import 'package:air_quality_data_app/core/providers/city_provider.dart';
import 'package:air_quality_data_app/core/providers/institute_provider.dart';
import 'package:air_quality_data_app/core/providers/room_provider.dart';

import 'package:air_quality_data_app/ui/screens/city_list_screen.dart';
import 'package:air_quality_data_app/ui/screens/institute_list_screen.dart';
import 'package:air_quality_data_app/ui/screens/room_list_screen.dart';
import 'package:air_quality_data_app/ui/screens/details_view.dart';
import 'package:air_quality_data_app/ui/screens/favorites_view.dart';
import 'package:air_quality_data_app/ui/screens/selection_view.dart';

Future main() async {
  await dotenv.load(fileName: '.env');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CityProvider()), 
        ChangeNotifierProvider(create: (_) => InstituteProvider()),
        ChangeNotifierProvider(create: (_) => RoomProvider()),
        ChangeNotifierProvider(create: (_) => SelectionProvider()),
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
      ],
      child: MaterialApp(
        title: 'Air Quality App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Air Quality App Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /*ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CityListScreen()),
                );
              },
              child: const Text('View Cities'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const InstituteListScreen(),
                  ),
                );
              },
              child: const Text('View Institutes'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RoomListScreen(),
                  ),
                );
              },
              child: const Text('View Rooms'),
            ),*/
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SelectionView(),
                  ),
                );
              },
              child: const Text('View Selection'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FavoritesView(),
                  ),
                );
              },
              child: const Text('View Favorites'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DetailsView(),
                  ),
                );
              },
              child: const Text('View Details'),
            ),
          ],
        ),
      ),
    );
  }
}
