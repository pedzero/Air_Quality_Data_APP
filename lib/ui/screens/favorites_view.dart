import 'package:air_quality_data_app/core/models/room.dart';
import 'package:air_quality_data_app/ui/screens/details_view.dart';
import 'package:air_quality_data_app/ui/screens/selection_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/favorites_provider.dart';

class FavoritesView extends StatelessWidget {
  const FavoritesView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FavoritesProvider()..fetchRooms(),
      child: const FavoritesScreen(),
    );
  }
}

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FavoritesProvider>(context);
    final favoriteRooms = provider.favoriteRooms;
    final isLoading = provider.isLoading;
    final totalRooms = provider.totalFavorites;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/nobg_logo_aether.png',
              height: 24,
              width: 24,
            ),
            const SizedBox(width: 8),
            Text(
              'Aether',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.normal,
                  ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: isLoading ? null : provider.fetchRooms,
          ),
          IconButton(
            icon: const Icon(Icons.home_work),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SelectionView(),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ambientes Favoritos',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.normal,
                  ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: totalRooms,
                itemBuilder: (context, index) {
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: index >= favoriteRooms.length
                        ? _buildLoadingCard()
                        : _buildRoomCard(context, favoriteRooms[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingCard() {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: const SizedBox(
        height: 120,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget _buildRoomCard(BuildContext context, Room room) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailsView(roomId: room.id),
            ),
          );
        },
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 65,
                    child: Container(
                      padding: const EdgeInsets.only(right: 16.0),
                      decoration: const BoxDecoration(
                        border: Border(
                          right: BorderSide(color: Colors.grey, width: 0.5),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            room.name,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          Text(
                            '${room.instituteName}, ${room.cityName}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: Theme.of(context).hintColor),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: _getIQAColor(room.aqi.index),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "IQA: ${_getIQACategory(room.aqi.index)}",
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 35,
                    child: Container(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildParameterRow(context, Icons.thermostat,
                              "${room.parameters.firstWhere((p) => p.name == "Temperatura").value} °C"),
                          _buildParameterRow(context, Icons.water_drop,
                              "${room.parameters.firstWhere((p) => p.name == "Umidade").value}%"),
                          _buildParameterRow(
                              context,
                              Icons.co2,
                              "${room.parameters.firstWhere((p) => p.name == "CO2").value} ppm",
                              _getCO2Color(room.parameters
                                  .firstWhere((p) => p.name == "CO2")
                                  .value)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
              child: Container(
                height: 8,
                color: _isCO2WorseThanIQA(
                        room.parameters
                            .firstWhere((p) => p.name == "CO2")
                            .value,
                        room.aqi.index)
                    ? _getCO2Color(room.parameters
                        .firstWhere((p) => p.name == "CO2")
                        .value)
                    : _getIQAColor(room.aqi.index),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildParameterRow(BuildContext context, IconData icon, String value,
      [Color iconColor = Colors.grey]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: iconColor),
          const SizedBox(width: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }

  Color _getIQAColor(int index) {
    switch (index) {
      case 1:
        return Colors.green;
      case 2:
        return Colors.yellow;
      case 3:
        return Colors.orange;
      case 4:
        return Colors.red;
      case 5:
        return Colors.deepPurple;
      default:
        return Colors.grey;
    }
  }

  String _getIQACategory(int index) {
    switch (index) {
      case 1:
        return 'Bom';
      case 2:
        return 'Moderado';
      case 3:
        return 'Ruim';
      case 4:
        return 'Muito ruim';
      case 5:
        return 'Péssimo';
      default:
        return 'Desconhecido';
    }
  }

  Color _getCO2Color(double co2Value) {
    const minCO2 = 800.0;
    const maxCO2 = 1400.0;

    co2Value = co2Value.clamp(minCO2, maxCO2);

    const stops = [800, 1040, 1160, 1280, 1400];
    const colors = [
      Colors.green,
      Colors.yellow,
      Colors.orange,
      Colors.red,
      Colors.purple,
    ];

    for (var i = 0; i < stops.length - 1; i++) {
      if (co2Value >= stops[i] && co2Value <= stops[i + 1]) {
        final t = (co2Value - stops[i]) / (stops[i + 1] - stops[i]);
        return Color.lerp(colors[i], colors[i + 1], t)!;
      }
    }

    return colors.last;
  }

  bool _isCO2WorseThanIQA(double co2Value, int iqaIndex) {
    const minCO2 = 800.0;
    const maxCO2 = 1400.0;

    final co2Severity = ((co2Value - minCO2) / (maxCO2 - minCO2) * 5).ceil();
    final iqaSeverity = iqaIndex;

    return co2Severity > iqaSeverity;
  }
}
