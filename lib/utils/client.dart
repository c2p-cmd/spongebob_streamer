import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:beautiful_soup_dart/beautiful_soup.dart' as bs;

const spongebob = "https://www.megacartoons.net/truth-or-square/";
const batmanBeyond = "https://www.megacartoons.net/unmasked/";
const johnnyBravo = "https://www.megacartoons.net/johnny-bravo/";
const courageDog = "https://www.megacartoons.net/muted-muriel/";
const ben10 = "https://www.megacartoons.net/and-then-there-were-10/";
const ben10AlienForce = "https://www.megacartoons.net/vendetta/";
const ben10UltimateAlien = "https://www.megacartoons.net/moonstruck/";
const dexterLab = 'https://www.megacartoons.net/figure-not-included/';
const spiderman = 'https://www.megacartoons.net/final-curtain/';
const avengers = 'https://www.megacartoons.net/winter-soldier/';
const scoobyDo = 'https://www.megacartoons.net/scarebear/';
const samuraiJack = 'https://www.megacartoons.net/part-i-the-beginning/';
const dragonBallGt = 'https://www.megacartoons.net/universal-allies/';
const pokemon = 'https://animixplay.to/v1/pokemon-dub/ep2';
const pokemonXY = 'https://animixplay.to/v1/pokemon-xy-dub/ep4';
const pokemonXYZ = 'https://animixplay.to/v1/pokemon-xyz-dub/ep5';
const pokemonOrigin = 'https://animixplay.to/v1/pokemon-the-origin-dub';

const spongebobTitle = "SPONGEBOB SQUAREPANTS";
const batmanBeyondTitle = "BATMAN BEYOND";
const johnnyBravoTitle = "JOHNNY BRAVO";
const courageDogTitle = "COURAGE THE COWARDLY DOG";
const ben10Title = "BEN 10";
const ben10AlienForceTitle = "BEN 10 ALIEN FORCE";
const ben10UltimateAlienTitle = "BEN 10 ULTIMATE ALIEN";
const dexterLabTitle = "DEXTER'S LABORATORY";
const spiderManTitle = 'SPECTACULAR SPIDER MAN';
const avengersTitle = 'AVENGERS EARTH\'S MIGHTIEST HEROES';
const scoobyDooTitle = 'SCOOBY DOO';
const samuraiJackTitle = 'SAMURAI JACK';
const dragonBallGtTitle = 'DRAGON BALL GT';
const pokemonTitle = 'POKEMON!';
const pokemonXYTitle = 'POKEMON XY!';
const pokemonXYZTitle = 'POKEMON XYZ!';
const pokemonOriginTitle = 'POKEMON ORIGIN!';

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}


class Episode {
  final int episodeNo;
  final String episodeName;
  final String episodeLinkString;

  Episode(
      {required this.episodeNo,
      required this.episodeName,
      required this.episodeLinkString});

  @override
  String toString() {
    return "Episode No. -> $episodeNo\nEpisode Name -> $episodeName\nEpisode Link -> $episodeLinkString\n";
  }
}

void fetchEps() async {
  const link = 'https://animixplay.to/v1/pokemon-dub/ep2';
  final uri = Uri.parse(link);
  final List<Episode> episodes = <Episode>[];

  final response = await http
      .get(uri, headers: {'content-type': 'text/html; charset=UTF-8'});

  final body = response.body;
  final soup = bs.BeautifulSoup(body);
  final episodeDiv = soup.findAll('div', id: 'epslistplace');

  // print(episodeDiv.length);

  final Map<String, dynamic> innerHtml = jsonDecode(episodeDiv.first.innerHtml);
  innerHtml.remove('eptotal');
  for (var entry in innerHtml.entries) {
    final key = int.parse(entry.key);
    final temp = entry.value.toString().split('&amp;title=');
    final epLink = 'http:${temp[0]}';
    final epName = temp[1].replaceAll('+%28Dub%29+', ' ').replaceAll('+', ' ');

    print(Episode(episodeNo: key, episodeName: epName, episodeLinkString: epLink));
    break;
  }

  // final newResponse = await http.get(Uri.parse('http://goload.pro/streaming.php?id=NzUwNzA='));
  // print(newResponse.body);

  // print(episodes.length);
}

void fetchDataFromLink() async {
  final epLink = Uri.parse('http://goload.pro/streaming.php?id=NzUzNDI=');
  final response = await http.get(epLink);
  final soup = bs.BeautifulSoup(response.body);

  print(soup.findAll('iframe'));
}

void main() {
  fetchEps();
}
