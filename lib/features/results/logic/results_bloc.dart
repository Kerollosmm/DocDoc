import 'package:bloc/bloc.dart';
import 'package:doc_app/features/results/domain/entities/result_entity.dart';

sealed class ResultsEvent {
  const ResultsEvent();
}

class LoadResults extends ResultsEvent {
  const LoadResults();
}

sealed class ResultsState {
  const ResultsState();
}

class ResultsLoading extends ResultsState {
  const ResultsLoading();
}

class ResultsLoaded extends ResultsState {
  final List<ResultEntity> results;

  const ResultsLoaded(this.results);
}

class ResultsBloc extends Bloc<ResultsEvent, ResultsState> {
  ResultsBloc() : super(const ResultsLoading()) {
    on<LoadResults>(_onLoadResults);
  }

  final List<ResultEntity> _results = [
    ResultEntity(
      id: 'R1001',
      studentId: 'S1001',
      subject: 'Math Midterm',
      score: 88,
      date: DateTime(2025, 2, 15),
    ),
    ResultEntity(
      id: 'R1002',
      studentId: 'S1002',
      subject: 'Science Quiz',
      score: 92,
      date: DateTime(2025, 2, 20),
    ),
  ];

  void _onLoadResults(LoadResults event, Emitter<ResultsState> emit) {
    emit(ResultsLoaded(List.of(_results)));
  }
}
