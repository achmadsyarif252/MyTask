import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mytask/config/config.dart';

class HomeScreenn extends StatefulWidget {
  @override
  _HomeScreennState createState() => _HomeScreennState();
}

class _HomeScreennState extends State<HomeScreenn> {
  final TextEditingController _taskControler = TextEditingController();
  final Firestore _db = Firestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser user;
  @override
  void initState() {
    getUid();
    super.initState();
  }

  void getUid() async {
    FirebaseUser u = await _auth.currentUser();
    setState(() {
      user = u;
    });
  }

  showMenu() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.0),
                topRight: Radius.circular(16.0),
              ),
              color: Colors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                
                SizedBox(
                    height: (56 * 6).toDouble(),
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16.0),
                            topRight: Radius.circular(16.0),
                          ),
                          color: Colors.white,
                        ),
                        child: Stack(
                          alignment: Alignment(0, 0),
                          overflow: Overflow.visible,
                          children: <Widget>[
                            Positioned(
                              top: -36,
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50)),
                                    border: Border.all(
                                        color: Colors.green, width: 10)),
                                child: Center(
                                  child: ClipOval(
                                    child: Image.asset(
                                      "assets/logo.png",
                                      fit: BoxFit.cover,
                                      height: 36,
                                      width: 36,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              child: ListView(
                                physics: NeverScrollableScrollPhysics(),
                                children: <Widget>[
                                  ListTile(
                                    title: Text(
                                      "Complete Task",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    leading: Icon(
                                      Icons.error,
                                      color: Colors.black,
                                    ),
                                    onTap: () {},
                                  ),
                                  ListTile(
                                    title: Text(
                                      "Deleted Task",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    leading: Icon(
                                      Icons.mail_outline,
                                      color: Colors.black,
                                    ),
                                    onTap: () {},
                                  ),
                                ],
                              ),
                            )
                          ],
                        ))),
                
              ],
            ),
          );
        });
  }

  void _showDialogLogout() {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            content: Text('Are You Sure want to Log Out ?'),
            actions: <Widget>[
              RaisedButton(
                  child: Text('OK'),
                  color: Colors.blue,
                  textColor: Colors.white,
                  onPressed: () {
                    Navigator.pop(ctx);
                    _auth.signOut();
                  }),
              RaisedButton(
                  child: Text('Cancel'),
                  color: Colors.red,
                  textColor: Colors.white,
                  onPressed: () {
                    Navigator.pop(ctx);
                  }),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Container(
        margin: EdgeInsets.only(bottom: 10),
        child: FloatingActionButton(
          onPressed: () {
            _showAddTaskDialog();
          },
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          elevation: 4,
          backgroundColor: primaryColor,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {
                  showMenu();
                }),
            IconButton(
                icon: Icon(Icons.person_outline),
                onPressed: () {
                  _showDialogLogout();
                }),
          ],
        ),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            child: Container(
              margin: EdgeInsets.only(top: 40, left: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                      onPressed: () {}),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Text('Aktifitas',
                        style: TextStyle(color: Colors.white, fontSize: 20)),
                  ),
                  IconButton(
                      icon: Icon(Icons.notifications, color: Colors.white),
                      onPressed: () {}),
                ],
              ),
            ),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.5,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.green, Colors.greenAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight)),
          ),
          Container(
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.only(top: 20, left: 10, right: 10),
            margin: EdgeInsets.only(top: 100),
            decoration: BoxDecoration(
                color: Colors.white,
                // boxShadow: [
                //   BoxShadow(
                //     color: Colors.grey.withOpacity(0.5),
                //     spreadRadius: 5,
                //     blurRadius: 7,
                //     offset: Offset(0, 3),
                //   )
                // ],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                )),
            child: StreamBuilder(
              stream: _db
                  .collection("users")
                  .document(user.uid)
                  .collection("task")
                  .orderBy("date", descending: true)
                  .snapshots(),
              builder: (ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data.documents.isNotEmpty) {
                    return ListView(
                        children: snapshot.data.documents.map((snap) {
                      return Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: Card(
                          elevation: 10,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              leading: Icon(Icons.format_list_numbered),
                              title: Text(snap.data["task"]),
                              onTap: () {},
                              trailing: IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    _db
                                        .collection("users")
                                        .document(user.uid)
                                        .collection("task")
                                        .document(snap.documentID)
                                        .delete();
                                  }),
                            ),
                          ),
                        ),
                      );
                    }).toList());
                  } else {
                    return Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image(
                            image: AssetImage("assets/no_task.png"),
                          ),
                          Text('Ther is No Task',
                              style: TextStyle(fontSize: 15)),
                        ],
                      ),
                    );
                  }
                }
                return Container(
                  child: Center(
                    child: Image(
                      image: AssetImage("assets/no_task.png"),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showAddTaskDialog() {
    showDialog(
        context: context,
        builder: (ctx) {
          return SimpleDialog(
            title: Text('Add Task'),
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(10),
                child: TextField(
                  controller: _taskControler,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Your Task Here',
                    labelText: 'Task Name',
                  ),
                ),
              ),
              Container(
                child: Row(
                  children: <Widget>[
                    FlatButton(
                        onPressed: () {
                          Navigator.pop(ctx);
                        },
                        child: Text('Cancel')),
                    RaisedButton(
                      color: primaryColor,
                      onPressed: () async {
                        String task = _taskControler.text.trim();
                        final FirebaseUser user =
                            await FirebaseAuth.instance.currentUser();
                        _db
                            .collection("users")
                            .document(user.uid)
                            .collection("task")
                            .add({
                          "task": task,
                          "date": DateTime.now(),
                        });

                        Navigator.pop(ctx);
                      },
                      child: Text('Add'),
                    ),
                  ],
                ),
              ),
            ],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          );
        });
  }
}
