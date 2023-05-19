import 'package:flutter/material.dart';
import 'package:ranked_choice_voting/data.dart';

class DetermineResults extends StatefulWidget {
  const DetermineResults({Key? key}) : super(key: key);

  @override
  State<DetermineResults> createState() => _DetermineResultsState();
}

class _DetermineResultsState extends State<DetermineResults> {
  String buttonText = 'Start the tally';
  List<Widget> content = [const Text('It\'s time to determine results!')];
  int progress = 0;

  void advance() {
    switch (++progress) {
      case 1:
        setState(() {
          buttonText = 'Next';
          content = [
            const Text('Here\'s everyone\'s first choice:'),
            const SizedBox(height: 30),
            SizedBox(
              height: MediaQuery.of(context).size.height / 4,
              child: ListView.builder(
                itemBuilder: (context, index) {
                  final voter = Data.voters[index];
                  return Row(
                    children: [
                      Expanded(child: Text(voter.name + ':', textAlign: TextAlign.right)),
                      const SizedBox(width: 30),
                      Expanded(child: Text(voter.ranking[0]), flex: 2),
                    ],
                  );
                },
                itemCount: Data.voters.length,
              ),
            ),
          ];
        });
        break;
      case 2:
        for (final candidate in Data.candidates) {
          Data.tally[candidate] = 0;
        }
        for (final voter in Data.voters) {
          final topChoice = voter.ranking[0];
          Data.tally[topChoice] = Data.tally[topChoice]! + 1;
        }
        setState(() => content += [
              const Filler(),
              const Text('So here\'s the tally so far:'),
              const SizedBox(height: 30),
              SizedBox(
                height: MediaQuery.of(context).size.height / 4,
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    final candidate = Data.candidates[index];
                    return Row(
                      children: [
                        Expanded(
                          child: Text(
                            Data.tally[candidate]!.toString(),
                            textAlign: TextAlign.right,
                          ),
                        ),
                        const SizedBox(width: 30),
                        Expanded(child: Text(candidate), flex: 2),
                      ],
                    );
                  },
                  itemCount: Data.candidates.length,
                ),
              ),
            ]);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    // content = [];
    // progress = 0;
    return Scaffold(
      body: Center(
          child: SizedBox(
        width: sexyWidth(context),
        child: Column(
          children: [
            const Filler(),
            ...content,
            const Filler(),
            ContinueButton(
              buttonText,
              onPressed: advance,
            ),
            const SizedBox(height: 30),
            const ContinueButton('Skip to results', onPressed: null),
            const Filler(),
          ],
        ),
      )),
    );
  }
}
