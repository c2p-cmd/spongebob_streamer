import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spongebob_streamer/screens/video_screen.dart';
import 'package:spongebob_streamer/utils/client.dart';
import 'package:http/http.dart' as http;
import 'package:beautiful_soup_dart/beautiful_soup.dart' as bs;

class HomePage extends StatefulWidget {
  final String cartoonLink, cartoonName;
  const HomePage({Key? key, this.cartoonLink = spongebob, this.cartoonName = spongebobTitle}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Widget> _fetchedEpisodes = <Widget>[];

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations(
        <DeviceOrientation>[DeviceOrientation.portraitUp]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations(<DeviceOrientation>[
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight
    ]);
    super.dispose();
  }

  String? getLinkFrom(bs.BeautifulSoup soup) => soup
      .find("input", attrs: {"name": "main_video_url"})
      ?.attributes['value']
      .toString();

  Future<List<Episode>?> getAllEpisodes() async {
    try {
      final link = widget.cartoonLink;
      final uri = Uri.parse(link);
      final List<Episode> episodes = <Episode>[];
      final response = await http.get(uri, headers: {
        'content-type': 'text/html; charset=UTF-8',
        "Access-Control-Allow-Headers": "Access-Control-Allow-Origin, Accept"
      });

      if (response.statusCode != 200) {
        return null;
      }

      final body = response.body;
      final soup = bs.BeautifulSoup(body);
      final list = soup.findAll('a', class_: "btn btn-sm btn-default");

      for (var l in list) {
        final episodeNo = int.parse(l.text.replaceFirst(" ", ''));
        final name = l.attributes['title'].toString();
        final linkString = l.attributes['href'].toString();
        // final link = Uri.parse(linkString);

        episodes.add(Episode(
            episodeNo: episodeNo,
            episodeName: name,
            episodeLinkString: linkString));
      }

      return episodes;
    } on Exception catch (_) {
      // print(e);
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(58, 66, 86, 1.0),
        appBar: AppBar(
          centerTitle: true,
          elevation: 0.1,
          backgroundColor: const Color.fromRGBO(58, 66, 86, 1.0),
          title: Text(widget.cartoonName),
        ),
        body: Center(
          child: FutureBuilder(
            future: getAllEpisodes(),
            builder:
                (BuildContext context, AsyncSnapshot<List<Episode>?> snapshot) {
              if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }

              if (snapshot.hasData) {
                final episodes = snapshot.data;
                if (episodes == null) {
                  return const Text("Some error has occurred.");
                }

                for (var episode in episodes) {
                  final episodeWidget = makeListTile(episode);
                  _fetchedEpisodes.add(episodeWidget);
                }

                return makeBody(
                    _fetchedEpisodes.length,
                    Column(
                      children: _fetchedEpisodes,
                    ));
              }

              // if (!snapshot.hasData) {
              //   return const Text("Some error has occurred!!");
              // }

              return const CircularProgressIndicator();
            },
          ),
        ));
  }

  Widget makeBody(int itemCount, Column episodes) => ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: itemCount,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          elevation: 0.8,
          margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
          child: Container(
              decoration: const BoxDecoration(
                color: Color.fromRGBO(64, 75, 96, .9),
              ),
              child: episodes),
        );
      });

  ListTile makeListTile(Episode episode) => ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        leading: Container(
          padding: const EdgeInsets.only(right: 12.0),
          decoration: const BoxDecoration(
              border:
                  Border(right: BorderSide(width: 1.0, color: Colors.white24))),
          child: CircleAvatar(
            backgroundColor: const Color.fromRGBO(66, 133, 244, 1.0),
            child: Text(
              episode.episodeNo.toString(),
              style: const TextStyle(
                  color: Colors.black87, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        title: Text(
          episode.episodeName,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        subtitle: Row(
          children: const [
            Icon(
              Icons.linear_scale,
              color: Colors.yellowAccent,
            ),
          ],
        ),
        trailing: IconButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        VideoPlayerScreen(episodeToLoad: episode)));
          },
          icon: const Icon(Icons.keyboard_arrow_right,
              color: Colors.white, size: 30.0),
        ),
      );
}
