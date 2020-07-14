import 'dart:io';

import 'package:flutter/material.dart';

import '../picker/picker.dart';

class AuthForm extends StatefulWidget {
  AuthForm(
    this._submitFn,
    this.isloading,
  );

  final void Function(
    String _email,
    String _userName,
    String _password,
    File image,
    bool _islogin,
    BuildContext ctx,
  ) _submitFn;

  final bool isloading;

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formkKey = GlobalKey<FormState>();
  var _isLogin = true;
  String _userEmail = "";
  String _userId = "";
  String _userPassword = "";
  File _image;

  void _pickedImage(File image) {
    _image = image;
  }

  _trySubmit() {
    final _valid = _formkKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (_image == null && !_isLogin) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('Please Select image!'),
        backgroundColor: Theme.of(context).errorColor,
      ));
      return;
    }

    if (_valid) {
      _formkKey.currentState.save();
      widget._submitFn(
        _userEmail.trim(),
        _userId.trim(),
        _userPassword.trim(),
        _image,
        _isLogin,
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
                key: _formkKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    if (!_isLogin) Picker(_pickedImage),
                    TextFormField(
                      key: ValueKey('email'),
                      validator: (value) {
                        if (value.isEmpty || !value.contains('@')) {
                          return 'Please enter valid email address';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _userEmail = value;
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(labelText: 'Email address'),
                    ),
                    if (!_isLogin)
                      TextFormField(
                        key: ValueKey('username'),
                        validator: (value) {
                          if (value.isEmpty || value.length < 4) {
                            return 'Please enter valid user name with 4 character';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _userId = value;
                        },
                        decoration: InputDecoration(labelText: 'User name'),
                      ),
                    TextFormField(
                      key: ValueKey('password'),
                      validator: (value) {
                        if (value.isEmpty || value.length < 7) {
                          return 'Please password atleat 7 charater';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _userPassword = value;
                      },
                      decoration: InputDecoration(labelText: 'Password'),
                      obscureText: true,
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    if (widget.isloading) CircularProgressIndicator(),
                    if (!widget.isloading)
                      RaisedButton(
                        child: Text(_isLogin ? 'Login' : 'Signup'),
                        onPressed: _trySubmit,
                      ),
                    if (!widget.isloading)
                      FlatButton(
                        textColor: Theme.of(context).primaryColor,
                        child: Text(_isLogin
                            ? 'Create new account'
                            : ' I already have account'),
                        onPressed: () {
                          setState(() {
                            _isLogin = !_isLogin;
                          });
                        },
                      )
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
