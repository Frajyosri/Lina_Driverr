part of 'user_bloc_bloc.dart';

abstract class UserBlocState {}

class UserBlocInitial extends UserBlocState {}

class SuccessUserListe extends UserBlocState {
  Map<String, dynamic> UserListe;
  SuccessUserListe(this.UserListe);
}
