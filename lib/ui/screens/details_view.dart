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
          title: Text(
            "Detalhes do Ambiente",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Detalhes do Ambiente",
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // room
            Text(
              room!.name,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              "${room.instituteName}, ${room.cityName}",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey,
                  ),
            ),
            const Divider(height: 20, thickness: 1),

            // parameters
            _buildSectionTitle(context, "Parâmetros"),
            Column(
              children: room.parameters.map((param) {
                return _buildParameterItem(context, param.name,
                    param.value.toString(), _getParamUnit(param));
              }).toList(),
            ),
            const Divider(height: 20, thickness: 1),

            // AQI
            _buildSectionTitle(context, "Índice de Qualidade do Ar"),
            Column(
              children: room.aqi.parameters.map((param) {
                return _buildParameterItem(context, param.name,
                    param.value.toStringAsPrecision(3), "µg/m³");
              }).toList(),
            ),
            const SizedBox(height: 16),
            Text(
              "Geral: ${_getIQACategory(room.aqi.index)}",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const Divider(height: 20, thickness: 1),

            // history
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Histórico",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
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
                      value: provider.selectedInterval ?? provider.predefinedIntervals.first,
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
                    ? _buildChart(context, provider.historicalData)
                    : Center(
                        child: Text(
                          "Nenhum dado disponível",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
          ],
        ),
      ),
    );
  }

  Widget _buildChart(BuildContext context, List<History> data) {
    final allValues = [
      ...data.map((e) => e.averageValue),
      ...data.map((e) => e.maxValue),
      ...data.map((e) => e.minValue),
    ];
    final minValue = allValues.reduce((a, b) => a < b ? a : b);
    final maxValue = allValues.reduce((a, b) => a > b ? a : b);
    final rangePadding = (maxValue - minValue) * 0.05;

    List<FlSpot> avgSpots = [];
    List<FlSpot> maxSpots = [];
    List<FlSpot> minSpots = [];

    for (var i = 0; i < data.length; i++) {
      final point = data[i];
      avgSpots.add(FlSpot(i.toDouble(), point.averageValue.toDouble()));
      maxSpots.add(FlSpot(i.toDouble(), point.maxValue.toDouble()));
      minSpots.add(FlSpot(i.toDouble(), point.minValue.toDouble()));
    }

    return Column(
      children: [
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              height: 300,
              child: LineChart(
                LineChartData(
                  lineBarsData: [
                    LineChartBarData(
                      spots: avgSpots,
                      isCurved: true,
                      color: Theme.of(context).colorScheme.primary,
                      belowBarData: BarAreaData(show: false),
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, _, __, ___) =>
                            FlDotCirclePainter(radius: 3, color: Colors.blue),
                      ),
                      barWidth: 3,
                    ),
                    LineChartBarData(
                      spots: maxSpots,
                      isCurved: true,
                      color: Colors.red,
                      belowBarData: BarAreaData(show: false),
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, _, __, ___) =>
                            FlDotCirclePainter(radius: 3, color: Colors.red),
                      ),
                      barWidth: 3,
                    ),
                    LineChartBarData(
                      spots: minSpots,
                      isCurved: true,
                      color: Colors.green,
                      belowBarData: BarAreaData(show: false),
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, _, __, ___) =>
                            FlDotCirclePainter(radius: 3, color: Colors.green),
                      ),
                      barWidth: 3,
                    ),
                  ],
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toStringAsFixed(0),
                            style: Theme.of(context).textTheme.bodySmall,
                          );
                        },
                      ),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() < data.length) {
                            final timestamp = data[value.toInt()].bucketStart;
                            final localTime = timestamp.toLocal();
                            return Text(
                              "${localTime.hour}:${localTime.minute.toString().padLeft(2, '0')}",
                              style: Theme.of(context).textTheme.bodySmall,
                            );
                          }
                          return const SizedBox();
                        },
                      ),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: Theme.of(context).dividerColor),
                  ),
                  gridData: const FlGridData(show: true),
                  minY: minValue - rangePadding,
                  maxY: maxValue + rangePadding,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLegendItem(context, Colors.blue, "Média"),
            const SizedBox(width: 16),
            _buildLegendItem(context, Colors.red, "Máximo"),
            const SizedBox(width: 16),
            _buildLegendItem(context, Colors.green, "Mínimo"),
          ],
        ),
      ],
    );
  }

  Widget _buildLegendItem(BuildContext context, Color color, String label) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  Widget _buildParameterItem(
      BuildContext context, String name, String value, String unit) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
          Text(
            "$value $unit",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).hintColor,
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
      case 'Pressao':
        return 'hPa';
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
