import 'package:e_commerce/screens/register_page.dart';
import 'package:e_commerce/widgets/custom_btn.dart';
import 'package:e_commerce/widgets/custom_input.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  Future<void> _alertDialogBuilder(String error) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text("Hata"),
            content: Container(
              child: Text(error),
            ),
            actions: [
              FlatButton(
                child: Text("Diyaloğu kapat"),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        }
    );
  }
  Future<String> _loginAccount() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _loginEmail, password: _loginPassword);
      return null;
    } on FirebaseAuthException catch(e) {
      if (e.code == 'Zayıf-şifre') {
        return 'Şifre zayıf';
      } else if (e.code == 'email-kullanıldı') {
        return 'Bu email için kayıtlı hesap zaten var';
      }
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  void _submitForm() async {
    setState(() {
      _loginFormLoading = true;
    });

    String _loginFeedback = await _loginAccount();

    if(_loginFeedback != null) {
      _alertDialogBuilder(_loginFeedback);

      setState(() {
        _loginFormLoading = false;
      });
    }
  }



  bool _loginFormLoading = false;

  String _loginEmail = "";
  String _loginPassword = "";

  FocusNode _passwordFocusNode;

  @override
  void initState() {
    _passwordFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Container(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
               Container(
                padding: EdgeInsets.only(
                  top: 24.0,
               ),
               child: Text(
                 "Hoşgeldin,\nHesabına Giriş Yap",
                  textAlign: TextAlign.center,
                  style: Constants.boldHeading,
               ),
            ),
                Column(
                  children: [
                    CustomInput(
                      hintText: "Email...",
                      onChanged: (value) {
                        _loginEmail = value;
                      },
                      onSubmitted: (value){
                        _passwordFocusNode.requestFocus();
                      },
                      textInputAction: TextInputAction.next,
                    ),
                    CustomInput(
                      hintText: "Şifre...",
                      onChanged: (value){
                        _loginPassword = value;
                      },
                      focusNode: _passwordFocusNode,
                      isPasswordField: true,
                      onSubmitted: (value) {
                        _submitForm();
                      },
                    ),
                    CustomBtn(
                      text: "Giriş Yap",
                      onPressed: (){
                        _submitForm();
                      },
                      isLoading: _loginFormLoading,
                    )
                  ],
                ),
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 16.0,
                ),
                child: CustomBtn(
                  text:"Yeni Hesap Oluştur",
                  onPressed: (){
                      Navigator.push(context,MaterialPageRoute(
                        builder: (context) => RegisterPage()
                      ),
                      );
                    },
                  outlineBtn: true,
                ),
              ),
            ],
          ),
         ),
      ),
    );
  }
}
