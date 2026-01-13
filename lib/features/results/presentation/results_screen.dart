import 'package:doc_app/features/results/logic/results_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ResultsScreen extends StatelessWidget {
  const ResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ResultsBloc()..add(const LoadResults()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Results')),
        body: BlocBuilder<ResultsBloc, ResultsState>(
          builder: (context, state) {
            if (state is ResultsLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is ResultsLoaded) {
              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: state.results.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final result = state.results[index];
                  return ListTile(
                    leading: const Icon(Icons.school),
                    title: Text(result.subject),
                    subtitle: Text(
                      'Score: ${result.score.toStringAsFixed(0)} • ${result.date.toString().split(' ').first}',
                    ),
                  );
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
