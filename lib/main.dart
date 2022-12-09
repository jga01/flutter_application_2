import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Auth App',
      home: BlocProvider(
        create: (context) => AuthBloc(),
        child: LoginScreen(),
      ),
    );
  }
}

class LoginScreen extends StatelessWidget {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                hintText: 'Enter your email',
              ),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                hintText: 'Enter your password',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                BlocProvider.of<AuthBloc>(context).add(
                  LoginEvent(
                    email: _emailController.text,
                    password: _passwordController.text,
                  ),
                );
              },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}

class AuthBloc extends Bloc<LoginEvent, AuthState> {
  final _firebaseAuth = FirebaseAuth.instance;

  AuthBloc(super.initialState);

  @override
  AuthState get initialState => InitialAuthState();

  @override
  Stream<AuthState> mapEventToState(LoginEvent event) async* {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      yield AuthenticatedState();
    } catch (error) {
      yield AuthenticationErrorState(error: error.toString());
    }
  }
}

abstract class AuthState {}

class InitialAuthState extends AuthState {}

class AuthenticatedState extends AuthState {}

class AuthenticationErrorState extends AuthState {
  final String error;

  AuthenticationErrorState({required this.error});
}

class LoginEvent {
  final String email;
  final String password;

  LoginEvent({required this.email, required this.password});
}