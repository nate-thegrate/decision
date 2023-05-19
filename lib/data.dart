import 'package:flutter/material.dart';

const Widget empty = SizedBox.shrink();

class Filler extends StatelessWidget {
  final int flex;
  const Filler([this.flex = 1, Key? key]) : super(key: key);

  @override
  Widget build(BuildContext context) => Expanded(flex: flex, child: empty);
}

class ContinueButton extends StatelessWidget {
  final String text;
  final void Function()? onPressed;
  const ContinueButton(this.text, {required this.onPressed, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => ElevatedButton(
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.only(top: 4, bottom: 8),
          child: Text(
            text,
            style: const TextStyle(fontSize: 20),
          ),
        ),
      );
}

class SexyCard extends StatelessWidget {
  final List<Widget> children;
  const SexyCard({required this.children, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: sexyWidth(context),
        child: Material(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          color: Colors.white,
          elevation: 5,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: children,
          ),
        ),
      ),
    );
  }
}

double sexyWidth(BuildContext context) {
  const double sizeThreshold = 300;
  final Size screenSize = MediaQuery.of(context).size;
  return screenSize.width > sizeThreshold
      ? sizeThreshold + (screenSize.width - sizeThreshold) * .5
      : screenSize.width;
}

Color sexyColor(BuildContext context) =>
    HSLColor.fromColor(Theme.of(context).primaryColor).withLightness(11 / 12).toColor();

Future<void> sleep(double seconds) =>
    Future.delayed(Duration(milliseconds: (seconds * 1000).toInt()));

class Voter {
  String name;
  List<String> ranking = [];

  Voter({required this.name, required this.ranking});
}

class ThinBorder extends BoxDecoration {
  const ThinBorder.bottom()
      : super(border: const Border(bottom: BorderSide(color: Colors.black12)));
  const ThinBorder.top() : super(border: const Border(top: BorderSide(color: Colors.black12)));
}

abstract class Data {
  static String noun = '', verb = '';

  static String get plural => noun.isEmpty
      ? ''
      : (['s', 'z', 'ch', 'sh', 'x'].any((ending) => Data.noun.endsWith(ending)) ? 'es' : 's');

  static int numberToElect = 0;

  static String get nouns => numberToElect == 1 ? noun : noun + plural;

  static List<String> candidates = [];

  static List<Voter> voters = [];

  static Map<String, int> tally = {};
}
