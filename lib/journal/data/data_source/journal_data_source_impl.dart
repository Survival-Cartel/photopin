import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:photopin/core/errors/firestore_error.dart';
import 'package:photopin/journal/data/data_source/journal_data_source.dart';
import 'package:photopin/journal/data/dto/journal_dto.dart';

class JournalDataSourceImpl implements JournalDataSource {
  final CollectionReference<JournalDto> _journalStore;

  JournalDataSourceImpl({required CollectionReference<JournalDto> journalStore})
    : _journalStore = journalStore;

  @override
  Future<JournalDto> findJournalById(String id) async {
    final QuerySnapshot<JournalDto> snapshot = await _journalStore
        .where('id', isEqualTo: id)
        .get()
        .timeout(
          const Duration(seconds: 8),
          onTimeout: () => throw FirestoreError.timeOutError,
        );

    for (final docSnapshot in snapshot.docs) {
      return docSnapshot.data();
    }

    throw FirestoreError.notFoundError;
  }

  @override
  Future<JournalDto> findJournalByName(String name) async {
    final QuerySnapshot<JournalDto> snapshot = await _journalStore
        .where('name', isEqualTo: name)
        .get()
        .timeout(
          const Duration(seconds: 8),
          onTimeout: () => throw FirestoreError.timeOutError,
        );

    for (final docSnapshot in snapshot.docs) {
      return docSnapshot.data();
    }

    throw FirestoreError.notFoundError;
  }

  @override
  Future<void> deleteJournal(String journalId) async {
    await _journalStore.doc(journalId).delete();
  }

  @override
  Future<void> saveJournal(JournalDto dto) async {
    final DocumentReference<JournalDto> journaldoc = await _journalStore.add(
      dto,
    );
    final String docId = journaldoc.id;

    await _journalStore.doc(docId).update({'id': docId});
  }

  @override
  Future<List<JournalDto>> findJournals() async {
    try {
      final snapshot = await _journalStore.get().timeout(
        const Duration(seconds: 8),
        onTimeout: () => throw FirestoreError.timeOutError,
      );

      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      // 필요 시 다른 에러 핸들링 가능
      rethrow;
    }
  }

  @override
  Stream<List<JournalDto>> watchJournals() {
    try {
      return _journalStore.snapshots().map(
        (snapshot) => snapshot.docs.map((doc) => doc.data()).toList(),
      );
    } catch (e) {
      throw FirestoreError.notFoundError;
    }
  }

  @override
  Future<void> update(JournalDto journal) async {
    await _journalStore.doc(journal.id).set(journal, SetOptions(merge: true));
  }

  @override
  Future<List<JournalDto>> findJournalsByDateTimeRange(
    DateTimeRange range,
  ) async {
    try {
      final snapshot = await _journalStore
          .where('startDate', isGreaterThanOrEqualTo: range.start)
          .where('endDate', isLessThanOrEqualTo: range.end)
          .get()
          .timeout(
            const Duration(seconds: 8),
            onTimeout: () => throw FirestoreError.timeOutError,
          );

      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      // 필요 시 다른 에러 핸들링 가능
      rethrow;
    }
  }
}
