import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_patron_bloc/home/home_page.dart';
import 'package:login_patron_bloc/login/login_page.dart';
import 'package:login_patron_bloc/repository/repository.dart';
import 'package:login_patron_bloc/authentication/authentication.dart';
import 'package:login_patron_bloc/splash/splash_page.dart';
import 'package:login_patron_bloc/theme.dart';

class App extends StatelessWidget {
  const App({Key key, @required this.authenticationRepository})
      : assert(authenticationRepository != null),
        super(key: key);

  final AuthenticationRepository authenticationRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: authenticationRepository,
      child: BlocProvider(
        create: (_) => AuthenticationBloc(authenticationRepository: authenticationRepository),
        child: AppView(),
      ),
      );
  }
}

class AppView extends StatefulWidget {
  @override
  _AppViewState createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => _navigatorKey.currentState;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme,
      navigatorKey: _navigatorKey,
      builder: (context, child) {
        return BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) {
            switch (state.status) {
              case AuthenticationStatus.authenticated:
                _navigator.pushAndRemoveUntil<void> (
                  HomePage.route(),
                  (route) => false
                );
                break;
              case AuthenticationStatus.unaunthenticated:
                _navigator.pushAndRemoveUntil<void>(
                  LoginPage.route(),
                  (route) => false
                );
                break;
              default: break;
            }
        },
        child: child
        );
      },
      onGenerateRoute: (_) => SplashPage.route()
    );
  }
}
