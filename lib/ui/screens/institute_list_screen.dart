import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/institute_provider.dart';

class InstituteListScreen extends StatefulWidget {
  const InstituteListScreen({Key? key}) : super(key: key);

  @override
  _InstituteListScreenState createState() => _InstituteListScreenState();
}

class _InstituteListScreenState extends State<InstituteListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<InstituteProvider>(context, listen: false)
            .fetchInstitutes());
  }

  @override
  Widget build(BuildContext context) {
    final instituteProvider = Provider.of<InstituteProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Institutes")),
      body: instituteProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : instituteProvider.institutes.isEmpty
              ? const Center(child: Text("No institutes found"))
              : ListView.builder(
                  itemCount: instituteProvider.institutes.length,
                  itemBuilder: (context, index) {
                    final institute = instituteProvider.institutes[index];
                    return ListTile(
                      title: Text(institute.name),
                      subtitle: Text("ID: ${institute.id}"),
                    );
                  },
                ),
    );
  }
}
