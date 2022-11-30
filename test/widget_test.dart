// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:to_dont_list/main.dart';
import 'package:to_dont_list/to_do_items.dart';

void main() {
  test('Item abbreviation should be first letter', () {
    Item item = Item(name: "add more todos", catList: []);
    expect(item.abbrev(), "a");
  });

  // Yes, you really need the MaterialApp and Scaffold
  testWidgets('ToDoListItem has a text', (tester) async {
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: ToDoListItem(
                item: Item(name: "test", catList: []),
                completed: true,
                catList: [],
                onListChanged: (Item item, bool completed) {},
                onDeleteItem: (Item item) {}))));
    final textFinder = find.text('test');

    // Use the `findsOneWidget` matcher provided by flutter_test to verify
    // that the Text widgets appear exactly once in the widget tree.
    expect(textFinder, findsOneWidget);
  });

  testWidgets('ToDoListItem has a Circle Avatar', (tester) async {
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: ToDoListItem(
                item: Item(name: "test", catList: []),
                completed: true,
                catList: [],
                onListChanged: (Item item, bool completed) {},
                onDeleteItem: (Item item) {}))));
    final avatarFinder = find.byType(CircleAvatar);

    CircleAvatar circ = tester.firstWidget(avatarFinder);
    Icon? ctext = circ.child as Icon?;
    expect(circ.backgroundColor, Colors.black54);
  });

  testWidgets('Default ToDoList has one item', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: ToDoList()));

    final listItemFinder = find.byType(ToDoListItem);

    expect(listItemFinder, findsOneWidget);
  });

  testWidgets('Clicking and Typing adds item to ToDoList', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: ToDoList()));

    expect(find.byType(TextField), findsNothing);

    await tester.tap(find.byKey(const Key("TextInput")));
    await tester.pump(); // Pump after every action to rebuild the widgets
    expect(find.text("hi"), findsNothing);

    await tester.enterText(find.byType(TextField), 'hi');
    await tester.pump();
    expect(find.text("hi"), findsOneWidget);

    await tester.tap(find.byKey(const Key("OKButton")));
    await tester.pump();
    expect(find.text("hi"), findsOneWidget);

    final listItemFinder = find.byType(ToDoListItem);

    expect(listItemFinder, findsNWidgets(2));
  });

  testWidgets('Tapping and typing adds a cat to location item', (tester) async {
    // this tests the functionality of everything I added
    await tester.pumpWidget(const MaterialApp(home: ToDoList()));

    // could add a tester to add an item here, but I start with an item already in there called "Brick Pit"

    //enters a cat with name 'cat name' to a list item
    await tester.tap(find.byType(ListTile));
    await tester.pump();
    await tester.enterText(find.byType(TextField), 'cat name');
    await tester.tap(find.byKey(const Key("OKButtonCat")));
    await tester.pump();

    // expects to find the name in a list item
    expect(find.text("cat name"), findsOneWidget);
  });

  test('catsString transforms catList into a comma-separated string', () {
    Item item =
        Item(name: "item name", catList: ['Ella', 'Oliver', 'Dustbunny']);
    expect(item.catsString(), "Ella, Oliver, Dustbunny");
  });
}
