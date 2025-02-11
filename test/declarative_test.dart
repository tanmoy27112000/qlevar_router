import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qlevar_router/qlevar_router.dart';

import 'helpers.dart';

void main() {
  group('Declarative routes tests', () {
    testWidgets('Navigation', (tester) async {
      await tester.pumpWidget(MaterialApp.router(
        routeInformationParser: const QRouteInformationParser(),
        routerDelegate: QRouterDelegate(
          [
            QRoute(
              path: '/',
              builder: () => Container(),
            ),
            QRoute.declarative(
              path: '/declarative',
              declarativeBuilder: (k) => _DeclarativePage(k),
            ),
          ],
        ),
      ));

      expect(find.byType(_DeclarativePage), findsNothing);
      await QR.to('/declarative');
      await tester.pumpAndSettle();
      expect(find.byType(_DeclarativePage), findsOneWidget);
      expect(find.text('Do you love Coffee?'), findsOneWidget);
      await tester.tap(find.text('Yes'));
      await tester.pumpAndSettle();
      expect(find.text('Do you love burger?'), findsOneWidget);
      await tester.tap(find.text('Yes'));
      await tester.pumpAndSettle();
      expectedPath('/declarative');
      expect(find.text('Do you love Pizza?'), findsOneWidget);
      await tester.tap(find.text('Yes'));
      await tester.pumpAndSettle();
      expect(find.text('Lets go to burger king, you can order coffee :)'),
          findsOneWidget);
      await tester.tap(find.text('Back'));
      await tester.pumpAndSettle();
      expect(find.text('Do you love Pizza?'), findsOneWidget);
      expectedPath('/declarative');
    });
  });
}

class _DeclarativePage extends StatefulWidget {
  final QKey dKey;
  const _DeclarativePage(this.dKey);
  @override
  _DeclarativePageState createState() => _DeclarativePageState();
}

class _DeclarativePageState extends State<_DeclarativePage> {
  final state = _Info();
  @override
  Widget build(BuildContext context) => Scaffold(
      body: QDeclarative(
          routeKey: widget.dKey,
          builder: () => [
                QDRoute(
                  name: 'Hungry',
                  builder: () => getQuestion(
                      (v) => state.loveCoffee = v, 'Do you love Coffee?'),
                  when: () => state.loveCoffee == null,
                  onPop: () => false,
                ),
                QDRoute(
                    name: 'Burger',
                    builder: () => getQuestion(
                        (v) => state.loveBurger = v, 'Do you love burger?'),
                    onPop: () => state.loveCoffee = null,
                    when: () => state.loveBurger == null,
                    pageType: const QSlidePage(
                        curve: Curves.easeInOutCubic,
                        offset: Offset(-1, 0),
                        transitionDurationMilliseconds: 500)),
                QDRoute(
                    name: 'Pizza',
                    builder: () => getQuestion(
                        (v) => state.lovePizza = v, 'Do you love Pizza?'),
                    onPop: () => state.loveBurger = null,
                    when: () => state.lovePizza == null,
                    pageType: const QSlidePage(offset: Offset(-1, 1))),
                QDRoute(
                    name: 'Result',
                    builder: result,
                    onPop: () => state.lovePizza = null,
                    when: () => state.allSet)
              ]));

  Widget getQuestion(void Function(bool) value, String text) => Scaffold(
          body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        back,
        const SizedBox(height: 50),
        Text(text, style: const TextStyle(fontSize: 18)),
        const SizedBox(height: 25),
        yesNo(value),
      ]));

  Widget yesNo(void Function(bool) value) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
              onPressed: () {
                value(true);
                setState(() {});
              },
              child: const Text('Yes', style: TextStyle(fontSize: 18))),
          ElevatedButton(
              onPressed: () {
                value(false);
                setState(() {});
              },
              child: const Text('No', style: TextStyle(fontSize: 18))),
        ],
      );

  Widget result() => Scaffold(
          body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          back,
          const SizedBox(height: 25),
          Text('Your answers: $state'),
          const SizedBox(height: 50),
          Text(getResult(), style: const TextStyle(fontSize: 25)),
          const Divider(),
          ElevatedButton(
              onPressed: () {
                state.loveCoffee = null;
                state.loveBurger = null;
                state.lovePizza = null;
                setState(() {});
              },
              child: const Text('Reset')),
        ],
      ));

  Widget back = ElevatedButton(onPressed: QR.back, child: const Text('Back'));

  String getResult() {
    if (state.loveCoffee == true && state.loveBurger == false) {
      // ignore: lines_longer_than_80_chars
      return "Lets go to burger king, you can order Coffee and will get a burger :)";
    }
    if (state.loveCoffee == true) {
      return "Lets go to burger king, you can order coffee :)";
    }
    if (state.loveBurger == true) {
      return "Lets go to burger king :)";
    }
    return " I want burger, lets go to burger king :D";
  }
}

class _Info {
  bool? loveCoffee;
  bool? loveBurger;
  bool? lovePizza;

  bool get allSet =>
      loveBurger != null && loveCoffee != null && lovePizza != null;

  @override
  String toString() =>
      'loveCoffee: $loveCoffee, loveBurger: $loveBurger, lovePizza: $lovePizza';
}
