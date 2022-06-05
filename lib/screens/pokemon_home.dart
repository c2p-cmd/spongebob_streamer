import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spongebob_streamer/utils/client.dart';
import 'package:http/http.dart' as http;
import 'package:beautiful_soup_dart/beautiful_soup.dart' as bs;
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(const MaterialApp(
      home: PokemonHomePage(),
    ));

class PokemonHomePage extends StatefulWidget {
  final String name, link;
  const PokemonHomePage(
      {Key? key, this.name = pokemonTitle, this.link = pokemon})
      : super(key: key);

  @override
  State<PokemonHomePage> createState() => _PokemonHomePageState();
}

class _PokemonHomePageState extends State<PokemonHomePage> {
  final List<Widget> _fetchedEpisodes = <Widget>[];
  late String cartoonName;

  @override
  void initState() {
    super.initState();
    cartoonName = widget.name.replaceAll('!', '');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(58, 66, 86, 1.0),
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_rounded),
          ),
          centerTitle: true,
          elevation: 0.1,
          backgroundColor: const Color.fromRGBO(58, 66, 86, 1.0),
          title: Text(widget.name),
        ),
        body: Center(
          child: FutureBuilder(
            future: getAllEpisodes(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }

              if (snapshot.hasData) {
                final didComplete = snapshot.data;
                if (didComplete == null) {
                  return const Text("Something went has occurred.");
                }

                return makeBody(
                    _fetchedEpisodes.length,
                    Column(
                      children: _fetchedEpisodes,
                    ));
              }

              return const CircularProgressIndicator();
            },
          ),
        ));
  }

  Widget makeBody(int itemCount, Column episodes) => ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: false,
      itemCount: 1,
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

  Widget makeListTile(Episode episode) => Card(
        color: const Color.fromRGBO(64, 75, 96, .9),
        elevation: 1,
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          leading: Container(
            padding: const EdgeInsets.only(right: 12.0),
            decoration: const BoxDecoration(
                border: Border(
                    right: BorderSide(width: 1.0, color: Colors.white24))),
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
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
          subtitle: Row(
            children: const [
              Icon(
                Icons.tv_rounded,
                color: Colors.yellowAccent,
              ),
            ],
          ),
          trailing: IconButton(
            onPressed: () {
              // opening popup
              showGeneralDialog(
                  context: context,
                  pageBuilder: (ctx, a1, a2) => Container(),
                  transitionBuilder: (ctx, a1, a2, child) => Transform.scale(
                        scale: Curves.easeInOut.transform(a1.value),
                        child: confirmRedirect(Uri.parse(episode.episodeLinkString)),
                      ));
            },
            icon: const Icon(Icons.keyboard_arrow_right,
                color: Colors.white, size: 30.0),
          ),
        ),
      );


  Widget confirmRedirect(Uri uriLink) {
    return Dialog(
      backgroundColor: const Color.fromRGBO(58, 66, 86, 1.0),
      elevation: 5.0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0)),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          // Top Icon
          const Positioned(
              top: -60,
              child: CircleAvatar(
                backgroundColor: Color(0xFFFFC400),
                radius: 60,
                child: Icon(
                  Icons.tv_rounded,
                  color: Colors.white,
                  size: 69,
                ),
              )),

          // Box body
          SizedBox(
            height: 250,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 70, 10, 10),
              child: Column(
                children: [
                  const Text(
                    'To watch this you will be taken to your browser.',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const Text(
                    'Confirm this action please.',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // okay button
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            _launchUrl(uriLink);
                          },
                          style: ElevatedButton.styleFrom(
                            primary: const Color(0xFFFFC400),
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(69),
                            ),
                          ),
                          child: const Text(
                            'Okay',
                            style: TextStyle(color: Colors.black87),
                          ),
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          // child: Colors.redAccent,
                          style: ElevatedButton.styleFrom(
                            primary: const Color(0xFFFFC400),
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(69),
                            ),
                          ),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(color: Colors.black87),
                          ),
                        ),
                      ]),
                  const SizedBox(
                    width: 30,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _launchUrl(Uri url) async {
    if (!await launchUrl(url)) throw 'Could not launch $url';
  }

  Future<bool> getAllEpisodes() async {
    try {
      final uri = Uri.parse(widget.link);

      final response = await http.get(uri, headers: {
        'content-type': 'text/html; charset=UTF-8',
        'Charset': 'utf-8',
        "Access-Control-Allow-Headers": "Access-Control-Allow-Origin, Accept",
        "Access-Control_Allow_Origin": "*"
      });

      if (response.statusCode != 200) {
        return false;
      }

      final body = response.body;
      final soup = bs.BeautifulSoup(body);
      final episodeDiv = soup.findAll('div', id: 'epslistplace');

      final Map<String, dynamic> innerHtml =
          jsonDecode(episodeDiv.first.innerHtml);
      innerHtml.remove('eptotal');
      for (var entry in innerHtml.entries) {
        final key = int.parse(entry.key) + 1;
        final temp = entry.value.toString().split('&amp;title=');
        final epLink = 'http:${temp[0]}';
        final epName = '$cartoonName Episode $key';

        final episode = Episode(
            episodeNo: key, episodeName: epName, episodeLinkString: epLink);

        _fetchedEpisodes.add(makeListTile(episode));
      }

      return true;
    } on Exception catch (_) {
      rethrow;
    }
  }
}
