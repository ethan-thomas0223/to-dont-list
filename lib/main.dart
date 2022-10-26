// Started with https://docs.flutter.dev/development/ui/widgets-intro
import 'dart:ffi';
//import 'dart:html';
//import 'dart:html';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:to_dont_list/to_do_items.dart';

//https://educity.app/flutter/how-to-pick-an-image-from-gallery-and-display-it-in-flutter
import 'package:image_picker/image_picker.dart';

class ToDoList extends StatefulWidget {
  const ToDoList({super.key});

  @override
  State createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  // Dialog with text from https://www.appsdeveloperblog.com/alert-dialog-with-a-text-field-in-flutter/
  final TextEditingController _inputController = TextEditingController();
  final TextEditingController _inputController2 = TextEditingController();
  final ButtonStyle yesStyle = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20), primary: Colors.green);
  final ButtonStyle noStyle = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20), primary: Colors.red);
  final ButtonStyle iStyle = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20), primary: Colors.blue);

  late File image;

  Future<void> _displayTextInputDialog(BuildContext context) async {
    print("Loading Dialog");
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Image Description'),
            content: TextField(
              onChanged: (value) {
                setState(() {
                  valueText = value;
                });
              },
              controller: _inputController,
              decoration:
                  const InputDecoration(hintText: "type something here"),
            ),
            actions: <Widget>[
              ElevatedButton(
                key: const Key("CancelButton"),
                style: noStyle,
                child: const Text('Cancel'),
                onPressed: () {
                  setState(() {
                    //These 2 lines fail the test not sure why
                    //_handleNewItem(valueText);
                    Navigator.pop(context);
                    //Not sure why defaultRouteName works here, feels like the route should be specified
                    //Navigator.pushNamed(context, Navigator.defaultRouteName);
                  });
                },
              ),

              // https://stackoverflow.com/questions/52468987/how-to-turn-disabled-button-into-enabled-button-depending-on-conditions
              ValueListenableBuilder<TextEditingValue>(
                valueListenable: _inputController,
                builder: (context, value, child) {
                  return ElevatedButton(
                    key: const Key("OKButton"),
                    style: yesStyle,
                    onPressed: value.text.isNotEmpty
                        ? () {
                            setState(() {
                              _handleNewItem(valueText, vtext);
                              Navigator.pop(context);
                            });
                          }
                        : null,
                    child: const Text('Ok'),
                  );
                },
              ),
              ValueListenableBuilder(
                  valueListenable: _inputController,
                  builder: (context, value, child) {
                    return ElevatedButton(
                      style: iStyle,
                      key: const Key('imageButton'),
                      onPressed: //valueText.isNotEmpty
                          () {
                        showDialog(
                          context: context,
                          builder: ((context2) {
                            return AlertDialog(
                              title: const Text('Image Url'),
                              content: TextField(
                                onChanged: (value2) {
                                  setState(() {
                                    vtext = value2;
                                  });
                                },
                                controller: _inputController,
                                decoration: const InputDecoration(
                                    hintText: "type something here"),
                              ),
                              actions: <Widget>[
                                ValueListenableBuilder(
                                  valueListenable: _inputController2,
                                  builder: (context2, value2, child) {
                                    return ElevatedButton(
                                        style: iStyle,
                                        key: const Key('ImageURL'),
                                        onPressed: //vtext.isNotEmpty
                                            () {
                                          //_handleNewPic(vtext);
                                          Navigator.pop(context);
                                        },
                                        //: null,
                                        child: const Text('Select'));
                                  },
                                )
                              ],
                            );
                          }),
                        );

                        //_handleNewItem(valueText);
                        //Navigator.pop(context);
                      },
                      //: null,
                      child: const Text('Image'),
                    );
                  })
            ],
          );
        });
  }

  String valueText = "";
  String vtext = "";

  final List<Item> items = [
    Item(
        name: "add more Images",
        url:
            "https://c4.wallpaperflare.com/wallpaper/87/851/622/laptop-backgrounds-nature-images-1920x1200-wallpaper-thumb.jpg")
  ];

  final _itemSet = <Item>{};

  void _handleListChanged(Item item, bool completed) {
    setState(() {
      // When a user changes what's in the list, you need
      // to change _itemSet inside a setState call to
      // trigger a rebuild.
      // The framework then calls build, below,
      // which updates the visual appearance of the app.

      items.remove(item);
      if (!completed) {
        print("Completing");
        _itemSet.add(item);
        items.add(item);
      } else {
        print("Making Undone");
        _itemSet.remove(item);
        items.insert(0, item);
      }
    });
  }

  void _handleDeleteItem(Item item) {
    setState(() {
      print("Deleting item");
      items.remove(item);
    });
  }

  void _handleNewItem(String itemText, String itemUrl) {
    setState(() {
      print("Adding new item");

      Item item = Item(name: itemText, url: itemUrl);
      items.insert(0, item);
      _inputController.clear();
    });
  }

  void _handleNewPic(String itemText) {
    setState(() {
      print("Adding new item");
      Picture pic = Picture(url: itemText);
      //doesn't like this
      //items.insert(0, pic as Item);
      pic.insert(0, pic);
      _inputController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Image List'),
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          children: items.map((item) {
            return ToDoListItem(
              item: item,
              completed: _itemSet.contains(item),
              onListChanged: _handleListChanged,
              onDeleteItem: _handleDeleteItem,
            );
          }).toList(),
        ),
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              _displayTextInputDialog(context);
            }));
  }
}

void main() {
  runApp(const MaterialApp(
    title: 'Image List',
    home: ToDoList(),
  ));
}
