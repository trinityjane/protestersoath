import 'package:protestersoath/login/PhoneTextFormField.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:protestersoath/navigation/app_drawer/appdrawer_bloc.dart';
import 'package:protestersoath/navigation/app_drawer/appdrawer_event.dart';
import 'package:protestersoath/utils/sizing.dart';
import 'package:protestersoath/utils/stripCorrectPhone.dart';
import 'package:protestersoath/utils/validatePhoneNumber.dart';
import 'package:protestersoath/l10n/app_localizations.dart';

class NumberInputVerify extends StatefulWidget {
  @override
  _NumberInputVerify createState() => _NumberInputVerify();
}

class _NumberInputVerify extends State<NumberInputVerify> {
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _phoneTextController;
  late final FocusNode _focusNode;

  @override
  void initState() {
    _formKey = GlobalKey<FormState>();
    _phoneTextController = TextEditingController();
    _focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _phoneTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double fontLabelSize = screenWidth(context) < 400 ? 13 : 15;
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 1.0, left: 16.0, right: 16.0),
      child: Stack(
        children: <Widget>[
          Form(
            key: _formKey,
            child: PhoneTextFormField().getCustomEditTextArea(
              labelValue: AppLocalizations.of(context)!.enterVerifyPhoneTip,
              hintValue: '',
              controller: _phoneTextController,
              keyboardType: TextInputType.number,
              icon: Icons.phone,
              focusNode: _focusNode,
              fontLabelSize: fontLabelSize,
              validator: (value) => validatePhoneNumber(context, value ?? ''),
            ),
          ),
          Container(
            alignment: const Alignment(-.9, 0.6),
            child: IconButton(
              icon: const Icon(
                Icons.privacy_tip,
                color: Colors.black,
                size: 30,
              ),
              tooltip: AppLocalizations.of(context)!.privacy,
              onPressed: () => BlocProvider.of<AppDrawerBloc>(context)
                  .add(PrivacyPageEvent()),
            ),
          ),
          Container(
            alignment: const Alignment(0.0, 0.6),
            child: MaterialButton(
              elevation: 20.0,
              minWidth: 210,
              splashColor: Colors.grey[500],
              colorBrightness: Brightness.light,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  BlocProvider.of<AppDrawerBloc>(context).add(
                    VerifyProofOfOathEvent(
                      othersPhone: stripCorrectPhone(_phoneTextController.text),
                    ),
                  );
                }
              },
              color: Colors.grey[900],
              child: Text(
                AppLocalizations.of(context)!.verifyButton,
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
