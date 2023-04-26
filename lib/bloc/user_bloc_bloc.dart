import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:lina_driver/models/livreurModel.dart';
import 'package:lina_driver/services/UserApi.dart';
part 'user_bloc_event.dart';
part 'user_bloc_state.dart';

class UserBlocBloc extends Bloc<UserBlocEvent, UserBlocState> {
  UserBlocBloc() : super(UserBlocInitial()) {
    on<GetUserEvent>(_GetUserDetails);
  }

  FutureOr<void> _GetUserDetails(
      GetUserEvent event, Emitter<UserBlocState> emit) async {
    Map<String, dynamic> livreur = await UserApi().GetUserDetails();
    emit(SuccessUserListe(livreur));
  }
}
