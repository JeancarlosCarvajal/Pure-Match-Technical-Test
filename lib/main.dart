import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:pure_match_technical_test/providers/movies_provider.dart';
import 'package:pure_match_technical_test/screens/home_screen.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider( create: ( _ ) => MoviesProvider(), lazy: false )
      ],
      child: const PureMatch(),
    )
  );
} 

class PureMatch extends StatelessWidget {
  const PureMatch({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pure Match Technical Test',
      home: const HomeScreen(),      
      theme: ThemeData().copyWith(
        colorScheme: ThemeData().colorScheme.copyWith(
          primary: const Color(0xFF96969D),
        ),
      ),
    );
  }
}