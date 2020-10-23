// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// The following tests are transformed from flutter/test/widgets/selectable_text_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_math/src/widgets/selectable.dart';
import 'package:flutter_math/src/widgets/selection/handle_overlay.dart';
import 'package:flutter_test/flutter_test.dart';

import '../load_fonts.dart';

void main() {
  setUpAll(loadKaTeXFonts);
  group('SelectableMath test', () {
    testWidgets('selection handles are rendered and not faded away',
        (WidgetTester tester) async {
      const testText = r'abcdef\frac{abc}{def}\sqrt[abc]{def}';
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: MathSelectable.tex(testText),
          ),
        ),
      );

      final state = tester.state<InternalSelectableMathState>(
          find.byType(InternalSelectableMath));

      // await tester.tapAt(const Offset(20, 10));
      state.selectWordAt(
          offset: const Offset(20, 10), cause: SelectionChangedCause.longPress);
      await tester.pumpAndSettle();

      final transitions = find
          .descendant(
            of: find.byWidgetPredicate(
                (Widget w) => w.runtimeType == MathSelectionHandleOverlay),
            matching: find.byType(FadeTransition),
          )
          .evaluate()
          .map((Element e) => e.widget)
          .cast<FadeTransition>()
          .toList();
      expect(transitions.length, 2);
      final left = transitions[0];
      final right = transitions[1];

      expect(left.opacity.value, equals(1.0));
      expect(right.opacity.value, equals(1.0));
    });

//   testWidgets('selection handles are rendered and not faded away', (WidgetTester tester) async {
//     const String testText = 'lorem ipsum';

//     await tester.pumpWidget(
//       const MaterialApp(
//         home: Material(
//           child: SelectableText(testText),
//         ),
//       ),
//     );

//     final RenderEditable renderEditable =
//         tester.state<EditableTextState>(find.byType(EditableText)).renderEditable;

//     await tester.tapAt(const Offset(20, 10));
//     renderEditable.selectWord(cause: SelectionChangedCause.longPress);
//     await tester.pumpAndSettle();

//     final List<Widget> transitions =
//     find.byType(FadeTransition).evaluate().map((Element e) => e.widget).toList();
//     expect(transitions.length, 2);
//     final FadeTransition left = transitions[0] as FadeTransition;
//     final FadeTransition right = transitions[1] as FadeTransition;

//     expect(left.opacity.value, equals(1.0));
//     expect(right.opacity.value, equals(1.0));
//   }, variant: const TargetPlatformVariant(<TargetPlatform>{ TargetPlatform.iOS,  TargetPlatform.macOS }));

//   testWidgets('Long press shows handles and toolbar', (WidgetTester tester) async {
//     await tester.pumpWidget(
//       const MaterialApp(
//         home: Material(
//           child: SelectableText('abc def ghi'),
//         ),
//       ),
//     );

//     // Long press at 'e' in 'def'.
//     final Offset ePos = textOffsetToPosition(tester, 5);
//     await tester.longPressAt(ePos);
//     await tester.pumpAndSettle();

//     final EditableTextState editableText = tester.state(find.byType(EditableText));
//     expect(editableText.selectionOverlay.handlesAreVisible, isTrue);
//     expect(editableText.selectionOverlay.toolbarIsVisible, isTrue);
//   });

//   testWidgets('Double tap shows handles and toolbar', (WidgetTester tester) async {
//     await tester.pumpWidget(
//       const MaterialApp(
//         home: Material(
//           child: SelectableText('abc def ghi'),
//         ),
//       ),
//     );

//     // Double tap at 'e' in 'def'.
//     final Offset ePos = textOffsetToPosition(tester, 5);
//     await tester.tapAt(ePos);
//     await tester.pump(const Duration(milliseconds: 50));
//     await tester.tapAt(ePos);
//     await tester.pump();

//     final EditableTextState editableText = tester.state(find.byType(EditableText));
//     expect(editableText.selectionOverlay.handlesAreVisible, isTrue);
//     expect(editableText.selectionOverlay.toolbarIsVisible, isTrue);
//   });

//   testWidgets(
//     'Mouse tap does not show handles nor toolbar',
//     (WidgetTester tester) async {
//       await tester.pumpWidget(
//         const MaterialApp(
//           home: Material(
//             child: SelectableText('abc def ghi'),
//           ),
//         ),
//       );

//       // Long press to trigger the selectable text.
//       final Offset ePos = textOffsetToPosition(tester, 5);
//       final TestGesture gesture = await tester.startGesture(
//         ePos,
//         pointer: 7,
//         kind: PointerDeviceKind.mouse,
//       );
//       addTearDown(gesture.removePointer);
//       await tester.pump();
//       await gesture.up();
//       await tester.pump();

//       final EditableTextState editableText = tester.state(find.byType(EditableText));
//       expect(editableText.selectionOverlay.toolbarIsVisible, isFalse);
//       expect(editableText.selectionOverlay.handlesAreVisible, isFalse);
//     },
//   );

//   testWidgets(
//     'Mouse long press does not show handles nor toolbar',
//     (WidgetTester tester) async {
//       await tester.pumpWidget(
//         const MaterialApp(
//           home: Material(
//             child: SelectableText('abc def ghi'),
//           ),
//         ),
//       );

//       // Long press to trigger the selectable text.
//       final Offset ePos = textOffsetToPosition(tester, 5);
//       final TestGesture gesture = await tester.startGesture(
//         ePos,
//         pointer: 7,
//         kind: PointerDeviceKind.mouse,
//       );
//       addTearDown(gesture.removePointer);
//       await tester.pump(const Duration(seconds: 2));
//       await gesture.up();
//       await tester.pump();

//       final EditableTextState editableText = tester.state(find.byType(EditableText));
//       expect(editableText.selectionOverlay.toolbarIsVisible, isFalse);
//       expect(editableText.selectionOverlay.handlesAreVisible, isFalse);
//     },
//   );

//   testWidgets(
//     'Mouse double tap does not show handles nor toolbar',
//     (WidgetTester tester) async {
//       await tester.pumpWidget(
//         const MaterialApp(
//           home: Material(
//             child: SelectableText('abc def ghi'),
//           ),
//         ),
//       );

//       // Double tap to trigger the selectable text.
//       final Offset selectableTextPos = tester.getCenter(find.byType(SelectableText));
//       final TestGesture gesture = await tester.startGesture(
//         selectableTextPos,
//         pointer: 7,
//         kind: PointerDeviceKind.mouse,
//       );
//       addTearDown(gesture.removePointer);
//       await tester.pump(const Duration(milliseconds: 50));
//       await gesture.up();
//       await tester.pump();
//       await gesture.down(selectableTextPos);
//       await tester.pump();
//       await gesture.up();
//       await tester.pump();

//       final EditableTextState editableText = tester.state(find.byType(EditableText));
//       expect(editableText.selectionOverlay.toolbarIsVisible, isFalse);
//       expect(editableText.selectionOverlay.handlesAreVisible, isFalse);
//     },
//   );

//   testWidgets('text span with tap gesture recognizer works in selectable rich text', (WidgetTester tester) async {
//     int spyTaps = 0;
//     final TapGestureRecognizer spyRecognizer = TapGestureRecognizer()
//       ..onTap = () {
//         spyTaps += 1;
//       };
//     await tester.pumpWidget(
//       MaterialApp(
//         home: Material(
//           child: Center(
//             child: SelectableText.rich(
//               TextSpan(
//                 children: <TextSpan>[
//                   const TextSpan(text: 'Atwater '),
//                   TextSpan(text: 'Peel', recognizer: spyRecognizer),
//                   const TextSpan(text: ' Sherbrooke Bonaventure'),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//     expect(spyTaps, 0);
//     final Offset selectableTextStart = tester.getTopLeft(find.byType(SelectableText));

//     await tester.tapAt(selectableTextStart + const Offset(150.0, 5.0));
//     expect(spyTaps, 1);

//     // Waits for a while to avoid double taps.
//     await tester.pump(const Duration(seconds: 1));

//     // Starts a long press.
//     final TestGesture gesture =
//       await tester.startGesture(selectableTextStart + const Offset(150.0, 5.0));
//     await tester.pump(const Duration(milliseconds: 500));
//     await gesture.up();
//     await tester.pump();
//     final EditableText editableTextWidget = tester.widget(find.byType(EditableText).first);

//     final TextEditingController controller = editableTextWidget.controller;
//     // Long press still triggers selection.
//     expect(
//       controller.selection,
//       const TextSelection(baseOffset: 8, extentOffset: 12),
//     );
//     // Long press does not trigger gesture recognizer.
//     expect(spyTaps, 1);
//   });

//   testWidgets('text span with long press gesture recognizer works in selectable rich text', (WidgetTester tester) async {
//     int spyLongPress = 0;
//     final LongPressGestureRecognizer spyRecognizer = LongPressGestureRecognizer()
//       ..onLongPress = () {
//         spyLongPress += 1;
//       };
//     await tester.pumpWidget(
//       MaterialApp(
//         home: Material(
//           child: Center(
//             child: SelectableText.rich(
//               TextSpan(
//                 children: <TextSpan>[
//                   const TextSpan(text: 'Atwater '),
//                   TextSpan(text: 'Peel', recognizer: spyRecognizer),
//                   const TextSpan(text: ' Sherbrooke Bonaventure'),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//     expect(spyLongPress, 0);
//     final Offset selectableTextStart = tester.getTopLeft(find.byType(SelectableText));

//     await tester.tapAt(selectableTextStart + const Offset(150.0, 5.0));
//     expect(spyLongPress, 0);

//     // Waits for a while to avoid double taps.
//     await tester.pump(const Duration(seconds: 1));

//     // Starts a long press.
//     final TestGesture gesture =
//     await tester.startGesture(selectableTextStart + const Offset(150.0, 5.0));
//     await tester.pump(const Duration(milliseconds: 500));
//     await gesture.up();
//     await tester.pump();
//     final EditableText editableTextWidget = tester.widget(find.byType(EditableText).first);

//     final TextEditingController controller = editableTextWidget.controller;
//     // Long press does not trigger selection if there is text span with long
//     // press recognizer.
//     expect(
//       controller.selection,
//       const TextSelection(baseOffset: 11, extentOffset: 11, affinity: TextAffinity.upstream),
//     );
//     // Long press triggers gesture recognizer.
//     expect(spyLongPress, 1);
//   });

//   testWidgets('SelectableText changes mouse cursor when hovered', (WidgetTester tester) async {
//     await tester.pumpWidget(
//       const MaterialApp(
//         home: Material(
//           child: Center(
//             child: SelectableText('test'),
//           ),
//         ),
//       ),
//     );

//     final TestGesture gesture = await tester.createGesture(kind: PointerDeviceKind.mouse, pointer: 1);
//     await gesture.addPointer(location: tester.getCenter(find.text('test')));
//     addTearDown(gesture.removePointer);

//     await tester.pump();

//     expect(RendererBinding.instance.mouseTracker.debugDeviceActiveCursor(1), SystemMouseCursors.text);
//   });

//   testWidgets('The handles show after pressing Select All', (WidgetTester tester) async {
//     await tester.pumpWidget(
//       const MaterialApp(
//         home: Material(
//           child: SelectableText('abc def ghi'),
//         ),
//       ),
//     );

//     // Long press at 'e' in 'def'.
//     final Offset ePos = textOffsetToPosition(tester, 5);
//     await tester.longPressAt(ePos);
//     await tester.pumpAndSettle();

//     expect(find.text('Select all'), findsOneWidget);
//     expect(find.text('Copy'), findsOneWidget);
//     expect(find.text('Paste'), findsNothing);
//     expect(find.text('Cut'), findsNothing);
//     EditableTextState editableText = tester.state(find.byType(EditableText));
//     expect(editableText.selectionOverlay.handlesAreVisible, isTrue);
//     expect(editableText.selectionOverlay.toolbarIsVisible, isTrue);

//     await tester.tap(find.text('Select all'));
//     await tester.pump();
//     expect(find.text('Copy'), findsOneWidget);
//     expect(find.text('Select all'), findsNothing);
//     expect(find.text('Paste'), findsNothing);
//     expect(find.text('Cut'), findsNothing);
//     editableText = tester.state(find.byType(EditableText));
//     expect(editableText.selectionOverlay.handlesAreVisible, isTrue);
//   },
//     variant: const TargetPlatformVariant(<TargetPlatform>{
//       TargetPlatform.android,
//       TargetPlatform.fuchsia,
//       TargetPlatform.linux,
//       TargetPlatform.windows,
//     }),
//   );

//   testWidgets('Does not show handles when updated from the web engine', (WidgetTester tester) async {
//     await tester.pumpWidget(
//       const MaterialApp(
//         home: Material(
//           child: SelectableText('abc def ghi'),
//         ),
//       ),
//     );

//     // Interact with the selectable text to establish the input connection.
//     final Offset topLeft = tester.getTopLeft(find.byType(EditableText));
//     final TestGesture gesture = await tester.startGesture(
//       topLeft + const Offset(0.0, 5.0),
//       kind: PointerDeviceKind.mouse,
//     );
//     addTearDown(gesture.removePointer);
//     await tester.pump(const Duration(milliseconds: 50));
//     await gesture.up();
//     await tester.pumpAndSettle();

//     final EditableTextState state = tester.state(find.byType(EditableText));
//     expect(state.selectionOverlay.handlesAreVisible, isFalse);
//     expect(
//       state.currentTextEditingValue.selection,
//       const TextSelection.collapsed(offset: 0),
//     );

//     if (kIsWeb) {
//       tester.testTextInput.updateEditingValue(const TextEditingValue(
//         selection: TextSelection(baseOffset: 2, extentOffset: 7),
//       ));
//       // Wait for all the `setState` calls to be flushed.
//       await tester.pumpAndSettle();
//       expect(
//         state.currentTextEditingValue.selection,
//         const TextSelection(baseOffset: 2, extentOffset: 7),
//       );
//       expect(state.selectionOverlay.handlesAreVisible, isFalse);
//     }
//   });

//   testWidgets('onSelectionChanged is called when selection changes', (WidgetTester tester) async {
//     int onSelectionChangedCallCount = 0;

//     await tester.pumpWidget(
//       MaterialApp(
//         home: Material(
//           child: SelectableText(
//             'abc def ghi',
//             onSelectionChanged: (TextSelection selection, SelectionChangedCause cause) {
//               onSelectionChangedCallCount += 1;
//             },
//           ),
//         ),
//       ),
//     );

//     // Long press to select 'abc'.
//     final Offset aLocation = textOffsetToPosition(tester, 1);
//     await tester.longPressAt(aLocation);
//     await tester.pump();
//     expect(onSelectionChangedCallCount, equals(1));

//     // Tap on 'Select all' option to select the whole text.
//     await tester.longPressAt(textOffsetToPosition(tester, 5));
//     await tester.pump();
//     await tester.tap(find.text('Select all'));
//     expect(onSelectionChangedCallCount, equals(2));
//   });
  });
}
