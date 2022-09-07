// Started with https://docs.flutter.dev/development/ui/widgets-intro
import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:to_dont_list/to_do_items.dart';

class ToDoList extends StatefulWidget {
  const ToDoList({super.key});

  @override
  State createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  // Dialog with text from https://www.appsdeveloperblog.com/alert-dialog-with-a-text-field-in-flutter/
  final TextEditingController _inputController = TextEditingController();
  final ButtonStyle yesStyle = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20), primary: Colors.green);
  final ButtonStyle noStyle = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20), primary: Colors.red);
  final ButtonStyle iStyle = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20), primary: Colors.blue);

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
                              _handleNewItem(valueText);
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
                      onPressed: valueText.isNotEmpty
                          ? () {
                              showDialog(
                                context: context,
                                builder: ((context) {
                                  return AlertDialog(
                                    title: const Text('Image Url'),
                                    content: TextField(
                                      onChanged: (value) {
                                        setState(() {
                                          vtext = value;
                                        });
                                      },
                                      controller: _inputController,
                                      decoration: const InputDecoration(
                                          hintText: "type something here"),
                                    ),
                                    actions: <Widget>[
                                      ValueListenableBuilder(
                                        valueListenable: _inputController,
                                        builder: (context, value, child) {
                                          return ElevatedButton(
                                              style: iStyle,
                                              key: const Key('Image URL'),
                                              onPressed: vtext.isNotEmpty
                                                  ? () {
                                                      _handleNewPic(vtext);
                                                      Navigator.pop(context);
                                                    }
                                                  : null,
                                              child: const Text('Select'));
                                        },
                                      )
                                    ],
                                  );
                                }),
                              );

                              //_handleNewItem(valueText);
                              //Navigator.pop(context);
                            }
                          : null,
                      child: const Text('Image'),
                    );
                  })
            ],
          );
        });
  }

  String valueText = "";
  String vtext = "";

  final List<Item> items = [const Item(name: "add more Images")];

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

  void _handleNewItem(String itemText) {
    setState(() {
      print("Adding new item");
      Item item = Item(name: itemText);
      items.insert(0, item);
      _inputController.clear();
    });
  }

  void _handleNewPic(String itemText) {
    setState(() {
      print("Adding new item");
      Picture pic = Picture(url: itemText);
      pic.insert(0, pic);
      _inputController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('To Do List'),
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
    title: 'To Do List',
    home: ToDoList(),
  ));
}
