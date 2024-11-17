import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/city_provider.dart';
import '../../core/providers/institute_provider.dart';
import '../../core/providers/room_provider.dart';

class SelectionView extends StatefulWidget {
  const SelectionView({super.key});

  @override
  _SelectionViewState createState() => _SelectionViewState();
}

class _SelectionViewState extends State<SelectionView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<CityProvider>(context, listen: false).fetchCities());
  }

  int? selectedCityId;
  int? selectedInstituteId;
  int? selectedRoomId;

  @override
  Widget build(BuildContext context) {
    final cityProvider = Provider.of<CityProvider>(context);
    final instituteProvider = Provider.of<InstituteProvider>(context);
    final roomProvider = Provider.of<RoomProvider>(context);

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

            // city selection
            cityProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: "Cidade"),
                    value: selectedCityId?.toString(),
                    items: cityProvider.cities
                        .map((city) => DropdownMenuItem<String>(
                              value: city.id.toString(),
                              child: Text(city.name),
                            ))
                        .toList(),
                    onChanged: (value) {
                      final cityId = int.tryParse(value ?? "");
                      if (cityId != null) {
                        setState(() {
                          selectedCityId = cityId;
                          selectedInstituteId = null;
                          selectedRoomId = null;
                        });
                        instituteProvider.fetchInstitutesByCityId(cityId);
                      }
                    },
                  ),
            const SizedBox(height: 16),

            // institute selection
            instituteProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: "Instituto"),
                    value: selectedInstituteId?.toString(),
                    items: instituteProvider.institutes
                        .map((institute) => DropdownMenuItem<String>(
                              value: institute.id.toString(),
                              child: Text(institute.name),
                            ))
                        .toList(),
                    onChanged: (value) {
                      final instituteId = int.tryParse(value ?? "");
                      if (instituteId != null) {
                        setState(() {
                          selectedInstituteId = instituteId;
                          selectedRoomId = null;
                        });
                        roomProvider.fetchRoomsByInstituteId(instituteId);
                      }
                    },
                  ),
            const SizedBox(height: 16),

            // room selection
            roomProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: "Ambiente"),
                    value: selectedRoomId?.toString(),
                    items: roomProvider.rooms
                        .map((room) => DropdownMenuItem<String>(
                              value: room.id.toString(),
                              child: Text(room.name),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedRoomId = int.tryParse(value ?? "");
                      });
                    },
                  ),
            const Spacer(),

            // save
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                onPressed: selectedRoomId == null
                    ? null
                    : () {
                        final selectedRoom = roomProvider.rooms
                            .firstWhere(
                                (room) => room.id == selectedRoomId,
                            );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                "Ambiente salvo: ${selectedRoom.name}"),
                          ),
                        );
                      },
                child: const Text("Salvar"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
