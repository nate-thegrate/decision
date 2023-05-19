import 'package:flutter/material.dart';
import 'package:ranked_choice_voting/data.dart';

class ChooseCandidates extends StatefulWidget {
  const ChooseCandidates({Key? key}) : super(key: key);

  @override
  State<ChooseCandidates> createState() => _ChooseCandidatesState();
}

class _ChooseCandidatesState extends State<ChooseCandidates> {
  String _currentCandidate = '';
  TextEditingController controller = TextEditingController();

  void reorder(oldIndex, newIndex) {
    if (newIndex > oldIndex) newIndex--;
    setState(() => Data.candidates.insert(newIndex, Data.candidates.removeAt(oldIndex)));
  }

  void Function() saveEdits(int index) => () {
        Navigator.of(context).pop();
        setState(() => Data.candidates[index] = _currentCandidate);
      };

  void Function()? get submitCandidate => _currentCandidate.isNotEmpty
      ? () {
          setState(() => Data.candidates.add(_currentCandidate));
          controller.clear();
        }
      : null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: sexyColor(context),
      body: Center(
        child: Column(
          children: [
            const Filler(2),
            SexyCard(children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(25),
                decoration: const ThinBorder.bottom(),
                child: Text(
                  'Let\'s list out all the ${Data.noun} candidates.',
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 15, right: 15),
                height: MediaQuery.of(context).size.height * .2,
                child: ReorderableListView.builder(
                  itemBuilder: (context, index) => ListTile(
                    title: Text(
                      Data.candidates[index],
                    ),
                    leading: IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => StatefulBuilder(
                            builder: (context, setState) => AlertDialog(
                              title: Text('Edit "${Data.candidates[index]}"'),
                              content: TextFormField(
                                initialValue: Data.candidates[index],
                                textAlign: TextAlign.center,
                                onChanged: (text) =>
                                    setState(() => _currentCandidate = text.trim()),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('Save'),
                                  onPressed: _currentCandidate.isNotEmpty ? saveEdits(index) : null,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.edit),
                    ),
                    trailing: Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: IconButton(
                        onPressed: () => setState(() => Data.candidates.removeAt(index)),
                        icon: const Icon(Icons.delete),
                      ),
                    ),
                    key: Key(Data.candidates[index]),
                  ),
                  itemCount: Data.candidates.length,
                  onReorder: reorder,
                ),
              ),
              Container(
                decoration: const ThinBorder.top(),
                padding: const EdgeInsets.only(
                  left: 30,
                  right: 20,
                  top: 10,
                  bottom: 10,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller,
                        textAlign: TextAlign.center,
                        onChanged: (text) {
                          setState(() => _currentCandidate = text.trim());
                        },
                        onSubmitted: (_) => submitCandidate,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: TextButton(
                        onPressed: submitCandidate,
                        child: const Padding(
                          padding: EdgeInsets.all(12),
                          child: Text('Add'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ]),
            const Filler(),
            ContinueButton(
              'Next',
              onPressed: (Data.candidates.length > 1)
                  ? () => Navigator.pushReplacementNamed(context, 'vote')
                  : null,
            ),
            const Filler(2),
          ],
        ),
      ),
    );
  }
}
