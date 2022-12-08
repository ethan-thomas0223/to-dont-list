//import 'dart:html';
import 'dart:io';
import 'dart:ui';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class Item {
  const Item({required this.name, required this.url});

  final String name;
  final String url;

  String abbrev() {
    return name.substring(0, 1);
  }

  String gURL() {
    return url;
  }
}

typedef ToDoListChangedCallback = Function(Item item, bool completed);
typedef ToDoListRemovedCallback = Function(Item item);

class ToDoListItem extends StatelessWidget {
  ToDoListItem({
    required this.item,
    required this.completed,
    required this.onListChanged,
    required this.onDeleteItem,
  }) : super(key: ObjectKey(item));

  final Item item;
  final bool completed;
  final ToDoListChangedCallback onListChanged;
  final ToDoListRemovedCallback onDeleteItem;

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
      color: Colors.black,
      decoration: TextDecoration.lineThrough,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
        onTap: () {
          onListChanged(item, completed);
        },
        onLongPress: () {
          onDeleteItem(item);
        },
        leading: CircleAvatar(
          backgroundColor: _getColor(context),
          child: Text(item.abbrev()),
        ),
        title: Text(
          //item.abbrev(),
          item.name,
          style: _getTextStyle(context),
        ),
        trailing: Picture(url: item.url));
  }
}

class Picture extends StatelessWidget {
  Picture({required this.url});

  final String url;

  //final String url ='https://images.unsplash.com/photo-1532779952550-b8fc9200ed8c?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxleHBsb3JlLWZlZWR8M3x8fGVufDB8fHx8&w=1000&q=80';
  @override
  Widget build(BuildContext context) {
    if (url.contains('https')) {
      return Image.network(url);
    } else {
      return Image.file(File('to-dont-list\assets\2029165.jpg'));
    }

    //throw UnimplementedError();
  }

  void insert(int i, Picture pic) {}

  String gUrl() {
    if (url == null || url == '') {
      return 'https://www.wallpaperflare.com/laptop-backgrounds-nature-images-1920x1200-night-scenics-nature-wallpaper-qnllv';
      ;
    } else {
      return url;
    }
  }
}

class Pic {
  const Pic({required this.url});

  final String url;

  String getPic() {
    return url;
  }
}
