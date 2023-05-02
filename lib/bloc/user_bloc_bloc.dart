import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:lina_driver/services/UserApi.dart';
part 'user_bloc_event.dart';
part 'user_bloc_state.dart';

class UserBlocBloc extends Bloc<UserBlocEvent, UserBlocState> {
  UserBlocBloc() : super(UserBlocInitial()) {
    on<GetUserEvent>(_getUserDetails);
    on<LoginUserEvent>(_loginUser);
  }

  FutureOr<void> _getUserDetails(
      GetUserEvent event, Emitter<UserBlocState> emit) async {
    Map<String, dynamic> livreur = await UserApi().getUserDetails();
    emit(SuccessUserListe(livreur));
  }

  FutureOr<void> _loginUser(
      LoginUserEvent event, Emitter<UserBlocState> emit) async {}
}
