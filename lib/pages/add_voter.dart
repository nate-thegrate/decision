import 'package:flutter/material.dart';
import 'package:ranked_choice_voting/data.dart';

class AddVoter extends StatefulWidget {
  const AddVoter({Key? key}) : super(key: key);

  @override
  State<AddVoter> createState() => _AddVoterState();
}

class _AddVoterState extends State<AddVoter> {
  String name = '';
  List<String> ranking = Data.candidates.toList();
  FocusNode focusNode = FocusNode();

  void reorder(oldIndex, newIndex) {
    if (newIndex > oldIndex) newIndex--;
    setState(() => ranking.insert(newIndex, ranking.removeAt(oldIndex)));
  }

  void Function() saveName(BuildContext context) {
    return () {
      Navigator.pop(context);
      setState(() => name = name);
    };
  }

  @override
  Widget build(BuildContext context) {
    if (name.isEmpty) {
      () async {
        await sleep(.5);
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) => StatefulBuilder(
            builder: (context, setState) => AlertDialog(
              title: const Text('Voter\'s name:'),
              content: TextField(
                focusNode: focusNode,
                textAlign: TextAlign.center,
                onChanged: (text) => setState(() => name = text.trim()),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Save'),
                  onPressed: name.isNotEmpty ? saveName(context) : null,
                ),
              ],
            ),
          ),
        );
        focusNode.requestFocus();
      }();
    }
    return Scaffold(
      backgroundColor: sexyColor(context),
      appBar: AppBar(
        title: name.isNotEmpty ? Text('$name\'s vote', textAlign: TextAlign.center) : empty,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () async {
            final bool? discard = await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                content: Text('This will discard $name\'s ranking. Continue?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Back'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('Continue'),
                  )
                ],
              ),
            );
            if (discard == true) Navigator.of(context).pop();
          },
        ),
      ),
      body: Column(
        children: [
          const Filler(2),
          SexyCard(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                decoration: const ThinBorder.bottom(),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Text('Rank the ${Data.noun + Data.plural} in your preferred order.'),
                  Text(
                    '(your favorite on top)',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 14,
                    ),
                  )
                ]),
              ),
              Container(
                height: MediaQuery.of(context).size.height / 2,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: ReorderableListView.builder(
                  itemBuilder: (context, index) => ListTile(
                    title: Text(ranking[index]),
                    key: Key(ranking[index]),
                  ),
                  itemCount: ranking.length,
                  onReorder: reorder,
                ),
              ),
            ],
          ),
          const Filler(),
          ContinueButton('Save', onPressed: () {
            Data.voters.add(Voter(
              name: name,
              ranking: ranking,
            ));
            Navigator.pop(context);
          }),
          const Filler(2),
        ],
      ),
    );
  }
}
