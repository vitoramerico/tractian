// Mocks generated by Mockito 5.4.5 from annotations
// in tractian/test/src/domain/usecases/get_locations_by_company_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i3;

import 'package:mockito/mockito.dart' as _i1;
import 'package:mockito/src/dummies.dart' as _i6;
import 'package:tractian/src/core/utils/result.dart' as _i4;
import 'package:tractian/src/data/models/asset_model.dart' as _i8;
import 'package:tractian/src/data/models/company_model.dart' as _i5;
import 'package:tractian/src/data/models/location_model.dart' as _i7;
import 'package:tractian/src/data/repositories/i_tractian_repository.dart.dart'
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

/// A class which mocks [ITractianRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockITractianRepository extends _i1.Mock
    implements _i2.ITractianRepository {
  MockITractianRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Future<_i4.Result<List<_i5.CompanyModel>>> getCompanies() =>
      (super.noSuchMethod(
            Invocation.method(#getCompanies, []),
            returnValue: _i3.Future<_i4.Result<List<_i5.CompanyModel>>>.value(
              _i6.dummyValue<_i4.Result<List<_i5.CompanyModel>>>(
                this,
                Invocation.method(#getCompanies, []),
              ),
            ),
          )
          as _i3.Future<_i4.Result<List<_i5.CompanyModel>>>);

  @override
  _i3.Future<_i4.Result<List<_i7.LocationModel>>> getLocationsByCompany({
    required String? companyId,
  }) =>
      (super.noSuchMethod(
            Invocation.method(#getLocationsByCompany, [], {
              #companyId: companyId,
            }),
            returnValue: _i3.Future<_i4.Result<List<_i7.LocationModel>>>.value(
              _i6.dummyValue<_i4.Result<List<_i7.LocationModel>>>(
                this,
                Invocation.method(#getLocationsByCompany, [], {
                  #companyId: companyId,
                }),
              ),
            ),
          )
          as _i3.Future<_i4.Result<List<_i7.LocationModel>>>);

  @override
  _i3.Future<_i4.Result<List<_i8.AssetModel>>> getAssetsByCompany({
    required String? companyId,
  }) =>
      (super.noSuchMethod(
            Invocation.method(#getAssetsByCompany, [], {#companyId: companyId}),
            returnValue: _i3.Future<_i4.Result<List<_i8.AssetModel>>>.value(
              _i6.dummyValue<_i4.Result<List<_i8.AssetModel>>>(
                this,
                Invocation.method(#getAssetsByCompany, [], {
                  #companyId: companyId,
                }),
              ),
            ),
          )
          as _i3.Future<_i4.Result<List<_i8.AssetModel>>>);

  @override
  _i3.Future<_i4.Result<List<_i7.LocationModel>>> filterLocations({
    required String? companyId,
    required String? query,
  }) =>
      (super.noSuchMethod(
            Invocation.method(#filterLocations, [], {
              #companyId: companyId,
              #query: query,
            }),
            returnValue: _i3.Future<_i4.Result<List<_i7.LocationModel>>>.value(
              _i6.dummyValue<_i4.Result<List<_i7.LocationModel>>>(
                this,
                Invocation.method(#filterLocations, [], {
                  #companyId: companyId,
                  #query: query,
                }),
              ),
            ),
          )
          as _i3.Future<_i4.Result<List<_i7.LocationModel>>>);

  @override
  _i3.Future<_i4.Result<List<_i8.AssetModel>>> filterAssets({
    required String? companyId,
    required List<String>? lstLocationId,
    required String? query,
    required String? sensorType,
    required String? status,
  }) =>
      (super.noSuchMethod(
            Invocation.method(#filterAssets, [], {
              #companyId: companyId,
              #lstLocationId: lstLocationId,
              #query: query,
              #sensorType: sensorType,
              #status: status,
            }),
            returnValue: _i3.Future<_i4.Result<List<_i8.AssetModel>>>.value(
              _i6.dummyValue<_i4.Result<List<_i8.AssetModel>>>(
                this,
                Invocation.method(#filterAssets, [], {
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
