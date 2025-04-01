// Mocks generated by Mockito 5.4.5 from annotations
// in tractian/test/src/presenter/assets/pages/assets_page_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i3;

import 'package:mockito/mockito.dart' as _i1;
import 'package:mockito/src/dummies.dart' as _i6;
import 'package:tractian/src/core/utils/result.dart' as _i4;
import 'package:tractian/src/data/models/asset_model.dart' as _i8;
import 'package:tractian/src/data/models/location_model.dart' as _i5;
import 'package:tractian/src/domain/entity/tree_node_entity.dart' as _i12;
import 'package:tractian/src/domain/usecases/build_tree_structure.dart' as _i11;
import 'package:tractian/src/domain/usecases/get_assets_by_company.dart' as _i7;
import 'package:tractian/src/domain/usecases/get_filtered_assets.dart' as _i9;
import 'package:tractian/src/domain/usecases/get_filtered_locations.dart'
    as _i10;
import 'package:tractian/src/domain/usecases/get_locations_by_company.dart'
    as _i2;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: must_be_immutable
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

/// A class which mocks [GetLocationsByCompany].
///
/// See the documentation for Mockito's code generation for more information.
class MockGetLocationsByCompany extends _i1.Mock
    implements _i2.GetLocationsByCompany {
  MockGetLocationsByCompany() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Future<_i4.Result<List<_i5.LocationModel>>> call({
    required String? companyId,
  }) =>
      (super.noSuchMethod(
            Invocation.method(#call, [], {#companyId: companyId}),
            returnValue: _i3.Future<_i4.Result<List<_i5.LocationModel>>>.value(
              _i6.dummyValue<_i4.Result<List<_i5.LocationModel>>>(
                this,
                Invocation.method(#call, [], {#companyId: companyId}),
              ),
            ),
          )
          as _i3.Future<_i4.Result<List<_i5.LocationModel>>>);
}

/// A class which mocks [GetAssetsByCompany].
///
/// See the documentation for Mockito's code generation for more information.
class MockGetAssetsByCompany extends _i1.Mock
    implements _i7.GetAssetsByCompany {
  MockGetAssetsByCompany() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Future<_i4.Result<List<_i8.AssetModel>>> call({
    required String? companyId,
  }) =>
      (super.noSuchMethod(
            Invocation.method(#call, [], {#companyId: companyId}),
            returnValue: _i3.Future<_i4.Result<List<_i8.AssetModel>>>.value(
              _i6.dummyValue<_i4.Result<List<_i8.AssetModel>>>(
                this,
                Invocation.method(#call, [], {#companyId: companyId}),
              ),
            ),
          )
          as _i3.Future<_i4.Result<List<_i8.AssetModel>>>);
}

/// A class which mocks [GetFilteredAssets].
///
/// See the documentation for Mockito's code generation for more information.
class MockGetFilteredAssets extends _i1.Mock implements _i9.GetFilteredAssets {
  MockGetFilteredAssets() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Future<_i4.Result<List<_i8.AssetModel>>> call({
    required String? companyId,
    required List<String>? lstLocationId,
    required String? query,
    required String? sensorType,
    required String? status,
  }) =>
      (super.noSuchMethod(
            Invocation.method(#call, [], {
              #companyId: companyId,
              #lstLocationId: lstLocationId,
              #query: query,
              #sensorType: sensorType,
              #status: status,
            }),
            returnValue: _i3.Future<_i4.Result<List<_i8.AssetModel>>>.value(
              _i6.dummyValue<_i4.Result<List<_i8.AssetModel>>>(
                this,
                Invocation.method(#call, [], {
                  #companyId: companyId,
                  #lstLocationId: lstLocationId,
                  #query: query,
                  #sensorType: sensorType,
                  #status: status,
                }),
              ),
            ),
          )
          as _i3.Future<_i4.Result<List<_i8.AssetModel>>>);
}

/// A class which mocks [GetFilteredLocations].
///
/// See the documentation for Mockito's code generation for more information.
class MockGetFilteredLocations extends _i1.Mock
    implements _i10.GetFilteredLocations {
  MockGetFilteredLocations() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Future<_i4.Result<List<_i5.LocationModel>>> call({
    required String? companyId,
    required String? query,
  }) =>
      (super.noSuchMethod(
            Invocation.method(#call, [], {
              #companyId: companyId,
              #query: query,
            }),
            returnValue: _i3.Future<_i4.Result<List<_i5.LocationModel>>>.value(
              _i6.dummyValue<_i4.Result<List<_i5.LocationModel>>>(
                this,
                Invocation.method(#call, [], {
                  #companyId: companyId,
                  #query: query,
                }),
              ),
            ),
          )
          as _i3.Future<_i4.Result<List<_i5.LocationModel>>>);
}

/// A class which mocks [BuildTreeStructure].
///
/// See the documentation for Mockito's code generation for more information.
class MockBuildTreeStructure extends _i1.Mock
    implements _i11.BuildTreeStructure {
  MockBuildTreeStructure() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Future<_i4.Result<List<_i12.TreeNodeEntity>>> call({
    required List<_i5.LocationModel>? locations,
    required List<_i8.AssetModel>? assets,
  }) =>
      (super.noSuchMethod(
            Invocation.method(#call, [], {
              #locations: locations,
              #assets: assets,
            }),
            returnValue:
                _i3.Future<_i4.Result<List<_i12.TreeNodeEntity>>>.value(
                  _i6.dummyValue<_i4.Result<List<_i12.TreeNodeEntity>>>(
                    this,
                    Invocation.method(#call, [], {
                      #locations: locations,
                      #assets: assets,
                    }),
                  ),
                ),
          )
          as _i3.Future<_i4.Result<List<_i12.TreeNodeEntity>>>);

  @override
  List<_i12.TreeNodeEntity> removeEmptyLocations(
    List<_i12.TreeNodeEntity>? tree,
  ) =>
      (super.noSuchMethod(
            Invocation.method(#removeEmptyLocations, [tree]),
            returnValue: <_i12.TreeNodeEntity>[],
          )
          as List<_i12.TreeNodeEntity>);
}
