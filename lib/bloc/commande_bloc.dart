import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:lina_driver/models/ComandeModel.dart';
import 'package:lina_driver/models/CommandeDtails.dart';
import 'package:lina_driver/services/CommandeApi.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'commande_state.dart';

part 'commande_event.dart';

class CommandeBloc extends Bloc<CommandeEvent, CommandeState> {
  CommandeBloc() : super(CommandeInitial()) {
    on<GetCommandeEvent>(_getCommandeListe);
    on<GetCommandeDetailsEvent>(_getCommandeDetails);
    on<UpdateCommandeStatEvent>(_updateCommandeStat);
    on<RefrechCommandeStatEvent>(_refrechCommandeStat);
    on<UpdateCommandeEvent>(_updateCommande);
  }

  FutureOr<void> _getCommandeListe(
      GetCommandeEvent event, Emitter<CommandeState> emit) async {
    emit(Loading());
    List<Commande> comande = await CommandeApi().getCommandeApi();
    emit(SuccessCommandeListe(comande));
  }

  FutureOr<void> _getCommandeDetails(
      GetCommandeDetailsEvent event, Emitter<CommandeState> emit) async {
    var pref = await SharedPreferences.getInstance();
    var code = pref.getString("code");
    emit(Loading());
    List<CommandDetails> details =
        await CommandeApi().getCommandeDetails(code!);
    emit(SuccessCommandeDetails(details));
  }

  FutureOr<void> _updateCommandeStat(
      UpdateCommandeStatEvent event, Emitter<CommandeState> emit) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var code = pref.getString("code");
    emit(Loading());
    await CommandeApi().updateCommandeLivrer(code!);
    emit(SuccessCommandeUpdate());
  }

  FutureOr<void> _refrechCommandeStat(
      RefrechCommandeStatEvent event, Emitter<CommandeState> emit) async {
    List<Commande> newcomande = await CommandeApi().getCommandeApi();
    emit(SuccessCommandeRefrech(newcomande));
  }

  FutureOr<void> _updateCommande(
      UpdateCommandeEvent event, Emitter<CommandeState> emit) async {
    emit(VerfierCommande());
    emit(VerfierCommande());
    await Future.delayed(const Duration(seconds: 5));
    SharedPreferences pref = await SharedPreferences.getInstance();
    var codecmd = pref.getString("codecommandelivrer");
    await CommandeApi().updateCommande(codecmd!);
    emit(SuccessCommandeUpdate());
  }
}
