import 'package:air_quality_data_app/core/models/history.dart';
import 'package:air_quality_data_app/core/services/history_service.dart';
import 'package:flutter/material.dart';
import '../../core/models/room.dart';
import '../../core/services/room_service.dart';

class DetailsProvider with ChangeNotifier {
  final RoomService _roomService = RoomService();
  final HistoryService _historyService = HistoryService();

  final predefinedIntervals = [
    "2 horas",
    "6 horas",
    "12 horas",
    "1 dia",
    "2 dias"
  ];

  Room? _room;
  bool _isLoading = false;
  bool _isLoadingChart = false;
  String? _errorMessage;

  String? _selectedParameter;
  String? _selectedInterval;
  List<History> _historicalData = [];

  Room? get room => _room;
  bool get isLoading => _isLoading;
  bool get isLoadingChart => _isLoadingChart;
  String? get errorMessage => _errorMessage;
  String? get selectedParameter => _selectedParameter;
  String? get selectedInterval => _selectedInterval;
  List<History> get historicalData => _historicalData;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setLoadingChart(bool value) {
    _isLoadingChart = value;
    notifyListeners();
  }

  void setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  void setSelectedParameter(String parameter) {
    _selectedParameter = parameter;
    fetchHistoricalData();
  }

  void setSelectedInterval(String interval) {
    _selectedInterval = interval;
    fetchHistoricalData();
  }

  Future<void> fetchRoom(int roomId) async {
    setLoading(true);
    setError(null);

    try {
      _room = await _roomService.fetchCompleteRoom(roomId);
      if (_room == null) {
        setError("Sala não encontrada.");
      }
    } catch (e) {
      setError("Erro ao carregar os detalhes da sala: ${e.toString()}");
    } finally {
      setLoading(false);
    }
  }

  Future<void> fetchHistoricalData() async {
    if (_selectedParameter == null ||
        _selectedInterval == null ||
        _room == null) {
      setError("Parâmetros insuficientes para buscar os dados históricos.");
      return;
    }

    setLoadingChart(true);
    setError(null);

    try {
      final now = DateTime.timestamp();
      Duration duration;
      int precision;

      switch (_selectedInterval) {
        case "2 horas":
          duration = const Duration(hours: 2);
          precision = 12;
          break;
        case "6 horas":
          duration = const Duration(hours: 6);
          precision = 12;
          break;
        case "12 horas":
          duration = const Duration(hours: 12);
          precision = 12;
          break;
        case "1 dia":
          duration = const Duration(days: 1);
          precision = 24;
          break;
        case "2 dias":
          duration = const Duration(days: 2);
          precision = 24;
          break;
        default:
          setError("Intervalo inválido.");
          setLoadingChart(false);
          return;
      }

      final timestampEnd = now;
      final timestampStart = now.subtract(duration);

      final parameter = _room!.parameters.firstWhere(
        (param) => param.name == _selectedParameter,
        orElse: () => throw Exception("Parâmetro selecionado não encontrado."),
      );

      final data = await _historyService.fetchHistoricalData(
        _room!.id,
        parameter.name,
        parameter.aqiIncluded,
        timestampStart,
        timestampEnd,
        precision
      );

      _historicalData = data;
    } catch (e) {
      setError("Erro ao carregar os dados históricos: ${e.toString()}");
    } finally {
      setLoadingChart(false);
    }
  }
}
