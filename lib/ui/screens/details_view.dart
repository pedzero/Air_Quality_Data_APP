import 'package:air_quality_data_app/core/models/history.dart';
import 'package:air_quality_data_app/core/models/parameter.dart';
import 'package:air_quality_data_app/core/providers/details_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailsView extends StatelessWidget {
  final int roomId;

  const DetailsView({super.key, required this.roomId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DetailsProvider()..fetchRoom(roomId),
      child: DetailsScreen(roomId: roomId),
    );
  }
}

class DetailsScreen extends StatelessWidget {
  final int roomId;

  const DetailsScreen({super.key, required this.roomId});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DetailsProvider>(context);
    final room = provider.room;

    if (provider.isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Detalhes do Ambiente"),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Detalhes do Ambiente"),
        backgroundColor: Colors.grey.shade800,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // room
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                room!.name,
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
                  param.name,
                  param.value.toString(),
                  _getParamUnit(param),
                );
              }).toList(),
            ),
            const Divider(height: 20, thickness: 1),

            // aqi
            _buildSectionTitle("Índice de Qualidade do Ar"),
            Column(
              children: room.aqi.parameters.map((param) {
                return _buildParameterItem(
                  param.name,
                  param.value.toStringAsPrecision(3),
                  "µg/m³",
                );
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

            // title and dropdown menus
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Histórico",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Row(
                  children: [
                    DropdownButton<String>(
                      value: provider.selectedParameter,
                      items: provider.room!.parameters.map((p) {
                        return DropdownMenuItem(
                          value: p.name,
                          child: Text(p.name),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) provider.setSelectedParameter(value);
                      },
                    ),
                    const SizedBox(width: 8),
                    DropdownButton<String>(
                      value: provider.selectedInterval,
                      items: provider.predefinedIntervals.map((interval) {
                        return DropdownMenuItem(
                          value: interval,
                          child: Text(interval),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) provider.setSelectedInterval(value);
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            // chart
            provider.isLoadingChart
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : provider.historicalData.isNotEmpty
                    ? _buildChart(provider.historicalData)
                    : const Center(
                        child: Text("Nenhum dado disponível"),
                      ),
          ],
        ),
      ),
    );
  }

  Widget _buildChart(List<History> data) {
    List<FlSpot> avgSpots = [];
    List<FlSpot> maxSpots = [];
    List<FlSpot> minSpots = [];

    for (var i = 0; i < data.length; i++) {
      final point = data[i];
      avgSpots.add(FlSpot(i.toDouble(), point.averageValue.toDouble()));
      maxSpots.add(FlSpot(i.toDouble(), point.maxValue.toDouble()));
      minSpots.add(FlSpot(i.toDouble(), point.minValue.toDouble()));
    }

    return SizedBox(
      height: 300,
      child: LineChart(
        LineChartData(
          lineBarsData: [
            LineChartBarData(
              spots: avgSpots,
              isCurved: true,
              color: Colors.blue,
              belowBarData: BarAreaData(show: false),
              dotData: const FlDotData(show: false),
              barWidth: 3,
            ),
            LineChartBarData(
              spots: maxSpots,
              isCurved: true,
              color: Colors.red,
              belowBarData: BarAreaData(show: false),
              dotData: const FlDotData(show: false),
              barWidth: 3,
            ),
            LineChartBarData(
              spots: minSpots,
              isCurved: true,
              color: Colors.green,
              belowBarData: BarAreaData(show: false),
              dotData: const FlDotData(show: false),
              barWidth: 3,
            ),
          ],
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: true, reservedSize: 40),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                getTitlesWidget: (value, meta) {
                  if (value % 2 == 0 && value.toInt() < data.length) {
                    final date = data[value.toInt()].bucketStart;
                    return Text(
                      "${date.hour}:${date.minute.toString().padLeft(2, '0')}",
                      style: const TextStyle(fontSize: 10),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(color: Colors.black, width: 1),
          ),
          gridData: const FlGridData(show: true),
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
