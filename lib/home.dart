import 'package:dynamic_form/user.dart';
import 'package:dynamic_form/user_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hive_flutter/adapters.dart';

class DynamicFormScreen extends StatefulWidget {
  @override
  State<DynamicFormScreen> createState() => _DynamicFormScreenState();
}

class _DynamicFormScreenState extends State<DynamicFormScreen> {

  final List<Map<String, TextEditingController>> _formFields = [];
  final _formKey = GlobalKey<FormState>();
  late Box usersBox;

  @override
  void initState() {
    usersBox = Hive.box("users");
    super.initState();
  }

  @override
  void dispose() {
    for (var field in _formFields) {
      field['name']?.dispose();
      field['email']?.dispose();
    }
    super.dispose();
  }

  void _addFormField() {
    setState(() {
      _formFields.add({
        'name': TextEditingController(),
        'email': TextEditingController(),
      });
    });
  }

  void _delete(int index){
    setState(() {
      _formFields[index]["name"]?.dispose();
      _formFields[index]["email"]?.dispose();
      _formFields.removeAt(index);
    });
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      for (var field in _formFields) {
        final name = field['name']?.text ?? '';
        final email = field['email']?.text ?? '';
        var user = User(name: name,email: email);
        usersBox.add(user.toJson());
      }
      setState(() {
        _formFields.clear();
      });
    }
  }

  // Validation Functions
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add User'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: _formFields.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Card(
                        elevation: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Form - ${index}",style: TextStyle(fontWeight: FontWeight.bold),),
                                  IconButton(onPressed: () => _delete(index), icon: Icon(Icons.delete))
                                ],
                              ),
                              TextFormField(
                                controller: _formFields[index]['name'],
                                decoration: InputDecoration(labelText: 'Name'),
                                validator: validateName,
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                              ),
                              SizedBox(height: 8),
                              TextFormField(
                                controller: _formFields[index]['email'],
                                decoration: InputDecoration(labelText: 'Email'),
                                validator: validateEmail,
                                autovalidateMode: AutovalidateMode.onUserInteraction
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: _addFormField,
                    child: Text('Add Users'),
                  ),
                  ElevatedButton(
                      onPressed: () async{
                        final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => UserList()));
                        if(result != null){
                          print("My Result ${result}");
                        }
                      },
                      child: Text("View Users")
                  ),
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: Text('Submit'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
