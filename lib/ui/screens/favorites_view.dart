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
          ? ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: 2, // change to saved room number
              itemBuilder: (context, index) {
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.only(bottom: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Container(
                    height: 120,
                    padding: const EdgeInsets.all(16.0),
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                );
              },
            )
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
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                // stats
                                Expanded(
                                  flex: 65,
                                  child: Container(
                                    padding: const EdgeInsets.only(right: 16.0),
                                    decoration: const BoxDecoration(
                                      border: Border(
                                        right: BorderSide(
                                          color: Colors.grey,
                                          width: 1,
                                        ),
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          room.name,
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          '${room.instituteName}, ${room.cityName}',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        const Text(
                                          "IQA",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          _getIQACategory(room.aqi.index),
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: _getIQAColor(room.aqi.index),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                // main parameters
                                Expanded(
                                  flex: 35,
                                  child: Container(
                                    padding: const EdgeInsets.only(left: 16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // colorful bar
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              bottomLeft:
                                  Radius.circular(12), 
                              bottomRight:
                                  Radius.circular(12), 
                            ),
                            child: Container(
                              height: 8, 
                              color: _getIQAColor(
                                  room.aqi.index), 
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }

  Widget _buildParameterRow(IconData icon, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey),
          const SizedBox(width: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
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
}
