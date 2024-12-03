import 'package:air_quality_data_app/ui/screens/details_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/models/room.dart';
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

class SelectionScreen extends StatelessWidget {
  const SelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SelectionProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Seleção de Ambientes"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDropdown(
              context,
              label: "Selecione uma cidade",
              hint: provider.selectedCity?.name ?? "Cidade",
              items: provider.cities.map((city) => city.name).toList(),
              isLoading: provider.isCityLoading,
              onChanged: (index) {
                final city = provider.cities[index];
                provider.setSelectedCity(city);
                provider.setSelectedInstitute(null);
                provider.clearRooms();
                provider.fetchInstitutesByCityId(city.id);
              },
            ),
            const SizedBox(height: 16),
            _buildDropdown(
              context,
              label: "Selecione uma instituição",
              hint: provider.selectedInstitute?.name ?? "Instituição",
              items: provider.institutes
                  .map((institute) => institute.name)
                  .toList(),
              isLoading: provider.isInstituteLoading,
              onChanged: (index) {
                final institute = provider.institutes[index];
                provider.setSelectedInstitute(institute);
                provider.clearRooms();
                provider.fetchRoomsByInstituteId(institute.id);
              },
            ),
            if (provider.selectedInstitute != null) ...[
              const SizedBox(height: 16),
              Text(
                "Ambientes",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
            const SizedBox(height: 16),
            Expanded(
              child: provider.isRoomLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: provider.rooms.length,
                      itemBuilder: (context, index) {
                        final room = provider.rooms[index];
                        return RoomCard(room: room, provider: provider);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown(
    BuildContext context, {
    required String label,
    required String hint,
    required List<String> items,
    required bool isLoading,
    required Function(int) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        isLoading
            ? const LinearProgressIndicator()
            : DropdownButtonFormField<int>(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                isExpanded: true,
                hint: Text(hint),
                items: items
                    .asMap()
                    .entries
                    .map((entry) => DropdownMenuItem(
                          value: entry.key,
                          child: Text(entry.value),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) onChanged(value);
                },
              ),
      ],
    );
  }
}

class RoomCard extends StatelessWidget {
  final Room room;
  final SelectionProvider provider;

  const RoomCard({
    required this.room,
    required this.provider,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                room.name,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FutureBuilder<bool>(
                  future: provider.isPinnedForRoom(room.id),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const CircularProgressIndicator();
                    }
                    return IconButton(
                      icon: Icon(
                        snapshot.data! ? Icons.star : Icons.star_border,
                        color: snapshot.data!
                            ? Colors.amber.shade400
                            : Colors.grey,
                      ),
                      onPressed: () {
                        provider.setPinnedForRoom(room.id, !snapshot.data!);
                        _showFeedback(
                          context,
                          snapshot.data!
                              ? "${room.name} removido dos favoritos"
                              : "${room.name} adicionado aos favoritos",
                        );
                      },
                    );
                  },
                ),
                FutureBuilder<bool>(
                  future: provider.receiveAlertsForRoom(room.id),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const CircularProgressIndicator();
                    }
                    return IconButton(
                      icon: Icon(
                        snapshot.data!
                            ? Icons.notifications
                            : Icons.notifications_none,
                        color: snapshot.data!
                            ? const Color.fromARGB(255, 7, 141, 146)
                            : Colors.grey,
                      ),
                      onPressed: () {
                        provider.setNotificationForRoom(
                            room.id, !snapshot.data!, room.name);
                        _showFeedback(
                          context,
                          snapshot.data!
                              ? "Notificações desativadas para ${room.name}"
                              : "Notificações ativadas ${room.name}",
                        );
                      },
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.info_outline),
                  color: Colors.grey,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailsView(roomId: room.id),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showFeedback(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(milliseconds: 800),
      ),
    );
  }
}
