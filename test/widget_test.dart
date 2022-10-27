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
    const cars = Car(makemodel: 'Nissan', package: '1', priceestimate: 150);
    expect(cars.abbrev(), "N");
  });

  // Yes, you really need the MaterialApp and Scaffold
  testWidgets('ToDoListItem has a text', (tester) async {
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: ToDoListItem(
                cars: const Car(
                    makemodel: 'test1', package: 'test2', priceestimate: 3),
                completed: true,
                onListChanged: (bool completed, Car car) {},
                onDeleteItem: (Car cars) {}))));
    final mmFinder = find.text("test1" + ", " + "test2" + ", " + '3');

    expect(mmFinder, findsWidgets);
  });

  testWidgets('ToDoListItem has a Circle Avatar with abbreviation',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: ToDoListItem(
                cars: const Car(
                    makemodel: 'test', package: 'test', priceestimate: 3),
                completed: true,
                onListChanged: (bool completed, Car car) {},
                onDeleteItem: (Car cars) {}))));
    final abbvFinder = find.text('t');
    final avatarFinder = find.byType(CircleAvatar);

    CircleAvatar circ = tester.firstWidget(avatarFinder);
    Text ctext = circ.child as Text;

    // Use the `findsOneWidget` matcher provided by flutter_test to verify
    // that the Text widgets appear exactly once in the widget tree.
    expect(abbvFinder, findsOneWidget);
    expect(circ.backgroundColor, Colors.black54);
    expect(ctext.data, "t");
  });

  testWidgets('Default ToDoList has one item', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: DetailList()));

    final listItemFinder = find.byType(ToDoListItem);

    expect(listItemFinder, findsOneWidget);
  });

  testWidgets('Clicking and Typing adds item to ToDoList', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: DetailList()));

    expect(find.byType(TextField), findsNothing);

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump(); // Pump after every action to rebuild the widgets
    expect(find.text("Nissan"), findsNothing);
    expect(find.text("2"), findsNothing);
    expect(find.text("100"), findsNothing);

    await tester.enterText(find.byKey(Key("MMKey")), 'Nissan');
    await tester.pump();
    expect(find.text("Nissan"), findsOneWidget);

    await tester.enterText(find.byKey(Key("PackKey")), '2');
    await tester.pump();
    expect(find.text("2"), findsOneWidget);

    await tester.enterText(find.byKey(Key("PEKey")), "100");
    await tester.pump();
    expect(find.text("100"), findsOneWidget);

    await tester.tap(find.byKey(const Key("OKButton")));
    await tester.pump();
    expect(find.text("Nissan" + ", " + "2" + ", " + '100'), findsWidgets);

    final listItemFinder = find.byType(ToDoListItem);

    expect(listItemFinder, findsNWidgets(2));
  });

  testWidgets("Testing functionality of the average button", (tester) async {
    await tester.pumpWidget(const MaterialApp(home: DetailList()));
    await tester.pump();

    await tester.tap(find.byKey(const Key("AverageKey")));
    await tester.pump();
    expect(find.byKey(const Key("AverageKey")), findsOneWidget);
  });

  // One to test the tap and press actions on the items?
}
