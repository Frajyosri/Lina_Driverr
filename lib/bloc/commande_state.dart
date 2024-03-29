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
  @override
  List<Object?> get props => [commandeListe];
}

class Loading extends CommandeState {}

class SuccessCommandeDetails extends CommandeState {
  List<CommandDetails> detailsCommande;
  SuccessCommandeDetails(this.detailsCommande);
}

class SuccessCommandeUpdate extends CommandeState {}

class SuccessCommandeRefrech extends CommandeState {
  List<Commande> newcommandeListe;
  SuccessCommandeRefrech(this.newcommandeListe);
  @override
  List<Object?> get props => [newcommandeListe];
}

class VerfierCommande extends CommandeState {}
