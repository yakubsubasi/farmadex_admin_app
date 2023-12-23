// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'disease_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$diseaseControllerHash() => r'3dabc356a1a966fecd2d59bf07bfb5cdb2edae08';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$DiseaseController
    extends BuildlessAutoDisposeAsyncNotifier<Disease> {
  late final int id;

  FutureOr<Disease> build(
    int id,
  );
}

/// See also [DiseaseController].
@ProviderFor(DiseaseController)
const diseaseControllerProvider = DiseaseControllerFamily();

/// See also [DiseaseController].
class DiseaseControllerFamily extends Family<AsyncValue<Disease>> {
  /// See also [DiseaseController].
  const DiseaseControllerFamily();

  /// See also [DiseaseController].
  DiseaseControllerProvider call(
    int id,
  ) {
    return DiseaseControllerProvider(
      id,
    );
  }

  @override
  DiseaseControllerProvider getProviderOverride(
    covariant DiseaseControllerProvider provider,
  ) {
    return call(
      provider.id,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'diseaseControllerProvider';
}

/// See also [DiseaseController].
class DiseaseControllerProvider
    extends AutoDisposeAsyncNotifierProviderImpl<DiseaseController, Disease> {
  /// See also [DiseaseController].
  DiseaseControllerProvider(
    int id,
  ) : this._internal(
          () => DiseaseController()..id = id,
          from: diseaseControllerProvider,
          name: r'diseaseControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$diseaseControllerHash,
          dependencies: DiseaseControllerFamily._dependencies,
          allTransitiveDependencies:
              DiseaseControllerFamily._allTransitiveDependencies,
          id: id,
        );

  DiseaseControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final int id;

  @override
  FutureOr<Disease> runNotifierBuild(
    covariant DiseaseController notifier,
  ) {
    return notifier.build(
      id,
    );
  }

  @override
  Override overrideWith(DiseaseController Function() create) {
    return ProviderOverride(
      origin: this,
      override: DiseaseControllerProvider._internal(
        () => create()..id = id,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<DiseaseController, Disease>
      createElement() {
    return _DiseaseControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DiseaseControllerProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin DiseaseControllerRef on AutoDisposeAsyncNotifierProviderRef<Disease> {
  /// The parameter `id` of this provider.
  int get id;
}

class _DiseaseControllerProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<DiseaseController, Disease>
    with DiseaseControllerRef {
  _DiseaseControllerProviderElement(super.provider);

  @override
  int get id => (origin as DiseaseControllerProvider).id;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
