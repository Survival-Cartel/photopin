import 'package:flutter_test/flutter_test.dart';
import 'package:photopin/journal/data/data_source/journal_data_source.dart';
import 'package:photopin/journal/data/repository/journal_repository.dart';
import 'package:photopin/journal/data/repository/journal_repository_impl.dart';

import '../data_source/fake_journal_data_source.dart';


void main() {
  late JournalRepository repository;
  final JournalDataSource dataSource = FakeJournalDataSource();

  setUpAll(() {
    repository = JournalRepositoryImpl(dataSource: dataSource);
  });
  
  testWidgets('', (WidgetTester tester) async {

  });
}