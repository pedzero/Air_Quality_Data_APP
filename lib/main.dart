import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'package:air_quality_data_app/ui/theme.dart';
import 'package:air_quality_data_app/core/services/notification_service.dart';
import 'package:air_quality_data_app/core/services/workmanager_service.dart';
import 'package:air_quality_data_app/core/providers/favorites_provider.dart';
import 'package:air_quality_data_app/core/providers/selection_provider.dart';
import 'package:air_quality_data_app/core/providers/details_provider.dart';
import 'package:air_quality_data_app/ui/screens/favorites_view.dart';

Future main() async {
  await dotenv.load(fileName: '.env');
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService.initialize();
  NotificationService.requestNotificationPermission();
  WorkmanagerService.initialize();
  WorkmanagerService.registerPeriodicTask();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SelectionProvider()),
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
        ChangeNotifierProvider(create: (_) => DetailsProvider()),
      ],
      child: MaterialApp(
      title: 'Air Quality App',
      theme: MistySeaTheme.lightTheme, 
      darkTheme: MistySeaTheme.darkTheme, 
      themeMode: ThemeMode.system,
      home: const FavoritesView(),
      ),
    );
  }
}
