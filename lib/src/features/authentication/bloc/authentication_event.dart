part of 'authentication_bloc.dart';

sealed class AuthenticationEvent {
  const AuthenticationEvent();

  const factory AuthenticationEvent.login({
    required final String name,
    required final String email,
    final String? surname,
  }) = _Authentication$LoginEvent;

  const factory AuthenticationEvent.logout() = _Authentication$LogoutEvent;
}

final class _Authentication$LoginEvent extends AuthenticationEvent {
  const _Authentication$LoginEvent({required this.name, required this.email, this.surname});

  final String name;
  final String email;
  final String? surname;
}

final class _Authentication$LogoutEvent extends AuthenticationEvent {
  const _Authentication$LogoutEvent();
}
