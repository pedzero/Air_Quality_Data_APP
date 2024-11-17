import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/selection_provider.dart';

class SelectionView extends StatelessWidget {
  const SelectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SelectionProvider()..fetchCities(),
      child: const SelectionScreen(),
    );
  }
}

class SelectionScreen extends StatefulWidget {
  const SelectionScreen({super.key});

  @override
  _SelectionScreenState createState() => _SelectionScreenState();
}

class _SelectionScreenState extends State<SelectionScreen> {
  int? selectedCityId;
  int? selectedInstituteId;
  int? selectedRoomId;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SelectionProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Selecionar Ambiente"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Selecionar Ambiente",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // city dropdown
            DropdownButtonFormField<int>(
              decoration: const InputDecoration(labelText: "Cidade"),
              value: selectedCityId,
              items: provider.cities
                  .map((city) => DropdownMenuItem<int>(
                        value: city.id,
                        child: Text(city.name),
                      ))
                  .toList(),
              onChanged: provider.isCityLoading
                  ? null
                  : (value) async {
                      setState(() {
                        selectedCityId = value;
                        selectedInstituteId = null;
                        selectedRoomId = null;
                      });
                      if (value != null) {
                        await provider.fetchInstitutesByCityId(value);
                      }
                    },
              isExpanded: true,
              isDense: true,
            ),
            if (provider.isCityLoading)
              const Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: LinearProgressIndicator(),
              ),
            const SizedBox(height: 16),

            // institute dropdown
            DropdownButtonFormField<int>(
              decoration: const InputDecoration(labelText: "Instituto"),
              value: selectedInstituteId,
              items: provider.institutes
                  .map((institute) => DropdownMenuItem<int>(
                        value: institute.id,
                        child: Text(institute.name),
                      ))
                  .toList(),
              onChanged: provider.isInstituteLoading
                  ? null
                  : (value) async {
                      setState(() {
                        selectedInstituteId = value;
                        selectedRoomId = null;
                      });
                      if (value != null) {
                        await provider.fetchRoomsByInstituteId(value);
                      }
                    },
              isExpanded: true,
              isDense: true,
            ),
            if (provider.isInstituteLoading)
              const Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: LinearProgressIndicator(),
              ),
            const SizedBox(height: 16),

            // room dropdown
            DropdownButtonFormField<int>(
              decoration: const InputDecoration(labelText: "Ambiente"),
              value: selectedRoomId,
              items: provider.rooms
                  .map((room) => DropdownMenuItem<int>(
                        value: room.id,
                        child: Text(room.name),
                      ))
                  .toList(),
              onChanged: provider.isRoomLoading
                  ? null
                  : (value) {
                      setState(() {
                        selectedRoomId = value;
                      });
                    },
              isExpanded: true,
              isDense: true,
            ),
            if (provider.isRoomLoading)
              const Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: LinearProgressIndicator(),
              ),
            const SizedBox(height: 16),

             // checkboxes
            Row(
              children: [
                Checkbox(
                  value: provider.isPinned,
                  onChanged: provider.areSelectionsDisabled()
                      ? null
                      : (value) {
                          provider.setPinned(value ?? false);
                        },
                ),
                const Text("Fixar na tela inicial"),
              ],
            ),
            Row(
              children: [
                Checkbox(
                  value: provider.receiveAlerts,
                  onChanged: provider.areSelectionsDisabled()
                      ? null
                      : (value) {
                          provider.setReceiveAlerts(value ?? false);
                        },
                ),
                const Text("Receber alertas"),
              ],
            ),
            const Spacer(),

            // buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: selectedRoomId == null
                      ? null
                      : () {
                          final room = provider.rooms.firstWhere(
                            (r) => r.id == selectedRoomId,
                          );
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text("Detalhes do Ambiente"),
                              content: Text("Nome: ${room.name}"),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("Fechar"),
                                ),
                              ],
                            ),
                          );
                        },
                  child: const Text("Detalhes"),
                ),
                ElevatedButton(
                  onPressed: selectedRoomId == null
                      ? null
                      : () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Ambiente salvo: ${provider.rooms.firstWhere((room) => room.id == selectedRoomId).name}",
                              ),
                            ),
                          );
                        },
                  child: const Text("Salvar"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
