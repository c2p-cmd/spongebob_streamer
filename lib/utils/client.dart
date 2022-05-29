import 'package:http/http.dart' as http;
import 'package:beautiful_soup_dart/beautiful_soup.dart' as bs;

const spongebob = "https://www.megacartoons.net/truth-or-square/";
const batmanBeyond = "https://www.megacartoons.net/unmasked/";
const johnnyBravo = "https://www.megacartoons.net/run-johnny-run/";
const courageDog = "https://www.megacartoons.net/muted-muriel/";

const spongebobTitle = "SPONGEBOB SQUAREPANTS";
const batmanBeyondTitle = "BATMAN BEYOND";
const johnnyBravoTitle = "JOHNNY BRAVO";
const courageDogTitle = "COURAGE THE COWARDLY DOG";

class Episode {
  final int episodeNo;
  final String episodeName;
  final String episodeLinkString;

  Episode(
      {required this.episodeNo,
      required this.episodeName,
      required this.episodeLinkString});
}

void main() async {
  const link = "https://www.megacartoons.net/truth-or-square/";
  final uri = Uri.parse(link);
  final List<Episode> episodes = <Episode>[];

  final response = await http
      .get(uri, headers: {'content-type': 'text/html; charset=UTF-8'});

  final body = response.body;
  final soup = bs.BeautifulSoup(body);
  final list = soup.findAll('a', class_: "btn btn-sm btn-default");

  for (var l in list) {
    final episodeNo = int.parse(l.text.replaceFirst(" ", ''));
    final name = l.attributes['title'].toString();
    final linkString = l.attributes['href'].toString();
    final link = Uri.parse(linkString);

    final newRes = await http.get(link);
    if (response.statusCode != 200) {
      print("Bye");
      return;
    }

    final soup = bs.BeautifulSoup(newRes.body);
    final episodeLink = soup.find("input", attrs: {"name":"main_video_url"})?.attributes['value'].toString();
    // print(episodeLink);
    episodes.add(Episode(
        episodeNo: episodeNo,
        episodeName: name,
        episodeLinkString: episodeLink.toString()));
  }
}
