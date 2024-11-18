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

    return Scaffold(
      appBar: AppBar(
        title: const Text("Ambientes Favoritos"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: provider.isLoading ? null : provider.fetchRooms,
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // selection screen
            },
          ),
        ],
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.favoriteRooms.isEmpty
              ? const Center(
                  child: Text("Nenhum ambiente salvo como favorito."),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: provider.favoriteRooms.length,
                  itemBuilder: (context, index) {
                    final room = provider.favoriteRooms[index];
                    return Card(
                      elevation: 4,
                      margin: const EdgeInsets.only(bottom: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              room.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${room.instituteName}, ${room.cityName}',
                              style: const TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("IQA"),
                                    Text(
                                      "to do",
                                      style: TextStyle(
                                        color: _getIqaColor("Bom"),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    _buildParameterRow(
                                      Icons.thermostat,
                                      "${room.parameters.firstWhere((parameter) => parameter.name == "Temperatura").value} °C",
                                    ),
                                    _buildParameterRow(
                                      Icons.water_drop,
                                      "${room.parameters.firstWhere((parameter) => parameter.name == "Umidade").value}%",
                                    ),
                                    _buildParameterRow(
                                      Icons.co2,
                                      "${room.parameters.firstWhere((parameter) => parameter.name == "CO2").value} ppm",
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  Widget _buildParameterRow(IconData icon, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 4),
        Text(value, style: const TextStyle(fontSize: 14)),
      ],
    );
  }

  Color _getIqaColor(String status) {
    switch (status) {
      case "Bom":
        return Colors.green;
      case "Moderado":
        return Colors.orange;
      case "Péssimo":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
