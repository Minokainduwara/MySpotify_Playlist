// playlist_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import '../repository/playlist_repository.dart';
import '../models/track_model.dart';

abstract class PlaylistState {}

class PlaylistInitial extends PlaylistState {}

class PlaylistLoading extends PlaylistState {}

class PlaylistCodeRequired extends PlaylistState {}

class PlaylistLoaded extends PlaylistState {
  final List<Track> tracks;
  PlaylistLoaded(this.tracks);
}

class PlaylistError extends PlaylistState {
  final String message;
  PlaylistError(this.message);
}

class PlaylistCubit extends Cubit<PlaylistState> {
  final PlaylistRepository repository;

  PlaylistCubit(this.repository) : super(PlaylistInitial());

  void startLogin() => emit(PlaylistCodeRequired());

  Future<void> fetchTracks(String code) async {
    emit(PlaylistLoading());
    try {
      final tracks = await repository.fetchPlaylistTracks(code);
      emit(PlaylistLoaded(tracks));
    } catch (e) {
      emit(PlaylistError(e.toString()));
    }
  }
}
