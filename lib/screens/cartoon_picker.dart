import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:spongebob_streamer/screens/home.dart';
import 'package:spongebob_streamer/utils/client.dart';
import 'package:flutter/services.dart';

const double iconSize = 12;

class CartoonCover {
  final String cartoonName, link, imageLink;
  CartoonCover(
      {required this.cartoonName, required this.link, required this.imageLink});
}

final _cartoonCovers = <CartoonCover>[
  CartoonCover(
      cartoonName: batmanBeyondTitle,
      link: batmanBeyond,
      imageLink: "assests/covers/batmanBeyond.png"
      // "https://i0.wp.com/batman-news.com/wp-content/uploads/2022/04/Batman-Beyond-Neo-Year-1-1-1.jpg?fit=1987%2C3056&quality=80&strip=info&ssl=1"
      ),
  CartoonCover(
      cartoonName: spongebobTitle,
      link: spongebob,
      imageLink: "assests/covers/spongebob.png"
      // "https://images.viacbs.tech/uri/mgid:arc:imageassetref:nick.com:9cd2df6e-63c7-43da-8bde-8d77af9169c7?quality=0.7"
      ),
  CartoonCover(
      cartoonName: courageDogTitle,
      link: courageDog,
      imageLink: "assests/covers/courage.png"
      // "https://m.media-amazon.com/images/M/MV5BMTU4MGEyNTItNzg5ZS00ZGU0LTk4NmEtODM0Y2UxYTY2YTUyXkEyXkFqcGdeQXVyNTAyODkwOQ@@._V1_FMjpg_UX1000_.jpg"
      ),
  CartoonCover(
      cartoonName: ben10Title,
      link: ben10,
      imageLink: "assests/covers/ben10.png"
      //"https://m.media-amazon.com/images/M/MV5BNDI5NjAxMWEtNGYyOS00MjIxLTg1Y2MtMjdiZTM3NWZlYjM5XkEyXkFqcGdeQXVyMTM0NTUzNDIy._V1_.jpg"
      ),
  CartoonCover(
      cartoonName: ben10AlienForceTitle,
      link: ben10AlienForce,
      imageLink: "assests/covers/ben10AlienForce.png"
      //"https://m.media-amazon.com/images/M/MV5BYmQwYTc1ZDEtMzU3My00OTIzLWE1YmEtYmUyMmMzZTI2ZWNlXkEyXkFqcGdeQXVyOTgwMzk1MTA@._V1_.jpg"
      ),
  CartoonCover(
      cartoonName: ben10UltimateAlienTitle,
      link: ben10UltimateAlien,
      imageLink: "assests/covers/ben10UltimateAlien.png"
      //"https://m.media-amazon.com/images/M/MV5BNzgxYjcwNDUtZTcxZS00NmIyLWI3OTAtNTQ3NzZjM2RkMTFkXkEyXkFqcGdeQXVyNjk1Njg5NTA@._V1_.jpg"
      ),
];

class CartoonPicker extends StatefulWidget {
  const CartoonPicker({Key? key}) : super(key: key);

  @override
  State<CartoonPicker> createState() => _CartoonPickerState();
}

class _CartoonPickerState extends State<CartoonPicker> {
  final _controller = CarouselController();
  var _current = 0;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(58, 66, 86, 1.0),
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.1,
        backgroundColor: const Color.fromRGBO(58, 66, 86, 1.0),
        title: const Text("CARTOON PICKER"),
      ),
      body: Builder(
        builder: (BuildContext context) {
          final double height = MediaQuery.of(context).size.height;
          final width = MediaQuery.of(context).size.width;
          return Column(
            children: [
              CarouselSlider(
                carouselController: _controller,
                options: CarouselOptions(
                  initialPage: _current,
                  height: height * 0.799,
                  viewportFraction: 0.9,
                  enlargeCenterPage: true,
                  autoPlay: true,
                  onPageChanged: (value, _) => setState(() => _current = value),
                ),
                items: _cartoonCovers
                    .map((item) => Column(
                          children: [
                            Image.asset(
                              item.imageLink,
                              fit: BoxFit.contain,
                              height: height * 0.6,
                              width: width * 0.9,
                            ),
                            // Image.network(
                            //   item.imageLink,
                            //   fit: BoxFit.contain,
                            //   height: height * 0.6,
                            //   width: width * 0.9,
                            // ),
                            const Padding(padding: EdgeInsets.only(top: 18.0)),
                            TextButton(
                              clipBehavior: Clip.hardEdge,
                              onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomePage(
                                            cartoonName: item.cartoonName,
                                            cartoonLink: item.link,
                                          ))),
                              style: TextButton.styleFrom(
                                  elevation: 0.05,
                                  primary: Colors.indigoAccent),
                              child: Text(
                                item.cartoonName,
                                style: const TextStyle(fontSize: 18),
                              ),
                            ),
                          ],
                        ))
                    .toList(),
              ),
              // Indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.min,
                children: _cartoonCovers
                    .asMap()
                    .entries
                    .map((cartoonCover) => SizedBox(
                          width: width * 0.075,
                          child: IconButton(
                              onPressed: () {
                                setState(() => _current = cartoonCover.key);
                                _controller.animateToPage(_current);
                              },
                              splashColor: Colors.blueGrey,
                              splashRadius: iconSize,
                              icon: (_current == cartoonCover.key)
                                  ? const Icon(
                                      Icons.circle,
                                      size: iconSize,
                                      color: Colors.white70,
                                    )
                                  : const Icon(
                                      Icons.circle_outlined,
                                      size: iconSize,
                                      color: Colors.white10,
                                    )),
                        ))
                    .toList(),
              )
            ],
          );
        },
      ),
    );
  }
}
