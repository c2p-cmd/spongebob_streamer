import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

final Uri _url = Uri.parse('https://goload.pro/streaming.php?id=NzUzNDI=');
// https://goload.pro/streaming.php?id=NzUzNDI=

void main() => runApp(
  const MaterialApp(
    home: Material(
      child: Center(
        child: ElevatedButton(
          onPressed: _launchUrl,
          child: Text('Show Flutter homepage'),
        ),
      ),
    ),
  ),
);

void _launchUrl() async {
  if (!await launchUrl(_url)) throw 'Could not launch $_url';
}