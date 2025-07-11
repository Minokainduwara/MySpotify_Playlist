import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import '../cubit/playlist_cubit.dart';
import '../widgets/track_tile.dart';

class PlaylistScreen extends StatelessWidget {
  final TextEditingController codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PlaylistCubit>();

    return Scaffold(
      appBar: AppBar(title: Text('Spotify Playlist')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocBuilder<PlaylistCubit, PlaylistState>(
          builder: (context, state) {
            if (state is PlaylistInitial) {
              return Center(
                child: ElevatedButton(
                  onPressed: () async {
                    cubit.startLogin();

                    // 👉 Update these with your actual credentials
                    final clientId = '6f7a3b1b9e95487d84a2403426ac15a1';
                    final redirectUri = 'mymusicApp://callback';
                    final scopes = 'playlist-read-private playlist-read-collaborative';

                    final authUrl = Uri.https('accounts.spotify.com', '/authorize', {
                      'response_type': 'code',
                      'client_id': clientId,
                      'scope': scopes,
                      'redirect_uri': redirectUri,
                    });

                    if (await canLaunchUrl(authUrl)) {
                      await launchUrl(authUrl, mode: LaunchMode.externalApplication);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Could not launch Spotify login URL')),
                      );
                    }
                  },
                  child: Text('Login with Spotify'),
                ),
              );
            } else if (state is PlaylistCodeRequired) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Paste the "code" from Spotify redirect URL:',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: codeController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Authorization Code',
                    ),
                  ),
                  SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      final code = codeController.text.trim();
                      if (code.isNotEmpty) {
                        cubit.fetchTracks(code);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Please enter the code')),
                        );
                      }
                    },
                    child: Text('Fetch Playlist'),
                  )
                ],
              );
            } else if (state is PlaylistLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is PlaylistLoaded) {
              return ListView.builder(
                itemCount: state.tracks.length,
                itemBuilder: (context, index) =>
                    TrackTile(track: state.tracks[index]),
              );
            } else if (state is PlaylistError) {
              return Center(child: Text(state.message));
            }
            return SizedBox();
          },
        ),
      ),
    );
  }
}
