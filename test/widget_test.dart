import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obo/main.dart';
void main(){
 testWidgets('Opens contact and sends emoji',(tester) async {
 await tester.pumpWidget(const OboApp());
 await tester.tap(find.text('Kişiler'));
 await tester.pumpAndSettle();
 await tester.tap(find.text('Zeynep'));
 await tester.pumpAndSettle();
 await tester.tap(find.byKey(const Key('emoji_0')));
 await tester.pumpAndSettle();
 expect(find.text('😀'),findsNWidgets(2));
 });
}
