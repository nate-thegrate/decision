import 'package:flutter/material.dart';
import 'package:ranked_choice_voting/data.dart';

class Vote extends StatefulWidget {
  const Vote({Key? key}) : super(key: key);

  @override
  State<Vote> createState() => _VoteState();
}

class _VoteState extends State<Vote> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Data.voters.isNotEmpty ? sexyColor(context) : null,
      body: Center(
          child: Column(
        children: [
          const Filler(),
          if (Data.voters.isNotEmpty)
            SexyCard(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  decoration: const ThinBorder.bottom(),
                  child: const Text(
                    'Voters so far',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  height: MediaQuery.of(context).size.height / 2,
                  child: SizedBox(
                    width: 250,
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(
                            Data.voters[index].name,
                          ),
                          trailing: IconButton(
                            onPressed: () => setState(() => Data.voters.removeAt(index)),
                            icon: const Icon(Icons.delete),
                          ),
                        );
                      },
                      itemCount: Data.voters.length,
                    ),
                  ),
                )
              ],
            )
          else
            const Text(
              'Time to vote!',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            ),
          const Filler(),
          if (Data.voters.length > 2) ...[
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor.withAlpha(128),
              ),
              onPressed: () async {
                await Navigator.pushNamed(context, 'add voter');
                setState(() => Data.voters);
              },
              child: const Padding(
                padding: EdgeInsets.only(top: 4, bottom: 8, left: 4, right: 4),
                child: Text(
                  'Add another voter',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: ContinueButton(
                'Ready!',
                onPressed: () => Navigator.pushReplacementNamed(context, 'determine results'),
              ),
            ),
          ] else
            ContinueButton(
              'Add a voter',
              onPressed: () async {
                await Navigator.pushNamed(context, 'add voter');
                setState(() => Data.voters);
              },
            ),
          const Filler(),
        ],
      )),
    );
  }
}
