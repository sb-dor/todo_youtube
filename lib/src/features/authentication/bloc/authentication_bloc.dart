import 'package:bloc/bloc.dart';
import 'package:logger/logger.dart';
import 'package:todo_youtube/src/features/authentication/data/authentication_repository.dart';
import 'package:todo_youtube/src/features/authentication/model/user_model.dart';

part 'authentication_event.dart';

part 'authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({
    required final IAuthenticationRepository iAuthenticationRepository,
    required final Logger logger,
    AuthenticationState? initialState,
  }) : _iAuthenticationRepository = iAuthenticationRepository,
       _logger = logger,
       super(initialState ?? AuthenticationState.initial()) {
    //
    on<AuthenticationEvent>(
      (event, emit) => switch (event) {
        final _Authentication$LoginEvent event => _authentication$LoginEvent(event, emit),
        final _Authentication$LogoutEvent event => _authentication$LogoutEvent(event, emit),
      },
    );
  }

  final IAuthenticationRepository _iAuthenticationRepository;
  final Logger _logger;

  void _authentication$LoginEvent(
    _Authentication$LoginEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    try {
      emit(AuthenticationState.inProgress());

      final userModel = await _iAuthenticationRepository.login(
        name: event.name,
        email: event.email,
        surname: event.surname,
      );

      if (userModel != null) {
        emit(AuthenticationState.authenticated(userModel));
      } else {
        emit(AuthenticationState.initial());
      }
    } on Object catch (error, stackTrace) {
      emit(AuthenticationState.error());
      addError(error, stackTrace);
    }
  }

  void _authentication$LogoutEvent(
    _Authentication$LogoutEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    try {
      if (state is! Authentication$AuthenticatedState) return;

      final currentState = state as Authentication$AuthenticatedState;

      final logout = await _iAuthenticationRepository.logout(currentState.userModel.id);

      if (logout) {
        emit(AuthenticationState.initial());
      } else {
        emit(AuthenticationState.error());
      }
    } on Object catch (error, stackTrace) {
      emit(AuthenticationState.error());
      addError(error, stackTrace);
    }
  }
}
