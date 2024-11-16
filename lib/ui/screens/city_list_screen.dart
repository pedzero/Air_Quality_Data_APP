import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/city_provider.dart';

class CityListScreen extends StatefulWidget {
  const CityListScreen({Key? key}) : super(key: key);

  @override
  _CityListScreenState createState() => _CityListScreenState();
}

class _CityListScreenState extends State<CityListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<CityProvider>(context, listen: false).fetchCities());
  }

  @override
  Widget build(BuildContext context) {
    final cityProvider = Provider.of<CityProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Cities")),
      body: cityProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : cityProvider.cities.isEmpty
              ? const Center(child: Text("No cities found"))
              : ListView.builder(
                  itemCount: cityProvider.cities.length,
                  itemBuilder: (context, index) {
                    final city = cityProvider.cities[index];
                    return ListTile(
                      title: Text(city.name),
                      subtitle: Text("ID: ${city.id}"),
                    );
                  },
                ),
    );
  }
}
