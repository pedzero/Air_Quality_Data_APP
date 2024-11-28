import 'package:air_quality_data_app/core/models/parameter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:air_quality_data_app/core/providers/favorites_provider.dart';

class DetailsView extends StatelessWidget {
  const DetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FavoritesProvider()..fetchRooms(),
      child: const DetailsScreen(),
    );
  }
}

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FavoritesProvider>(context);

    if (provider.favoriteRooms.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Detalhes do Ambiente"),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final room = provider.favoriteRooms.first;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Detalhes do Ambiente"),
        backgroundColor: Colors.grey.shade800,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // room name
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                room.name,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "${room.instituteName}, ${room.cityName}",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey,
                ),
              ),
            ),
            const Divider(height: 20, thickness: 1),

            // parameters
            _buildSectionTitle("Parâmetros"),
            Column(
              children: room.parameters.map((param) {
                return _buildParameterItem(
                    param.name, param.value.toString(), _getParamUnit(param));
              }).toList(),
            ),
            const Divider(height: 20, thickness: 1),

            // aqi
            _buildSectionTitle("Índice de Qualidade do Ar"),
            Column(
              children: room.aqi.parameters.map((param) {
                return _buildParameterItem(
                    param.name, param.value.toStringAsPrecision(3), "µg/m³");
              }).toList(),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Geral: ${_getIQACategory(room.aqi.index)}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            const Divider(height: 20, thickness: 1),

            // todo history charts
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildParameterItem(String name, String value, String unit) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          Text(
            "$value $unit",
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  String _getParamUnit(Parameter parameter) {
    if (parameter.aqiIncluded) {
      return 'µg/m³';
    }
    switch (parameter.name) {
      case 'Temperatura':
        return '°C';
      case 'Umidade':
        return '%';
      case 'CO2':
        return 'ppm';
      default:
        return 'index';
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
