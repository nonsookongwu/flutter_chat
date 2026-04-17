import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import "package:firebase_auth/firebase_auth.dart";
import 'package:flutter_chat/model/validation.dart';
import 'package:flutter_chat/screens/auth/user_image_picker.dart';

final _firebase = FirebaseAuth.instance;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isPasswordHiddden = true;
  bool isLogin = true;
  String _enteredEmail = "";
  String _enteredUserName = "";
  String _enteredPswd = "";
  File? selectedImage;
  bool isLoading = false;

  final validate = Validation();

  void _handleHidePassword() {
    setState(() {
      isPasswordHiddden = !isPasswordHiddden;
    });
  }

  void _handleAuthToggle() {
    setState(() {
      isLogin = !isLogin;
    });
  }

  

  void _handleGetImage(File image) {
    selectedImage = image;
  }

  void _handleFormSubmit() async {
    // print("ready for server image is $selectedImage");
    final isValid = _formKey.currentState!.validate();

    if (!isValid || (!isLogin && selectedImage == null)) {
      return;
    }
    _formKey.currentState!.save();
    try {
      setState(() {
        isLoading = true;
      });
      if (isLogin) {
        final userCredentials = await _firebase.signInWithEmailAndPassword(
          email: _enteredEmail,
          password: _enteredPswd,
        );

        // print(userCredentials);
      } else {
        final userCredentials = await _firebase.createUserWithEmailAndPassword(
          email: _enteredEmail,
          password: _enteredPswd,
        );
        final firebaseStorage = FirebaseStorage.instance
            .ref()
            .child("user-images")
            .child("${userCredentials.user!.uid}.jpg");
        await firebaseStorage.putFile(selectedImage!);
        final imageUrl = await firebaseStorage.getDownloadURL();
        // print(imageUrl);
        await FirebaseFirestore.instance
            .collection("users")
            .doc(userCredentials.user!.uid)
            .set({
              "userName": _enteredUserName,
              "email": _enteredEmail,
              "imageUrl": imageUrl,
            });

        await FirebaseAuth.instance.signOut();
        if (!mounted) return;
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Account has been created. Kindly log in"),
            duration: Duration(seconds: 5),
          ),
        );
      }
    } on FirebaseException catch (e) {
      // print("error code is ${e.code}");
      if (!mounted) return;
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? "Sign up Failed"),
          duration: Duration(seconds: 5),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            spacing: 30,
            children: [
              Image.asset("assets/images/chat.png", width: 200),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.all(16),
                width: double.infinity,
                // height: 200,
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 10,
                      children: [
                        if (!isLogin)
                          UserimagePicker(onGetImage: _handleGetImage),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: "Email Address",
                          ),
                          keyboardType: TextInputType.emailAddress,
                          autocorrect: false,
                          textCapitalization: TextCapitalization.none,
                          validator: Validation.validateEmail,
                          // validator: validateEmail,
                          onSaved: (newValue) => _enteredEmail = newValue!,
                        ),
                        SizedBox(height: 5),
                        if (!isLogin)
                          TextFormField(
                            decoration: InputDecoration(labelText: "User name"),
                            keyboardType: TextInputType.name,
                            autocorrect: false,
                            enableSuggestions: false,
                            textCapitalization: TextCapitalization.none,
                            validator: Validation.validateUserName,
                            onSaved: (newValue) => _enteredUserName = newValue!,
                          ),
                        if (!isLogin) SizedBox(height: 5),
                        TextFormField(
                          decoration: InputDecoration(
                            label: Text("Password"),
                            suffixIcon: IconButton(
                              onPressed: _handleHidePassword,
                              icon: Icon(
                                isPasswordHiddden
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                              ),
                            ),
                          ),
                          keyboardType: TextInputType.text,
                          autocorrect: false,
                          textCapitalization: TextCapitalization.none,
                          obscureText: isPasswordHiddden,
                          validator: Validation.validatePassword,
                          onSaved: (newValue) => _enteredPswd = newValue!,
                        ),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: _handleFormSubmit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.inversePrimary,
                          ),
                          child: isLoading
                              ? CircularProgressIndicator(
                                  constraints: BoxConstraints(
                                    minWidth: 20,
                                    minHeight: 20,
                                  ),
                                )
                              : Text(
                                  isLogin ? "Login" : "Sign up",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                        ),
                        TextButton(
                          onPressed: _handleAuthToggle,
                          child: Text(
                            isLogin
                                ? "Create an account"
                                : "Already have an account? Login",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
