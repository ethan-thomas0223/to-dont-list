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
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _urlController = TextEditingController();
  final ButtonStyle yesStyle = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20), backgroundColor: Colors.green);
  final ButtonStyle noStyle = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20), backgroundColor: Colors.red);
  final ButtonStyle iStyle = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20), backgroundColor: Colors.blue);

  late File image;

  Future<void> _displayTextInputDialog(BuildContext context) async {
    print("Loading Dialog");
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Image Description'),
            content: Column(children: <Widget>[
              TextField(
                onChanged: (value) {
                  setState(() {
                    descriptionText = value;
                  });
                },
                controller: _descriptionController,
                decoration:
                    const InputDecoration(label: Text("Type Description Here")),
              ),
              TextField(
                onChanged: (value) {
                  setState(() {
                    urlText = value;
                  });
                },
                controller: _urlController,
                decoration: const InputDecoration(label: Text("Type URL Here")),
              )
            ]),
            actions: <Widget>[
              ElevatedButton(
                key: const Key("CancelButton"),
                style: noStyle,
                child: const Text('Cancel'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                    _urlController.clear();
                    _descriptionController.clear();
                  });
                },
              ),

              // https://stackoverflow.com/questions/52468987/how-to-turn-disabled-button-into-enabled-button-depending-on-conditions
              ValueListenableBuilder<TextEditingValue>(
                valueListenable: _descriptionController,
                builder: (context, value, child) {
                  return ElevatedButton(
                    key: const Key("OKButton"),
                    style: yesStyle,
                    onPressed: value.text.isNotEmpty
                        ? () {
                            setState(() {
                              _handleNewItem(descriptionText, urlText);
                              Navigator.pop(context);
                            });
                          }
                        : null,
                    child: const Text('Ok'),
                  );
                },
              ),
            ],
          );
        });
  }

  String descriptionText = "";
  String urlText = "";

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
      _descriptionController.clear();
      _urlController.clear();
    });
  }

  void _handleNewPic(String itemText) {
    setState(() {
      print("Adding new item");
      Picture pic = Picture(url: itemText);
      //doesn't like this
      //items.insert(0, pic as Item);
      pic.insert(0, pic);
      _descriptionController.clear();
      _urlController.clear();
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
