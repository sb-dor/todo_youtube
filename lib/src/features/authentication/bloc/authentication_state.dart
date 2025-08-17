part of 'authentication_bloc.dart';


sealed class AuthenticationState {
  const AuthenticationState();

  const factory AuthenticationState.initial() = Authentication$InitialState;

  const factory AuthenticationState.inProgress() = Authentication$InProgressState;

  const factory AuthenticationState.error() = Authentication$ErrorState;

  const factory AuthenticationState.authenticated(final UserModel user) =
      Authentication$AuthenticatedState;
}

final class Authentication$InitialState extends AuthenticationState {
  const Authentication$InitialState();
}

final class Authentication$InProgressState extends AuthenticationState {
  const Authentication$InProgressState();
}

final class Authentication$ErrorState extends AuthenticationState {
  const Authentication$ErrorState();
}

final class Authentication$AuthenticatedState extends AuthenticationState {
  const Authentication$AuthenticatedState(this.userModel);

  final UserModel userModel;
}
