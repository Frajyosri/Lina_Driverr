import '../models/ComandeModel.dart';
import '../models/CommandeDtails.dart';
import 'package:equatable/equatable.dart';

abstract class CommandeState extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class CommandeInitial extends CommandeState {}

class SuccessCommandeListe extends CommandeState {
  List<Commande> commandeListe;
  SuccessCommandeListe(this.commandeListe);
  List<Object?> get props => [commandeListe];
}

class Loading extends CommandeState {}

class SuccessCommandeDetails extends CommandeState {
  List<CommandDetails> DetailsCommande;
  SuccessCommandeDetails(this.DetailsCommande);
}

class SuccessCommandeUpdate extends CommandeState {}
