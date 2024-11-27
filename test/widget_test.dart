/*import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chat/main.dart';

void main() {
  testWidgets('BottomNavigationBar item interaction test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    var chattersController;
    await tester.pumpWidget(MyApp(chattersController: chattersController, useMockData: true));

    // Verify that the Chats page is shown by default.
    expect(find.text('Chats'), findsOneWidget);
    expect(find.text('Chatters'), findsNothing);
    expect(find.text('Scenes'), findsNothing);
    expect(find.text('Settings'), findsNothing);

    // Tap the "Chatters" BottomNavigationBar item.
    await tester.tap(find.byIcon(Icons.group_outlined));
    await tester.pump();

    // Verify that the Chatters page is shown.
    expect(find.text('Chatters'), findsOneWidget);
    expect(find.text('Chats'), findsNothing);
    expect(find.text('Scenes'), findsNothing);
    expect(find.text('Settings'), findsNothing);

    // Tap the "Scenes" BottomNavigationBar item.
    await tester.tap(find.byIcon(Icons.event));
    await tester.pump();

    // Verify that the Scenes page is shown.
    expect(find.text('Scenes'), findsOneWidget);
    expect(find.text('Chatters'), findsNothing);
    expect(find.text('Chats'), findsNothing);
    expect(find.text('Settings'), findsNothing);

    // Tap the "Settings" BottomNavigationBar item.
    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pump();

    // Verify that the Settings page is shown.
    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('Chats'), findsNothing);
    expect(find.text('Chatters'), findsNothing);
    expect(find.text('Scenes'), findsNothing);
  });
}
*/