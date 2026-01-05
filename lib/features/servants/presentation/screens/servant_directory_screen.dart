import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../../../../domain/entities/user.dart';
import '../../../../domain/repositories/user_repository.dart';

class ServantDirectoryScreen extends StatefulWidget {
  const ServantDirectoryScreen({super.key});

  @override
  State<ServantDirectoryScreen> createState() => _ServantDirectoryScreenState();
}

class _ServantDirectoryScreenState extends State<ServantDirectoryScreen> {
  late Future<List<User>> _servantsFuture;

  @override
  void initState() {
    super.initState();
    _loadServants();
  }

  void _loadServants() {
    _servantsFuture = GetIt.I<UserRepository>().getServants().then((result) {
      return result.fold(
        (failure) => throw Exception(failure.message),
        (servants) => servants,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Servant Directory')),
      body: FutureBuilder<List<User>>(
        future: _servantsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No servants found.'));
          }

          final servants = snapshot.data!;
          return ListView.builder(
            itemCount: servants.length,
            itemBuilder: (context, index) {
              final servant = servants[index];
              return ListTile(
                title: Text(servant.name),
                subtitle: Text(servant.grade ?? 'No Grade'),
                leading: const CircleAvatar(child: Icon(Icons.person)),
              );
            },
          );
        },
      ),
    );
  }
}
