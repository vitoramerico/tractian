import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tractian/src/data/models/company_model.dart';
import 'package:tractian/src/presenter/companies/pages/components/item_widget.dart';

void main() {
  group('ItemWidget', () {
    testWidgets(
      'renders company name and triggers onPressed callback when tapped',
      (tester) async {
        // Arrange
        const testCompanyId = 'company1';
        const testCompanyName = 'Company 1';
        final company = CompanyModel(id: testCompanyId, name: testCompanyName);
        String tappedCompanyId = '';

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ItemWidget(
                company: company,
                onPressed: (id) {
                  tappedCompanyId = id;
                },
              ),
            ),
          ),
        );

        // Assert
        expect(find.text(testCompanyName), findsOneWidget);

        // Act
        await tester.tap(find.byKey(Key(testCompanyId)));
        await tester.pumpAndSettle();

        // Assert
        expect(tappedCompanyId, equals(testCompanyId));
      },
    );
  });
}
