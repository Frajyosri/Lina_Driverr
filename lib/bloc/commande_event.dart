part of 'commande_bloc.dart';

abstract class CommandeEvent {}

class GetCommandeEvent extends CommandeEvent {}

class GetCommandeDetailsEvent extends CommandeEvent {
  GetCommandeDetailsEvent();
}

class UpdateCommandeStatEvent extends CommandeEvent {}
