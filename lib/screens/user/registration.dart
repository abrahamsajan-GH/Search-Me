import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:search_me/constants/constants.dart';
import 'package:search_me/screens/user/login_screen.dart';
import 'package:search_me/widgets/ad_plots.dart';

class Registration extends StatefulWidget {
  const Registration({super.key});

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  File? _image;
  bool _isLoading = false;

  void _selectImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future<String> _uploadImage(File imageFile) async {
    try {
      Uint8List? compressedImage = await FlutterImageCompress.compressWithFile(
        imageFile.absolute.path,
        quality: 50,
      );

      String imageName = DateTime.now().millisecondsSinceEpoch.toString();
      await firebase_storage.FirebaseStorage.instance
          .ref('images/$imageName.jpg')
          .putData(compressedImage!);

      String imageUrl = await firebase_storage.FirebaseStorage.instance
          .ref('images/$imageName.jpg')
          .getDownloadURL();

      return imageUrl;
    } catch (e) {
      log('Error uploading image: $e');
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const Text('Register with us!'),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Padding(padding: EdgeInsets.all(5)),
                  const Text(
                    'If you have already registered, please',
                    style: TextStyle(color: Colors.black),
                  ),
                  w5,
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const ScreenLogin()));
                      },
                      style: ButtonStyle(
                        minimumSize:
                            MaterialStateProperty.all(const Size(110, 35)),
                        backgroundColor: MaterialStateProperty.all(yellowClr),
                      ),
                      child: const Text(
                        'LOGIN',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, color: purpleClr),
                      )),
                ],
              ),
              h10,
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Center(
                  child: ClipRRect(
                    borderRadius: br8,
                    child: Container(
                      color: indigoClr.withOpacity(0.2),
                      width: size.width * 0.9,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(8, 8, 8, 29),
                        child: FormBuilder(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              FormBuilderTextField(
                                name: 'org_name',
                                decoration: const InputDecoration(
                                    labelText: 'Business/Org Name'),
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(),
                                ]),
                              ),
                              FormBuilderTextField(
                                name: 'location',
                                decoration: const InputDecoration(
                                    labelText: 'Location'),
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(),
                                ]),
                              ),
                              FormBuilderDropdown(
                                name: 'category',
                                decoration: const InputDecoration(
                                    labelText: 'Category'),
                                menuMaxHeight: 200,
                                borderRadius: BorderRadius.circular(12.0),
                                style: TextStyle(
                                  color: blackClr,
                                  fontSize: 16,
                                  fontFamily:
                                      GoogleFonts.montserrat().fontFamily,
                                ),
                                items: [
                                  'Restaurants',
                                  'Hospitals',
                                  'Schools',
                                  'Fuel Stations',
                                  'Movie Theatres',
                                  'Museums',
                                  'Football Turfs',
                                  'Workshops',
                                  'Bakery',
                                  'IT & Software'
                                ]
                                    .map((category) => DropdownMenuItem(
                                          value: category,
                                          child: Text(category),
                                        ))
                                    .toList(),
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(),
                                ]),
                              ),
                              h10,
                              Row(
                                children: [
                                  ElevatedButton(
                                    style: ButtonStyle(
                                        shape: MaterialStatePropertyAll(
                                            RoundedRectangleBorder(
                                                borderRadius: br6)),
                                        backgroundColor:
                                            const MaterialStatePropertyAll(
                                                bGreyClr)),
                                    onPressed: _selectImage,
                                    child: const Text(
                                      'Select Profile Image',
                                      style: TextStyle(
                                        color: whiteClr,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  w30,
                                  if (_image != null) ...[
                                    ClipRRect(
                                      borderRadius: br8,
                                      child: Image.file(
                                        _image!,
                                        height: 60,
                                        width: 60,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              FormBuilderTextField(
                                name: 'license_number',
                                decoration: const InputDecoration(
                                    labelText: 'License Number'),
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(),
                                ]),
                              ),
                              FormBuilderTextField(
                                name: 'website_url',
                                decoration: const InputDecoration(
                                    labelText: 'Website Address'),
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.url(),
                                ]),
                              ),
                              FormBuilderTextField(
                                name: 'contact_no',
                                decoration: const InputDecoration(
                                    labelText: 'Contact Number'),
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.integer(),
                                  FormBuilderValidators.required(),
                                ]),
                              ),
                              FormBuilderTextField(
                                name: 'email',
                                decoration:
                                    const InputDecoration(labelText: 'Email'),
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(),
                                  FormBuilderValidators.email(),
                                ]),
                              ),
                              FormBuilderTextField(
                                name: 'password',
                                decoration: const InputDecoration(
                                    labelText: 'Password'),
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(),
                                  FormBuilderValidators.minLength(6),
                                ]),
                                obscureText: true,
                              ),
                              h20,
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                            const MaterialStatePropertyAll(
                                                blueClr),
                                        shape: MaterialStatePropertyAll(
                                            RoundedRectangleBorder(
                                                borderRadius: br6)),
                                        padding: const MaterialStatePropertyAll(
                                            EdgeInsets.symmetric(
                                                vertical: 8.0,
                                                horizontal: 24.0))),
                                    onPressed: _isLoading
                                        ? null
                                        : () async {
                                            setState(() {
                                              _isLoading = true;
                                            });
                                            _formKey.currentState?.save();
                                            if (_formKey.currentState
                                                    ?.validate() ??
                                                false) {
                                              Map<String, dynamic> formData =
                                                  _formKey.currentState!.value;

                                              String? imageUrl;
                                              if (_image != null) {
                                                imageUrl =
                                                    await _uploadImage(_image!);
                                              }

                                              bool success = false;
                                              try {
                                                // String capitalize(
                                                //     String input) {
                                                //   if (input.isEmpty) {
                                                //     return '';
                                                //   }
                                                //   return input
                                                //           .substring(0, 1)
                                                //           .toUpperCase() +
                                                //       input
                                                //           .substring(1)
                                                //           .toLowerCase();
                                                // }

                                                await FirebaseFirestore.instance
                                                    .collection('reg_requests')
                                                    .add({
                                                  'org_name':
                                                      formData['org_name'],
                                                  'location':
                                                      formData['location'],
                                                  'category':
                                                      formData['category'],
                                                  'license_number': formData[
                                                      'license_number'],
                                                  'website_url':
                                                      formData['website_url'] ??
                                                          '',
                                                  'description': '',
                                                  'contact_no':
                                                      formData['contact_no'],
                                                  'email': formData['email'],
                                                  'password':
                                                      formData['password'],
                                                  'image_url': imageUrl,
                                                });

                                                success = true;
                                              } catch (e) {
                                                log('Error: $e');
                                              }

                                              if (success) {
                                                showDialog(
                                                  context:
                                                      _formKey.currentContext!,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title: const Text(
                                                        'Thank you for registering.',
                                                        style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      content: const Text(
                                                        'We will notify you via mail once your data is verified.\nThen you can login to your profile using your personal credentials.',
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                      actions: <Widget>[
                                                        IconButton(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            icon: const Icon(
                                                                Icons.check))
                                                      ],
                                                    );
                                                  },
                                                );
                                                _formKey.currentState?.reset();
                                              } else {
                                                ScaffoldMessenger.of(_formKey
                                                        .currentContext!)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                      content: Text(
                                                          'Registration Failed')),
                                                );
                                              }
                                            }
                                            setState(() {
                                              _isLoading = false;
                                            });
                                          },
                                    child: _isLoading
                                        ? const SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2.0,
                                              color: whiteClr,
                                            ),
                                          )
                                        : const Text(
                                            'Submit',
                                            style: TextStyle(
                                              color: whiteClr,
                                              fontSize: 16,
                                            ),
                                          ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                child: AdPlotSmall(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
