import 'package:flutter/material.dart';
import 'package:ranked_choice_voting/pages/start.dart';
import 'package:ranked_choice_voting/pages/choose_name.dart';
import 'package:ranked_choice_voting/pages/choose_candidates.dart';
import 'package:ranked_choice_voting/pages/voters.dart';
import 'package:ranked_choice_voting/pages/add_voter.dart';
import 'package:ranked_choice_voting/pages/determine_results.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Ranked Choice Voting',
        theme: ThemeData(
          colorSchemeSeed: const Color(0xFF6600cc),
          textTheme: const TextTheme(
            bodyMedium: TextStyle(fontSize: 18),
          ),
        ),
        initialRoute: 'start',
        routes: {
          'start': (context) => const Start(),
          'choose name': (context) => const ChooseName(),
          'choose candidates': (context) => const ChooseCandidates(),
          'vote': (context) => const Vote(),
          'add voter': (context) => const AddVoter(),
          'determine results': (context) => const DetermineResults(),
        },
      );
}
