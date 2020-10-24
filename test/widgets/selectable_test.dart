// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// The following tests are transformed from flutter/test/widgets/selectable_text_test.dart

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_math/src/render/layout/line_editable.dart';
import 'package:flutter_math/src/widgets/selectable.dart';
import 'package:flutter_math/src/widgets/selection/handle_overlay.dart';
import 'package:flutter_test/flutter_test.dart';

import '../load_fonts.dart';

void main() {
  // Returns the first RenderEditable.
  RenderEditableLine findRenderEditableLine(WidgetTester tester) {
    final root = tester.renderObject(find.byType(InternalSelectableMath));
    expect(root, isNotNull);

    RenderEditableLine renderEditable;
    void recursiveFinder(RenderObject child) {
      if (child is RenderEditableLine) {
        renderEditable = child;
        return;
      }
      child.visitChildren(recursiveFinder);
    }

    root.visitChildren(recursiveFinder);
    expect(renderEditable, isNotNull);
    return renderEditable;
  }

  Offset textOffsetToCaretPosition(WidgetTester tester, int index) {
    final renderLine = findRenderEditableLine(tester);
    final endpoints = renderLine.getEndpointForCaretIndex(index);
    return endpoints + const Offset(0.0, -2.0);
  }

  setUpAll(loadKaTeXFonts);
  group('SelectableMath test', () {
    testWidgets('selection handles are rendered and not faded away',
        (WidgetTester tester) async {
      const testText = r'abcdef\frac{abc}{def}\sqrt[abc]{def}';
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: Center(
              child: MathSelectable.tex(testText),
            ),
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

    testWidgets('selection handles are rendered and not faded away',
        (WidgetTester tester) async {
      const testText = r'abcdef\frac{abc}{def}\sqrt[abc]{def}';
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: Center(
              child: MathSelectable.tex(testText),
            ),
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
    },
        variant: const TargetPlatformVariant(
            <TargetPlatform>{TargetPlatform.iOS, TargetPlatform.macOS}));

    testWidgets('Long press shows handles and toolbar',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: Center(
              child: MathSelectable.tex('abc def ghi'),
            ),
          ),
        ),
      );

      // Long press at 'e' in 'def'.
      final ePos = textOffsetToCaretPosition(tester, 5);
      await tester.longPressAt(ePos);
      await tester.pumpAndSettle();

      final selectableMath = tester.state<InternalSelectableMathState>(
          find.byType(InternalSelectableMath));
      expect(selectableMath.selectionOverlay.handlesAreVisible, isTrue);
      expect(selectableMath.selectionOverlay.toolbarIsVisible, isTrue);
    });

    testWidgets('Double tap shows handles and toolbar',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: Center(
              child: MathSelectable.tex('abc def ghi'),
            ),
          ),
        ),
      );

      // Double tap at 'e' in 'def'.
      final ePos = textOffsetToCaretPosition(tester, 5);
      await tester.tapAt(ePos);
      await tester.pump(const Duration(milliseconds: 50));
      await tester.tapAt(ePos);
      await tester.pump();

      final selectableMath = tester.state<InternalSelectableMathState>(
          find.byType(InternalSelectableMath));
      expect(selectableMath.selectionOverlay.handlesAreVisible, isTrue);
      expect(selectableMath.selectionOverlay.toolbarIsVisible, isTrue);
    });

    testWidgets(
      'Mouse tap does not show handles nor toolbar',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Material(
              child: Center(
                child: MathSelectable.tex('abc def ghi'),
              ),
            ),
          ),
        );

        // Long press to trigger the selectable text.
        final ePos = textOffsetToCaretPosition(tester, 5);
        final gesture = await tester.startGesture(
          ePos,
          pointer: 7,
          kind: PointerDeviceKind.mouse,
        );
        addTearDown(gesture.removePointer);
        await tester.pump();
        await gesture.up();
        await tester.pump();

        final selectableMath = tester.state<InternalSelectableMathState>(
            find.byType(InternalSelectableMath));
        expect(selectableMath.selectionOverlay.toolbarIsVisible, isFalse);
        expect(selectableMath.selectionOverlay.handlesAreVisible, isFalse);
      },
    );

    testWidgets(
      'Mouse long press does not show handles nor toolbar',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Material(
              child: Center(
                child: MathSelectable.tex('abc def ghi'),
              ),
            ),
          ),
        );

        // Long press to trigger the selectable text.
        final ePos = textOffsetToCaretPosition(tester, 5);
        final gesture = await tester.startGesture(
          ePos,
          pointer: 7,
          kind: PointerDeviceKind.mouse,
        );
        addTearDown(gesture.removePointer);
        await tester.pump(const Duration(seconds: 2));
        await gesture.up();
        await tester.pump();

        final selectableMath = tester.state<InternalSelectableMathState>(
            find.byType(InternalSelectableMath));
        expect(selectableMath.selectionOverlay.toolbarIsVisible, isFalse);
        expect(selectableMath.selectionOverlay.handlesAreVisible, isFalse);
      },
    );

    testWidgets(
      'Mouse double tap does not show handles nor toolbar',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Material(
              child: Center(
                child: MathSelectable.tex('abc def ghi'),
              ),
            ),
          ),
        );

        // Double tap to trigger the selectable text.
        final selectableTextPos = tester.getCenter(find.byType(MathSelectable));
        final gesture = await tester.startGesture(
          selectableTextPos,
          pointer: 7,
          kind: PointerDeviceKind.mouse,
        );
        addTearDown(gesture.removePointer);
        await tester.pump(const Duration(milliseconds: 50));
        await gesture.up();
        await tester.pump();
        await gesture.down(selectableTextPos);
        await tester.pump();
        await gesture.up();
        await tester.pump();

        final selectableMath = tester.state<InternalSelectableMathState>(
            find.byType(InternalSelectableMath));
        expect(selectableMath.selectionOverlay.toolbarIsVisible, isFalse);
        expect(selectableMath.selectionOverlay.handlesAreVisible, isFalse);
      },
    );

    testWidgets('changes mouse cursor when hovered',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: Center(
              child: MathSelectable.tex('test'),
            ),
          ),
        ),
      );

      final gesture =
          await tester.createGesture(kind: PointerDeviceKind.mouse, pointer: 1);
      await gesture.addPointer(
          location: tester.getCenter(find.byType(MathSelectable)));
      addTearDown(gesture.removePointer);

      await tester.pump();

      expect(RendererBinding.instance.mouseTracker.debugDeviceActiveCursor(1),
          SystemMouseCursors.text);
    });

    // testWidgets(
    //   'The handles show after pressing Select All',
    //   (WidgetTester tester) async {
    //     await tester.pumpWidget(
    //       MaterialApp(
    //         home: Material(
    //           child: Center(
    //             child: MathSelectable.tex('abc def ghi'),
    //           ),
    //         ),
    //       ),
    //     );

    //     // Long press at 'e' in 'def'.
    //     final ePos = textOffsetToCaretPosition(tester, 5);
    //     await tester.longPressAt(ePos);
    //     await tester.pumpAndSettle();

    //     expect(find.text('Select all'), findsOneWidget);
    //     expect(find.text('Copy'), findsOneWidget);
    //     expect(find.text('Paste'), findsNothing);
    //     expect(find.text('Cut'), findsNothing);
    //     var selectableMath = tester.state<InternalSelectableMathState>(
    //         find.byType(InternalSelectableMath));
    //     expect(selectableMath.selectionOverlay.handlesAreVisible, isTrue);
    //     expect(selectableMath.selectionOverlay.toolbarIsVisible, isTrue);

    //     await tester.tap(find.text('Select all'));
    //     await tester.pump();
    //     expect(find.text('Copy'), findsOneWidget);
    //     expect(find.text('Select all'), findsNothing);
    //     expect(find.text('Paste'), findsNothing);
    //     expect(find.text('Cut'), findsNothing);
    //     selectableMath = tester.state<InternalSelectableMathState>(
    //         find.byType(InternalSelectableMath));
    //     expect(selectableMath.selectionOverlay.handlesAreVisible, isTrue);
    //   },
    //   variant: const TargetPlatformVariant(<TargetPlatform>{
    //     TargetPlatform.android,
    //     TargetPlatform.fuchsia,
    //     TargetPlatform.linux,
    //     TargetPlatform.windows,
    //   }),
    // );

    testWidgets('Does not show handles when updated from the web engine',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: Center(
              child: MathSelectable.tex('abc def ghi'),
            ),
          ),
        ),
      );

      // Interact with the selectable text to establish the input connection.
      final topLeft = tester.getTopLeft(find.byType(MathSelectable));
      final gesture = await tester.startGesture(
        topLeft + const Offset(0.0, 5.0),
        kind: PointerDeviceKind.mouse,
      );
      addTearDown(gesture.removePointer);
      await tester.pump(const Duration(milliseconds: 50));
      await gesture.up();
      await tester.pumpAndSettle();

      final state = tester.state<InternalSelectableMathState>(
          find.byType(InternalSelectableMath));
      expect(state.selectionOverlay.handlesAreVisible, isFalse);
      expect(
        state.currentTextEditingValue.selection,
        const TextSelection.collapsed(offset: 0),
      );

      if (kIsWeb) {
        tester.testTextInput.updateEditingValue(const TextEditingValue(
          selection: TextSelection(baseOffset: 2, extentOffset: 7),
        ));
        // Wait for all the `setState` calls to be flushed.
        await tester.pumpAndSettle();
        expect(
          state.currentTextEditingValue.selection,
          const TextSelection(baseOffset: 2, extentOffset: 7),
        );
        expect(state.selectionOverlay.handlesAreVisible, isFalse);
      }
    });

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
