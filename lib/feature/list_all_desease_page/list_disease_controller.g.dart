// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_disease_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$searchedDiseaseListHash() =>
    r'c60e4572bb9dbed4659b2c9ab38fd078c44e8833';

/// See also [searchedDiseaseList].
@ProviderFor(searchedDiseaseList)
final searchedDiseaseListProvider = AutoDisposeProvider<List<Disease>>.internal(
  searchedDiseaseList,
  name: r'searchedDiseaseListProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$searchedDiseaseListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SearchedDiseaseListRef = AutoDisposeProviderRef<List<Disease>>;
String _$diseaseListControllerHash() =>
    r'dcadf1f0ffd37d278faac3a41a6db61511f2d38b';

/// See also [DiseaseListController].
@ProviderFor(DiseaseListController)
final diseaseListControllerProvider = AutoDisposeAsyncNotifierProvider<
    DiseaseListController, List<Disease>>.internal(
  DiseaseListController.new,
  name: r'diseaseListControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$diseaseListControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$DiseaseListController = AutoDisposeAsyncNotifier<List<Disease>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
