import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:uts_mobile_flutter_2306044_muhamadrijkinurjakiah/main.dart';
import 'package:uts_mobile_flutter_2306044_muhamadrijkinurjakiah/providers/auth_provider.dart';
import 'package:uts_mobile_flutter_2306044_muhamadrijkinurjakiah/providers/product_provider.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          ChangeNotifierProvider(create: (_) => ProductProvider()),
        ],
        child: const SmartGadgetStoreApp(),
      ),
    );
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
