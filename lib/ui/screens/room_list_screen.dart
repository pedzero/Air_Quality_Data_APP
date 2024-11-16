import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/room_provider.dart';

class RoomListScreen extends StatefulWidget {
  const RoomListScreen({super.key});

  @override
  _RoomListScreenState createState() => _RoomListScreenState();
}

class _RoomListScreenState extends State<RoomListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => 
        Provider.of<RoomProvider>(context, listen: false)
            .fetchRooms());
  }

  @override
  Widget build(BuildContext context) {
    final roomProvider = Provider.of<RoomProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Rooms")),
      body: roomProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : roomProvider.rooms.isEmpty
              ? const Center(child: Text("No rooms found"))
              : ListView.builder(
                  itemCount: roomProvider.rooms.length,
                  itemBuilder: (context, index) {
                    final room = roomProvider.rooms[index];
                    return ListTile(
                      title: Text(room.name),
                      subtitle: Text("ID: ${room.id}"),
                    );
                  },
                ),
    );
  }
}
