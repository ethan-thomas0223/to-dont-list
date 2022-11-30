//import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class Item {
  Item({required this.name, required this.catList, required this.imageP});

  final String name;
  String imageP;
  List<String> catList;

  String abbrev() {
    return name.substring(0, 1);
  }

  // transforms a List<String> into a useful String separated by commas
  String catsString() {
    if (catList.isEmpty) {
      return "";
    } else {
      return catList.join(', ');
    }
  }
}

typedef ToDoListChangedCallback = Function(Item item, bool completed);
typedef ToDoListRemovedCallback = Function(Item item);

class ToDoListItem extends StatelessWidget {
  ToDoListItem(
      {required this.item,
      required this.completed,
      required this.onListChanged,
      required this.onDeleteItem,
      required this.catList})
      : super(key: ObjectKey(item));

  final Item item;
  final bool completed;
  final ToDoListChangedCallback onListChanged;
  final ToDoListRemovedCallback onDeleteItem;
  final List<String> catList;

  Color _getColor(BuildContext context) {
    // The theme depends on the BuildContext because different
    // parts of the tree can have different themes.
    // The BuildContext indicates where the build is
    // taking place and therefore which theme to use.

    return completed //
        ? Colors.black54
        : Theme.of(context).primaryColor;
  }

  TextStyle? _getTextStyle(BuildContext context) {
    if (!completed) return null;

    return const TextStyle(
      color: Colors.black54,
      decoration: TextDecoration.lineThrough,
    );
  }

  // fun cat pictures I found on pinterest!
  // feel free to add more images

  @override
  Widget build(BuildContext context) {
    //assets.shuffle();
    //String imagePath = assets[0]; // initalize it as first image
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
          onTap: () {
            onListChanged(item, completed);
          },
          onLongPress: completed
              ? () {
                  onDeleteItem(item);
                }
              : null,
          //leading: CircleAvatar(
          //  backgroundColor: _getColor(context),
          //  child: Text(item.abbrev()),
          //),
          title: Text(
            item.name,
            style: _getTextStyle(context),
          ),
          trailing: CircleAvatar(
            backgroundImage: NetworkImage(item.imageP),
          ),
          // the list is displayed as a subtitle
          subtitle: Text(item.catsString())),
    );
  }
}
