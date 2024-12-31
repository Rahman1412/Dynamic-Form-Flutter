import 'package:dynamic_form/update_user.dart';
import 'package:dynamic_form/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

class UserList extends StatefulWidget {
  @override
  State<UserList> createState() => _UserList();
}

class _UserList extends State<UserList>{
  late Box usersBox;
  List users = [];

  @override
  void initState() {
    usersBox = Hive.box("users");
    getUsers();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print("Page revisited or dependencies changed.");
  }

  void getUsers() {
    var noteList = usersBox.values
        .map((data) => User.fromJson(Map<String, dynamic>.from(data)))
        .toList();
    setState(() {
      users = noteList;
    });
  }

  void _delete(int index) {
    setState(() {
      usersBox.deleteAt(index);
      users.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All Users"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Card(
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("index : ${index}"),
                                Text("Name : ${users[index].name}"),
                                Text("Email : ${users[index].email}")
                              ],
                            ),
                            Row(
                              children: [
                                IconButton(onPressed: (){
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => UpdateUser(index: index))
                                  );
                                }, icon: const Icon(Icons.edit)),
                                IconButton(
                                    onPressed: () => _delete(index),
                                    icon: const Icon(Icons.delete)
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                }),
          ),
          SizedBox(
            width: double.infinity,
            child: Padding(
                padding: EdgeInsets.all(10.0),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)
                        )
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Go Back")
                )
            ),
          )
        ],
      ),
    );
  }
}
