// cool thought s you have about your pet cat that you want to record into an app
// Started with https://docs.flutter.dev/development/ui/widgets-intro
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:to_dont_list/assets/thoughticon.dart';
import 'package:to_dont_list/to_do_items.dart';

import 'assets/icon.dart';
import 'assets/thoughticon.dart';

class ToDoList extends StatefulWidget {
  const ToDoList({super.key});

  @override
  State createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  // Dialog with text from https://www.appsdeveloperblog.com/alert-dialog-with-a-text-field-in-flutter/
  int _counter = 0;

  final TextEditingController _inputController = TextEditingController();
  final ButtonStyle yesStyle = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20), primary: Colors.green);
  final ButtonStyle noStyle = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20), primary: Colors.red);

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _decrementCounter() {
    setState(() {
      _counter--;
    });
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    print("Loading Dialog");
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Add a Location'),
            content: TextField(
              key: const Key("Thought Key"),
              maxLines:
                  4, // https://www.fluttercampus.com/guide/176/how-to-make-multi-line-textfield-input-textarea-in-flutter/#:~:text=How%20to%20Make%20Multi-line%20TextField%20in%20Flutter%3A%20TextField%28keyboardType%3A,line%20that%20looks%20exactly%20like%20textarea%20in%20HTML.
              onChanged: (value) {
                setState(() {
                  valueText = value;
                });
              },
              controller: _inputController,
              decoration: const InputDecoration(hintText: "type location here"),
            ),
            actions: <Widget>[
              ElevatedButton(
                key: const Key("OKButton"),
                style: yesStyle,
                onPressed: () {
                  setState(() {
                    _handleNewItem(valueText);
                    Navigator.pop(context);
                    //valueText = "";
                  });
                },
                child: const Text('Ok'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                    _inputController.clear();
                  });
                },
                style: noStyle,
                child: const Text('Cancel'),
              )
            ],
          );
        });
  }

  String valueText = "";

  //starts with one item in the list:  "Brick Pit"
  final List<Item> items = [
    Item(
        name: "Brick Pit",
        catList: [],
        imageP:
            "https://i.pinimg.com/564x/22/71/48/22714827862d17e1a1a78bd344bfc5fc.jpg")
  ];

  final _itemSet = <Item>{};

  //most of this is commented out from the original to-do list
  //if I want to remove an item or have a strikethrough, I could uncomment

  void _handleListChanged(Item item, bool completed) {
    setState(() {
      // When a user changes what's in the list, you need
      // to change _itemSet inside a setState call to
      // trigger a rebuild.
      // The framework then calls build, below,
      // which updates the visual appearance of the app.

      //items.remove(item);
      //if (!completed) {
      //  print("Completing");
      //  _itemSet.add(item);
      //  items.add(item);
      //} else {
      //  print("Making Undone");
      //  _itemSet.remove(item);
      //  items.insert(0, item);
      //}

      _displayCatInput(context, item);
    });
  }

  void _handleAddCat(Item item, String name) {
    item.catList.add(name);
    _inputController.clear();
  }

  //adds a cat to one item in the list
  //the list is displayed as a subtitle underneath the item
  Future<void> _displayCatInput(BuildContext context, Item item) async {
    print("Loading Cat Dialog");
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: const Text('Add a Cat'),
              content: TextField(
                onChanged: (value) {
                  setState(() {
                    valueText = value;
                  });
                },
                controller: _inputController,
                decoration:
                    const InputDecoration(hintText: "type cat name here"),
              ),
              //child: Image.asset('images/cat.png'),
              actions: <Widget>[
                ElevatedButton(
                  key: const Key("OKButtonCat"),
                  style: yesStyle,
                  onPressed: () {
                    setState(() {
                      //new cat added to an item on the list
                      _handleAddCat(item, valueText);
                      Navigator.pop(context);
                      //valueText = "";
                    });
                  },
                  child: const Text('Ok'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      Navigator.pop(context);
                      _inputController.clear();
                    });
                  },
                  style: noStyle,
                  child: const Text('Cancel'),
                )
              ]);
        });
  }

  void _handleDeleteItem(Item item) {
    setState(() {
      print("Deleting item");
      items.remove(item);
    });
  }

  //adding a new item to the list with an empty cat list
  void _handleNewItem(String itemText) {
    setState(() {
      print("Adding new item");
      Item item = Item(name: itemText, catList: [], imageP: newCatImage());
      items.insert(0, item);
      _inputController.clear();
    });
  }

  String newCatImage() {
    List<String> assets = [
      "https://i.pinimg.com/564x/22/71/48/22714827862d17e1a1a78bd344bfc5fc.jpg",
      "https://i.pinimg.com/564x/e1/9f/47/e19f4768a10c3f399fd5ba92fc4186eb.jpg",
      "https://i.pinimg.com/564x/78/69/72/786972cceb9f7bf266778a5775848b12.jpg",
      "https://i.pinimg.com/564x/08/94/bc/0894bcf8403d83d0ee3eb6292aba11b7.jpg",
      "https://i.pinimg.com/564x/1f/80/3a/1f803a87bfed8f5642d8c74444a137f4.jpg",
      "https://i.pinimg.com/564x/bb/57/1a/bb571ae2c97458708155956fa5f2801e.jpg",
      "https://i.pinimg.com/736x/7e/6a/6e/7e6a6edd9edea50c1273a6eb81d05ae9.jpg",
      "https://i.pinimg.com/564x/8c/4a/51/8c4a51e005629a084505649079b0a949.jpg",
      "https://i.pinimg.com/564x/e2/25/37/e2253703557b7e6477e32891be4c667e.jpg",
    ];
    assets.shuffle();
    print(assets[0]);
    return assets[0];
  }

  //creates a dictionary
  //loops through list of items and finds the list of cats in those items
  //loops through the cat list of each item
  //checks if cat in list is in dic, if so adds to counter else initializes in dic
  //loops through dic to find key with highest value
  //returns that key
  String getMostCommonCat() {
    Map<String, int> dic = {};
    for (int i = 0; i < items.length; i++) {
      //print(i);
      //print(items[i].catList);
      for (int j = 0; j < items[i].catList.length; j++) {
        //print(items[i].catList[j]);
        if (dic.keys.contains(items[i].catList[j]) == false) {
          dic[items[i].catList[j]] = 1;
          //print(dic);
        } else if (dic.entries.contains(items[i].catList[j])) {
          //print(dic);
          dic[items[i].catList[j]]! + 1;

          //dic.entries.contains(items[i].catList[j])
        }
      }
    }
    //print(dic);
    String mc = '';
    int max = 0;
    for (int i = 0; i < dic.length; i++) {
      if (dic.values.elementAt(i) > max) {
        mc = dic.entries.elementAt(i).key as String;
        max = dic.values.elementAt(i);
      }
    }
    return mc;
  }

  //build an alert dialouge with more cat info
  //the alert dialouge tells which cat has the most occurences in the list of cats
  //accessed through hamburger at top right of screen
  Future<void> _commonCat(BuildContext context) async {
    print("Loading Most Common Cat");
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Common Cat'),
            content: SizedBox(
              width: 100,
              height: 60,
              child: Text(getMostCommonCat()),
            ),
            actions: <Widget>[
              ElevatedButton(
                key: const Key("OKButton"),
                style: yesStyle,
                child: const Text('Leave'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Hendrix Cats'),
          backgroundColor: Colors.orange,
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          children: items.map((item) {
            return ToDoListItem(
              item: item,
              completed: _itemSet.contains(item),
              onListChanged: _handleListChanged,
              onDeleteItem: _handleDeleteItem,
              catList: [],
              //newCat: _newCat(),
            );
          }).toList(),
        ),
        //here is new button
        endDrawer: ElevatedButton(
          key: const Key("MostCommonKey"),
          child: const Text("Common Cat"),
          onPressed: () {
            _commonCat(context);
          },
        ),
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              _displayTextInputDialog(context);
            }));
  }
}

void main() {
  runApp(MaterialApp(
    title: 'Hendrix Cats',
    theme: ThemeData(
      brightness: Brightness.light,
    ),
    darkTheme: ThemeData(
      brightness: Brightness.dark,
    ),
    themeMode: ThemeMode.dark,
    home: ToDoList(),
  ));
}
