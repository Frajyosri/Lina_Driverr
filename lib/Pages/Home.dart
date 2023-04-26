import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lina_driver/Pages/Comande.dart';
import 'package:lina_driver/bloc/commande_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CommandeBloc(),
      child: const Scaffold(extendBody: true, body: CommandPage()),
    );
  }
}
