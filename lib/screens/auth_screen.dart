import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:whats_app/widgets/user_image_picker.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({super.key});

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  File? imagePath;
  final form = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  String _userName ='';
  bool _ifLogin = true;
  bool _isLoading = false;
  bool _obscureText = true;
  void unFocus() {
    FocusScope.of(context).unfocus();
  }
  // && imagePath != null
  void _signUp() async {
    if (form.currentState!.validate() ) {
      form.currentState!.save();
      // set loading spinner
      setState(() {
        _isLoading = true;
      });
      try {
        if (_ifLogin) {
          final userCredentials = FirebaseAuth.instance
              .signInWithEmailAndPassword(email: _email, password: _password);
          setState(() {
            _isLoading = false;
          });
        } else {

          if (imagePath != null) {
            final userCredential = await FirebaseAuth.instance
                .createUserWithEmailAndPassword(
                email: _email, password: _password);
            final reference = FirebaseStorage.instance
                .ref()
                .child('user_images')
                .child('${userCredential.user!.uid}.jpg');

            await reference.putFile(imagePath!);

            final imageUrl = await reference.getDownloadURL();

            await FirebaseFirestore.instance
                .collection('users')
                .doc(userCredential.user!.uid)
                .set({
              'user_name':_userName,
              'email': _email,
              'image_url': imageUrl,
               'uid': userCredential.user!.uid
            });
            setState(() {
              _isLoading = false;
            });
          }
        }

        form.currentState!.reset();
        unFocus();
      } on FirebaseAuthException catch (error) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error.message ?? 'Authentication error')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/background_image.jpeg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  UserImagePicker(
                    selectedImage: (File image) {
                      setState(() {
                        imagePath = image;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Form(
                      key: form,
                      child: Column(
                        children: [
                          if(!_ifLogin)
                          SizedBox(

                            width: 320,
                            height: 60,
                            child: TextFormField(
                              textCapitalization: TextCapitalization.words,
                              keyboardType: TextInputType.name,
                              validator: (value) {
                                if (value == null ||
                                    value.trim().isEmpty ||
                                    value.trim().length < 3) {
                                  return 'Enter a valid name';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                setState(() {
                                  _userName = value!;
                                });
                              },
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.person),
                                prefixIconColor: Colors.white,

                                label: Text(
                                  'User Name',
                                  style: TextStyle(color: Colors.white),
                                ),
                                filled: true,
                                fillColor: Colors.teal,
                              ),

                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),

                          SizedBox(
                            width: 320,
                            height: 60,
                            child: TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null ||
                                    value.trim().isEmpty ||
                                    !value.contains('@')) {
                                  return 'Enter a valid name';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                setState(() {
                                  _email = value!;
                                });
                              },
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.email),
                                prefixIconColor: Colors.white,
                                label: Text(
                                  'Email address',
                                  style: TextStyle(color: Colors.white),
                                ),
                                filled: true,
                                fillColor: Colors.teal,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            width: 320,
                            height: 60,
                            child: TextFormField(
                              obscureText: true,
                              validator: (value) {
                                if (value == null ||
                                    value.trim().isEmpty ||
                                    value.trim().length < 6) {
                                  return 'Enter a strong password';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                setState(() {
                                  _password = value!;
                                });
                              },
                              decoration: InputDecoration(
                                label: const Text(
                                  'Password',
                                  style: TextStyle(color: Colors.white),
                                ),
                                prefixIcon:const Icon(Icons.password),
                                prefixIconColor: Colors.white,
                                filled: true,
                                fillColor: Colors.teal,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureText ? Icons.visibility_off : Icons.visibility,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscureText = !_obscureText;
                                    });
                                  },
                                ),
                              ),

                            ),
                          ),
                          Row(
                            children: [
                              const SizedBox(width: 100),
                              Checkbox(
                                value:
                                    _ifLogin, // Set the initial value of the Checkbox
                                onChanged: (bool? newValue) {
                                  setState(() {
                                    _ifLogin = newValue ?? false;
                                  });
                                },
                              ),
                              const Text(
                                'Already have an account ?',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          SizedBox(
                            width: 320,
                            height: 50,
                            child: TextButton(
                              onPressed: _signUp,
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.green),
                                shape:
                                    MaterialStateProperty.all<OutlinedBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              child: _isLoading ? const CircularProgressIndicator(): Text(
                                _ifLogin ? 'Login' : 'Sign up',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ))
                ],
              ),
            ),
          )),
    );
  }
}
