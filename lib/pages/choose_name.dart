import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ranked_choice_voting/data.dart';

class SmallLabel extends StatelessWidget {
  final Widget child;
  final String label;
  final bool line;
  const SmallLabel(this.child, this.label, {this.line = true, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          child: child,
          decoration: line
              ? BoxDecoration(border: Border(bottom: BorderSide(color: primaryColor, width: 1)))
              : null,
        ),
        Text(
          label,
          style: TextStyle(color: primaryColor, fontSize: 12),
        ),
      ],
    );
  }
}

const Map<String, String> _hints = {
  'movie': 'watch',
  'dessert': 'make',
  'game': 'play',
  'restaurant': 'go to',
  'leader': 'elect',
};

enum _Page { activity, quantity }

class ChooseName extends StatefulWidget {
  const ChooseName({Key? key}) : super(key: key);

  @override
  State<ChooseName> createState() => _ChooseNameState();
}

class _ChooseNameState extends State<ChooseName> {
  String nounHint = '', verbHint = '';
  PageController controller = PageController();
  _Page _page = _Page.activity;

  bool cycling = false;
  void cycleHints() async {
    cycling = true;
    for (final hint in _hints.entries) {
      if (Data.noun.isNotEmpty || Data.verb.isNotEmpty) return;
      setState(() {
        nounHint = hint.key;
        verbHint = hint.value;
      });
      await sleep(3);
    }
    cycleHints();
  }

  void clearHints() {
    nounHint = '';
    verbHint = '';
  }

  bool get validInput {
    switch (_page) {
      case _Page.activity:
        return Data.noun.isNotEmpty && Data.verb.isNotEmpty;
      case _Page.quantity:
        return Data.numberToElect > 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    if (!cycling) cycleHints();

    return Scaffold(
      body: Column(
        children: [
          const Expanded(flex: 6, child: empty),
          SizedBox(
            height: 200,
            child: PageView(
              controller: controller,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('We\'re deciding which  '),
                        SmallLabel(
                          Text(Data.noun + (Data.noun.isNotEmpty ? '(${Data.plural})' : '')),
                          'noun',
                        ),
                        const Text('  to  '),
                        SmallLabel(Text(Data.verb), 'verb'),
                        const Text('.'),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: screenSize.width / 3),
                      child: SmallLabel(
                        TextField(
                          decoration: InputDecoration(hintText: nounHint),
                          autofillHints: _hints.values,
                          textAlign: TextAlign.center,
                          onChanged: (text) {
                            clearHints();
                            setState(() => Data.noun = text.trim());
                          },
                        ),
                        'noun',
                        line: false,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: screenSize.width / 3),
                      child: SmallLabel(
                        TextField(
                          decoration: InputDecoration(hintText: verbHint),
                          autofillHints: _hints.keys,
                          textAlign: TextAlign.center,
                          onChanged: (text) {
                            clearHints();
                            setState(() => Data.verb = text.trim());
                          },
                        ),
                        'verb',
                        line: false,
                      ),
                    )
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('We\'re gonna ${Data.verb}  '),
                        SmallLabel(
                          Text(Data.numberToElect.toString()),
                          'quantity',
                        ),
                        Text('  ${Data.nouns} in total.'),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: screenSize.width / 3),
                      child: SmallLabel(
                        TextField(
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          textAlign: TextAlign.center,
                          onChanged: (amt) {
                            clearHints();
                            if (amt.isEmpty) {
                              setState(() => Data.numberToElect = 0);
                            } else {
                              setState(() => Data.numberToElect = int.parse(amt));
                            }
                          },
                        ),
                        'quantity',
                        line: false,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Expanded(flex: 3, child: empty),
          ContinueButton(
            'Next',
            onPressed: validInput
                ? () {
                    switch (_page) {
                      case _Page.activity:
                        controller.animateToPage(
                          1,
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeOutCubic,
                        );
                        setState(() => _page = _Page.quantity);
                        break;
                      case _Page.quantity:
                        Navigator.pushReplacementNamed(context, 'choose candidates');
                        break;
                    }
                  }
                : null,
          ),
          const Expanded(flex: 6, child: empty),
        ],
      ),
    );
  }
}
