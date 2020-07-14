import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../widgets/auth/auth_form.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  var isLoading = false;

  void _submitForm(
    String _email,
    String _userName,
    String _password,
    File _image,
    bool _islogin,
    BuildContext ctx,
  ) async {
    final auth = FirebaseAuth.instance;
    AuthResult authResult;
    try {
      setState(() {
        isLoading = true;
      });
      if (_islogin) {
        authResult = await auth.signInWithEmailAndPassword(
            email: _email, password: _password);
      } else {
        authResult = await auth.createUserWithEmailAndPassword(
            email: _email, password: _password);
        final ref = FirebaseStorage.instance.ref().child('user_images').child(authResult.user.uid + '.jpg');   
        await ref.putFile(_image).onComplete; 
        final url = await ref.getDownloadURL();
        await Firestore.instance
            .collection('users')
            .document(authResult.user.uid)
            .setData({
          'userName': _userName,
          'email': _email,
          'image_url' : url,
        });
      }
    } on PlatformException catch (err) {
      var message = 'An error occurred, please check you credentials ';
      if (err != null) {
        message = err.message;
      }
      setState(() {
        isLoading = false;
      });
      Scaffold.of(ctx).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(ctx).errorColor,
        ),
      );
    } catch (err) {
      setState(() {
        isLoading = false;
      });
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(_submitForm, isLoading,),
    );
  }
}
