import 'package:flutter/material.dart';
// import 'package:chewie/chewie.dart';
import 'package:spongebob_streamer/utils/client.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;
import 'package:beautiful_soup_dart/beautiful_soup.dart' as bs;

class VideoPlayerScreen extends StatefulWidget {
  final Episode episodeToLoad;
  const VideoPlayerScreen({Key? key, required this.episodeToLoad})
      : super(key: key);

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  late VideoPlayer _player;
  late Future<void> _initPlayerFuture;
  String? episodeLinkString;
  bool _didPlayerInit = false;
  bool _hideBar = false;

  void _parseLink() async {
    final linkString = widget.episodeToLoad.episodeLinkString;
    final link = Uri.parse(linkString);

    final newRes = await http.get(link);
    if (newRes.statusCode != 200) {
      return;
    }

    final soup = bs.BeautifulSoup(newRes.body);
    episodeLinkString = soup.find("input", attrs: {"name":"main_video_url"})?.attributes['value'].toString();
    _controller =
         VideoPlayerController.network(episodeLinkString.toString());
    Future.delayed(const Duration(seconds: 1));
    _initPlayerFuture = _controller.initialize().then((_) => setState(() => _didPlayerInit = true));
    _player = VideoPlayer(_controller);
  }

  @override
  void initState() {
    super.initState();
    _parseLink();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: const Color.fromRGBO(58, 66, 86, 1.0),
        appBar: (!_hideBar) ? AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_rounded),
          ),
          centerTitle: true,
          elevation: 0.1,
          backgroundColor: const Color.fromRGBO(58, 66, 86, 1.0),
          title: Text(widget.episodeToLoad.episodeName),
        ) : null,
        body: FutureBuilder(
          future: (_didPlayerInit) ? _initPlayerFuture : null,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: _player,
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
        floatingActionButton: (_didPlayerInit) ? FloatingActionButton(
          onPressed: () {
            setState(() {
              if (_controller.value.isPlaying) {
                _controller.pause();
                _hideBar = true;
              } else {
                _controller.play();
                _hideBar = false;
              }
            });
          },
          child: Icon(
            _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
          ),
        ): null,
  );
}
