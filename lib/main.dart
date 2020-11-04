import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';

import 'SocketService.dart';
import 'app_initializer.dart';
import 'dependency_injection.dart';

Injector injector;

void main() async {
  DependencyInjection().initialise(Injector.getInjector());
  injector = Injector.getInjector();
  await AppInitializer().initialise(injector);
  runApp(MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // String URI = "http://192.168.88.252:3000/";
  final SocketService socketService = injector.get<SocketService>();
  TextEditingController name_controller = new TextEditingController();
  List msgList = [];
  List<String> litems = ["1", "2", "Third", "4"];

  @override
  void initState() {
    super.initState();
    products:
    List<String>.generate(500, (i) => "Product List: $i");
    socketService.createSocketConnection();
    socketService.socket.on('refresh feed', (data) {
      print('refressshh data : ' + data);
      setState(() {
        msgList.add(data);
      });

      print(msgList);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
          backgroundColor: Colors.white,
          body: Container(
            margin: EdgeInsets.only(top: 50, left: 20, right: 20),
            child: Stack(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 100),
                  child: ListView.builder(
                      itemCount: msgList.length,
                      itemBuilder: (BuildContext ctxt, int index) {
                        return new ListTile(
                          title: Text(msgList[index]),
                        );
                      }),
                ),
                Column(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 25, right: 25, top: 5),
                      child: TextField(
                        controller: name_controller,
                        keyboardType: TextInputType.multiline,
                        textCapitalization: TextCapitalization.sentences,
                        maxLines: null,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.black12,
                          hintText: "Enter Message",
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                    ),
                    RaisedButton(
                      onPressed: () {
                        socketService.socket
                            .emit('status added', name_controller.text);
                      },
                      child: Text('Send Message'),
                    )
                  ],
                )
              ],
            ),
          )),
    );
  }
}
