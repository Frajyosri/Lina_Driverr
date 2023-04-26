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
    on<GetCommandeEvent>(_GetCommandeListe);
    on<GetCommandeDetailsEvent>(_GetCommandeDetails);
    on<UpdateCommandeStatEvent>(_UpdateCommandeStat);
  }

  FutureOr<void> _GetCommandeListe(
      GetCommandeEvent event, Emitter<CommandeState> emit) async {
    emit(Loading());
    List<Commande> Comande = await CommandeApi().GetCommandeApi();
    emit(SuccessCommandeListe(Comande));
  }

  FutureOr<void> _GetCommandeDetails(
      GetCommandeDetailsEvent event, Emitter<CommandeState> emit) async {
    emit(Loading());
    SharedPreferences pref = await SharedPreferences.getInstance();
    var code = pref.getString("code");
    List<CommandDetails> Details =
        await CommandeApi().GetCommandeDetails(code!);
    emit(SuccessCommandeDetails(Details));
  }

  FutureOr<void> _UpdateCommandeStat(
      UpdateCommandeStatEvent event, Emitter<CommandeState> emit) async {
    emit(Loading());
    await CommandeApi().UpdateCommandeLivrer();
    emit(SuccessCommandeUpdate());
  }
}
