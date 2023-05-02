part of 'commande_bloc.dart';

abstract class CommandeEvent {}

class GetCommandeEvent extends CommandeEvent {}

class GetCommandeDetailsEvent extends CommandeEvent {}

class UpdateCommandeStatEvent extends CommandeEvent {}

class RefrechCommandeStatEvent extends CommandeEvent {}

class UpdateCommandeEvent extends CommandeEvent {}
