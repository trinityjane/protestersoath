import 'package:protestersoath/authentication/authentication.dart';
import 'package:protestersoath/oath/OathContainer.dart';
import 'package:protestersoath/login/bloc/login.dart';
import 'package:protestersoath/login/bloc/login_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:protestersoath/utils/onBackPressed.dart';
import './NumberInput.dart';
import './LoadingIndicator.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {

  @override
  void initState() {
    super.initState();
  }

  Future<bool> _onBackPressed() {
    return onBackPressed(context, true, null);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          await _onBackPressed();
        }
      },
      child: BlocListener<LoginBloc, LoginState>(
        listener: (context, loginState) {
          if (loginState is ExceptionState) {
            final message = loginState.message;
            final snackBar = SnackBar(
              content: SizedBox(
                height: 150,
                child: RichText(
                  text: TextSpan(
                    children: [
                      WidgetSpan(child: Icon(Icons.error)),
                      const TextSpan(text: "  "),
                      TextSpan(
                        text: message,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              backgroundColor: Colors.redAccent,
            );
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(snackBar);
          }
        },
        child: BlocBuilder<LoginBloc, LoginState>(
          builder: (context, state) {
            return LayoutBuilder(
              builder: (BuildContext context, BoxConstraints viewportConstraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: viewportConstraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              color: Colors.grey[100],
                              height: 1,
                              alignment: Alignment.center,
                              child: TheOath(true, viewportConstraints),
                            ),
                          ),
                          Container(
                            color: Colors.grey,
                            height: 170.0,
                            alignment: Alignment.center,
                            child: getViewAsPerState(context, state),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget getViewAsPerState(BuildContext context, LoginState state) {
    if (state is Unauthenticated) {
      return NumberInput();
    } else if (state is LoadingState) {
      return LoadingIndicator();
    } else if (state is LoginCompleteState) {
      BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn(
        token: state.getUser().phoneNumber,
      ));
      return LoadingIndicator();
    } else {
      return NumberInput();
    }
  }
}
