import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:search_me/constants/constants.dart';

class EditProfile extends StatelessWidget {
  final Map<String, dynamic> profileData;

  const EditProfile({super.key, required this.profileData});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormBuilderState>();
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: const Text('Edit Profile')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          child: FormBuilder(
            key: formKey,
            initialValue: {
              'image_url': profileData['image_url'],
              'org_name': profileData['org_name'],
              'location': profileData['location'],
              'category': profileData['category'] ?? '',
              'license_number': profileData['license_number'],
              'website_url': profileData['website_url'],
              'description': profileData['description'],
              'contact_no': profileData['contact_no'],
              'email': profileData['email'],
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FormBuilderTextField(
                  name: 'org_name',
                  decoration:
                      const InputDecoration(labelText: 'Business/Org Name'),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                  ]),
                ),
                FormBuilderTextField(
                  name: 'location',
                  decoration: const InputDecoration(labelText: 'Location'),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                  ]),
                ),
                FormBuilderDropdown(
                  name: 'category',
                  decoration: const InputDecoration(labelText: 'Category'),
                  menuMaxHeight: 200,
                  borderRadius: BorderRadius.circular(12.0),
                  style: TextStyle(
                    color: blackClr,
                    fontSize: 16,
                    fontFamily: GoogleFonts.montserrat().fontFamily,
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
                FormBuilderTextField(
                  name: 'license_number',
                  decoration:
                      const InputDecoration(labelText: 'License Number'),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                  ]),
                ),
                FormBuilderTextField(
                  name: 'website_url',
                  decoration:
                      const InputDecoration(labelText: 'Website Address'),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.url(),
                  ]),
                ),
                FormBuilderTextField(
                  maxLines: 3,
                  maxLength: 500,
                  keyboardType: TextInputType.multiline,
                  name: 'description',
                  decoration: const InputDecoration(labelText: 'Description'),
                  validator: FormBuilderValidators.compose([]),
                ),
                FormBuilderTextField(
                  name: 'contact_no',
                  decoration:
                      const InputDecoration(labelText: 'Contact Number'),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.integer(),
                    FormBuilderValidators.required(),
                  ]),
                ),
                FormBuilderTextField(
                  name: 'email',
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.email(),
                  ]),
                ),
                h20,
                ElevatedButton(
                  style: ButtonStyle(
                      foregroundColor: const MaterialStatePropertyAll(whiteClr),
                      backgroundColor: const MaterialStatePropertyAll(greenClr),
                      shape: MaterialStatePropertyAll(
                          RoundedRectangleBorder(borderRadius: br6))),
                  onPressed: () {
                    if (formKey.currentState!.saveAndValidate()) {
                      final formData = formKey.currentState!.value;

                      FirebaseFirestore.instance
                          .collection('approved_regs')
                          .doc(user!.uid)
                          .update({
                        'org_name': formData['org_name'],
                        'location': formData['location'],
                        'category': formData['category'],
                        'license_number': formData['license_number'],
                        'website_url': formData['website_url'],
                        'description': formData['description'],
                        'contact_no': formData['contact_no'],
                        'email': formData['email'],
                      }).then((_) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Profile updated successfully')));
                        Navigator.pop(context);
                      }).catchError((error) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Failed to update profile')));
                      });
                    }
                  },
                  child: const Text('UPDATE PROFILE'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
