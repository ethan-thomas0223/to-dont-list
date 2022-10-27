//import 'dart:html';

import 'package:flutter/material.dart';

class Item {
  const Item({required this.name});

  final String name;

  String abbrev() {
    return name.substring(0, 1);
  }
}

class Car {
  const Car(
      {required this.makemodel,
      required this.package,
      required this.priceestimate});

  final String makemodel;
  final String package;
  final int priceestimate;

  String abbrev() {
    return makemodel.substring(0, 1);
  }
}

typedef ToDoListChangedCallback = Function(bool completed, Car cars);
typedef ToDoListRemovedCallback = Function(Car car);

class ToDoListItem extends StatelessWidget {
  ToDoListItem(
      {required this.completed,
      required this.onListChanged,
      required this.onDeleteItem,
      required this.cars})
      : super(key: ObjectKey(cars));

  final bool completed;
  final ToDoListChangedCallback onListChanged;
  final ToDoListRemovedCallback onDeleteItem;
  final Car cars;

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

  // _detailCounter(BuildContext)

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        onListChanged(completed, cars);
      },
      onLongPress: completed
          ? () {
              onDeleteItem(cars);
            }
          : null,
      leading: CircleAvatar(
        backgroundColor: _getColor(context),
        child: Text(cars.abbrev()),
      ),
      title: Text(
        cars.makemodel +
            ', ' +
            cars.package +
            ', ' +
            cars.priceestimate.toString(),
        style: _getTextStyle(context),
      ),
    );
  }
}
