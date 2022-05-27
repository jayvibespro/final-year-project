import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalyearproject/models/user_model.dart';
import 'package:finalyearproject/services/auth_services.dart';
import 'package:finalyearproject/widgets/app_bar.dart';
import 'package:finalyearproject/widgets/drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  EditProfilePage({Key? key, required this.userData}) : super(key: key);

  UserModel userData;

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  bool isHover = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _facilityController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _professionController = TextEditingController();

  final FirebaseAuth auth = FirebaseAuth.instance;

  final _db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    const _tabletScreenWidth = 768;
    final _screenWidth = MediaQuery.of(context).size.width;

    _nameController.text = widget.userData.name;
    _emailController.text = widget.userData.email;
    _genderController.text = widget.userData.gender;
    _facilityController.text = widget.userData.facility;
    _idController.text = widget.userData.idNumber;
    _phoneController.text = widget.userData.phone;
    _locationController.text = widget.userData.region;
    _professionController.text = widget.userData.profession;
    return Scaffold(
      drawer: _screenWidth < _tabletScreenWidth ? const CustomDrawer(): const SizedBox(),
      appBar: BaseAppBar(
        appBar: AppBar(),
      ),
      backgroundColor: const Color(0xFFF2F3F4),
      body: Padding(
        padding: _screenWidth <= _tabletScreenWidth
            ? const EdgeInsets.symmetric(vertical: 0, horizontal: 0)
            : const EdgeInsets.symmetric(vertical: 0, horizontal: 300),
        child: Container(
          width: double.infinity,
          color: Colors.grey[50],
          child: ListView(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 16),
                child: Center(
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 70,
                    child: Icon(
                      Icons.person,
                      size: 60,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Center(
                  child: Text(
                    '${widget.userData.name}',
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              ),
              const Padding(
                padding:
                    EdgeInsets.only(top: 16, left: 64, right: 64, bottom: 8),
                child: Divider(),
              ),
              const Padding(
                padding:
                    EdgeInsets.only(top: 8, left: 64, right: 64, bottom: 8),
                child: Center(
                  child: Text(
                    'Edit user info',
                    style: TextStyle(color: Colors.black54),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 32),
                child: Container(
                  child: TextField(
                    controller: _nameController,
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(
                        hintText: 'Sarah Thomas',
                        label: Text('Name'),
                        border: InputBorder.none,
                        filled: true,
                        fillColor: Colors.transparent),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 32),
                child: Container(
                  child: TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                        hintText: '+255 694 059 986',
                        label: Text('Phone number'),
                        border: InputBorder.none,
                        filled: true,
                        fillColor: Colors.transparent),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 32),
                child: Container(
                  child: TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                        hintText: 'sarahthomas@gmail.com',
                        label: Text('Email'),
                        border: InputBorder.none,
                        filled: true,
                        fillColor: Colors.transparent),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 32),
                child: Container(
                  child: TextField(
                    controller: _idController,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                        hintText: '185*******123',
                        label: Text('ID number'),
                        border: InputBorder.none,
                        filled: true,
                        fillColor: Colors.transparent),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 32),
                child: Container(
                  child: TextField(
                    controller: _genderController,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                        hintText: 'Female',
                        label: Text('Gender'),
                        border: InputBorder.none,
                        filled: true,
                        fillColor: Colors.transparent),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 32),
                child: Container(
                  child: TextField(
                    controller: _professionController,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                        hintText: 'Nurse',
                        label: Text('Profession'),
                        border: InputBorder.none,
                        filled: true,
                        fillColor: Colors.transparent),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 32),
                child: Container(
                  child: TextField(
                    controller: _facilityController,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                        hintText: 'Mwananyamala hospital',
                        label: Text('Working facility'),
                        border: InputBorder.none,
                        filled: true,
                        fillColor: Colors.transparent),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 32),
                child: Container(
                  child: TextField(
                    controller: _locationController,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                        hintText: 'Dar Es Salaam',
                        label: Text('Region'),
                        border: InputBorder.none,
                        filled: true,
                        fillColor: Colors.transparent),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 16, left: 64, right: 64),
                child: Divider(),
              ),
              Padding(
                padding: const EdgeInsets.all(32),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          'Cancel',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      style: const ButtonStyle(),
                      onPressed: () {
                        AuthServices(
                          id: widget.userData.id,
                          name: _nameController.text,
                          email: _emailController.text,
                          gender: _genderController.text,
                          facility: _facilityController.text,
                          region: _locationController.text,
                          profession: _professionController.text,
                          phone: _phoneController.text,
                          idNumber: _idController.text,
                          avatarUrl: '',
                        ).editUserInfo();

                        setState(() {
                          _idController.clear();
                          _phoneController.clear();
                          _professionController.clear();
                          _locationController.clear();
                          _idController.clear();
                          _facilityController.clear();
                          _genderController.clear();
                          _nameController.clear();
                        });

                        Navigator.pop(context);
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text('Save changes'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 100,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
