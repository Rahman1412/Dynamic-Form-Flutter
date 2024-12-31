import 'package:dynamic_form/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

class UpdateUser extends StatefulWidget{
  final int index;
  UpdateUser({required this.index});
  @override
  State<UpdateUser> createState () => _UpdateUser();
}

class _UpdateUser extends State<UpdateUser>{

  late User? user;
  late Box? userBox;
  final _formKey = GlobalKey<FormState>();
  late TextEditingController name,email;

  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return "Name is required";
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Email is required";
    } else if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
      return "Enter a valid email address";
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    name = TextEditingController();
    email = TextEditingController();
    userBox = Hive.box("users");
    user = User.fromJson(Map<String, dynamic>.from(userBox?.getAt(widget.index)));
    name.text = user!.name;
    email.text = user!.email;

  }

  void _update(){
    if(_formKey.currentState?.validate() ?? false){
      var user = User(name: name.text, email: email.text);
      userBox?.putAt(widget.index, user.toJson());
      setState(() {
        name.clear();
        email.clear();
      });
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update User"),
        centerTitle: true,
      ),
      body: Padding(
          padding: const EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: name,
                decoration: InputDecoration(labelText: "Name"),
                validator: validateName,
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: email,
                decoration: InputDecoration(labelText: "Email"),
                validator: validateEmail,
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
              SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _update,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0)
                      )
                    ),
                  child: Text("Update")
                ),
              )

            ],
          ),
        ),
      ),
    );
  }

}