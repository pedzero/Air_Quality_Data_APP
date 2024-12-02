import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:workmanager/workmanager.dart';

import 'package:air_quality_data_app/core/services/preferences_service.dart';
import 'package:air_quality_data_app/core/services/notification_service.dart';
import 'package:air_quality_data_app/core/services/parameter_service.dart';

const String airQualityTask = "checkAirQualityTask";

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    await dotenv.load(fileName: ".env");
    WidgetsFlutterBinding.ensureInitialized();

    if (task == airQualityTask) {
      try {
        await NotificationService.initialize();
        final preferredRooms =
            await PreferencesService.staticGetNotificationRooms();
        String body = "";

        for (var entry in preferredRooms.entries) {
          final roomId = entry.key;
          final roomName = entry.value;
          final parameters = ["CO2", "CO"];
          try {
            for (var parameterName in parameters) {
              final value = await ParameterService.fetchParameterValue(
                  roomId, parameterName);
              final message = generateMessage(parameterName, value);
              if (message.isNotEmpty) {
                body += "Sala $roomName: $message\n";
              }
            }
          } catch (e) {
            log("Erro ao buscar dados da sala $roomId ($roomName): $e");
          }
        }

        if (body.isNotEmpty) {
          await NotificationService.showNotification(
            title: "Alerta de Qualidade do Ar",
            body: body.trim(),
          );
        }
      } catch (e) {
        log("Erro ao executar a tarefa do Workmanager: $e");
      }
    }
    return Future.value(true);
  });
}

class WorkmanagerService {
  static void initialize() async {
    await Workmanager().initialize(callbackDispatcher, isInDebugMode: false);
  }

  static void registerPeriodicTask() {
    Workmanager().registerPeriodicTask(
      "1",
      airQualityTask,
      frequency: const Duration(minutes: 30),
    );
  }
}

String generateMessage(String parameterName, double value) {
  const Map<String, dynamic> severityConfig = {
    "CO2": {
      "unit": "ppm",
      "levels": [
        {"limit": 800, "severity": "Baixa"},
        {"limit": 1000, "severity": "Alta"},
        {"limit": 1400, "severity": "Crítica"},
      ],
    },
    "CO": {
      "unit": "ppm",
      "levels": [
        {"limit": 1, "severity": "Baixa"},
        {"limit": 5, "severity": "Alta"},
        {"limit": 10, "severity": "Crítica"},
      ],
    },
  };

  if (!severityConfig.containsKey(parameterName)) {
    return "";
  }

  final config = severityConfig[parameterName];
  final unit = config["unit"];
  final levels = config["levels"] as List<Map<String, dynamic>>;

  if (value < levels.first["limit"]) {
    return "";
  }

  String? severity;
  for (var i = 0; i < levels.length; i++) {
    if (value < levels[i]["limit"]) {
      severity = levels[i]["severity"];
      break;
    }
  }

  severity ??= levels.last["severity"];

  return "Nível de $parameterName: $value $unit. (Severidade: $severity)";
}
