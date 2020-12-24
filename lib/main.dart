import 'dart:io';

import 'package:flutter/material.dart';

import 'Channel.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Image Picker'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  Channel channel = Channel();
  var image = '';

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: [
            Visibility(
              visible: image != '' ? true : false,
                child: Container(
                  width: double.infinity,
                  height: 400,
                  margin: EdgeInsets.all(10),
                  child: Image.file(
              File(image),
            ),
                )),
            InkWell(
              onTap: () async {
                if(Platform.isAndroid){
                  showBottomsheet();
                }else if(Platform.isIOS){
                  // final pickedImage = await channel.getImageFromCamera();
                }

              },
              child: Container(
                padding: EdgeInsets.all(20),
                color: Colors.blue,
                child: Text('Pick Image',style: TextStyle(color: Colors.white,fontSize: 20),),
              ),
            ),
          ],
        ),
      )// This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  showBottomsheet() async {
    var result = await showModalBottomSheet(context: context, builder: (BuildContext buildContext){
      return Wrap(
        children: <Widget>[
          Column(
            children: <Widget>[
              InkWell(
                child: Container(
                  padding: EdgeInsets.only(top: 20, left: 10,right: 10,bottom: 10),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(Icons.camera_alt, size: 25,color: Colors.black45,),
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text('Camera'),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pop(0);
                },
              ),
              InkWell(
                child: Container(
                  padding: EdgeInsets.only(top: 10, left: 10,right: 10,bottom: 20),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(Icons.image, size: 25,color: Colors.black45,),
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text('Gallery'),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pop(1);
                },
              ),
            ],
          ),
        ],
      );
    });

    if (result != null && result is int) {
      if (result == 0) {
        final pickedImage = await channel.getImageFromCamera();
        if(pickedImage != null)
        {
          setState(() {
            image = pickedImage;
          });
        }

      } else if (result == 1) {
        final pickedImage = await channel.getImageFromGallery();
        if(pickedImage != null)
        {
          setState(() {
            image = pickedImage;
          });
        }
      }
    }
  }
}
