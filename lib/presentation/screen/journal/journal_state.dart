import 'package:flutter/material.dart';
import 'package:photopin/core/enums/search_filter_option.dart';
import 'package:photopin/journal/domain/model/journal_model.dart';
import 'package:photopin/photo/domain/model/photo_model.dart';

class JournalState {
  final bool isLoading;
  final List<JournalModel> journals;
  final Map<String, List<PhotoModel>> photoMap;
  final DateTimeRange searchDateTimeRange;
  final SearchFilterOption searchFilterOption;

  JournalState({
    this.isLoading = false,
    List<JournalModel> journals = const [],
    DateTimeRange? searchDateTimeRange,
    this.searchFilterOption = SearchFilterOption.title,
    Map<String, List<PhotoModel>> photoMap = const {},
  }) : journals = List.unmodifiable(journals),
       photoMap = Map.unmodifiable(photoMap),
       searchDateTimeRange =
           searchDateTimeRange ??
           DateTimeRange(start: DateTime.now(), end: DateTime.now());

  JournalState copyWith({
    bool? isLoading,
    List<JournalModel>? journals,
    Map<String, List<PhotoModel>>? photoMap,
    SearchFilterOption? searchFilterOption,
    DateTimeRange? searchDateTimeRange,
  }) {
    return JournalState(
      isLoading: isLoading ?? this.isLoading,
      searchFilterOption: searchFilterOption ?? this.searchFilterOption,
      searchDateTimeRange: searchDateTimeRange ?? this.searchDateTimeRange,
      journals: journals != null ? List.unmodifiable(journals) : this.journals,
      photoMap: photoMap != null ? Map.unmodifiable(photoMap) : this.photoMap,
    );
  }
}
