import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'repository/playlist_repository.dart';
import 'cubit/playlist_cubit.dart';
import 'screens/playlist_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final repository = PlaylistRepository();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spotify Playlist App',
      home: BlocProvider(
        create: (_) => PlaylistCubit(repository),
        child: PlaylistScreen(),
      ),
    );
  }
}
