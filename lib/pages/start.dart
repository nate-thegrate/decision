import 'package:flutter/material.dart';
import 'package:ranked_choice_voting/data.dart';

class Start extends StatelessWidget {
  const Start({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Filler(5),
            const Text(
              'Ranked Choice',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
            ),
            const SizedBox(height: 10),
            const Text('The best way to vote.'),
            const Filler(),
            ContinueButton(
              'Begin',
              onPressed: () => Navigator.pushReplacementNamed(context, 'choose name'),
            ),
            const Filler(5),
          ],
        ),
      ),
    );
  }
}
