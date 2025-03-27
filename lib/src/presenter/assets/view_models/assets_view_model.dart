import 'package:flutter/widgets.dart';

import '../../../core/utils/command.dart';
import '../../../core/utils/debouncer/debouncer.dart';
import '../../../core/utils/result.dart';
import '../../../data/models/asset_model.dart';
import '../../../data/models/location_model.dart';
import '../../../domain/entity/filter_entity.dart';
import '../../../domain/entity/tree_node_entity.dart';
import '../../../domain/usecases/build_tree_structure.dart';
import '../../../domain/usecases/get_assets_by_company.dart';
import '../../../domain/usecases/get_filtered_assets.dart';
import '../../../domain/usecases/get_filtered_locations.dart';
import '../../../domain/usecases/get_locations_by_company.dart';

class AssetsViewModel extends ChangeNotifier {
  AssetsViewModel(
    this._getLocationsByCompany,
    this._getAssetsByCompany,
    this._getFilteredAssets,
    this._getFilteredLocations,
    this._buildTreeStructure,
  ) {
    getLocationsByCompany = Command1(_getLocations);
    getAssetsByCompany = Command1(_getAssets);
    getFilteredAssetsAndLocation = Command1(_getAssetsAndLocationByFilter);
    buildTreeStructure = Command0(_buildTree);
  }

  final GetLocationsByCompany _getLocationsByCompany;
  final GetAssetsByCompany _getAssetsByCompany;
  final GetFilteredAssets _getFilteredAssets;
  final GetFilteredLocations _getFilteredLocations;
  final BuildTreeStructure _buildTreeStructure;

  late final Command1<List<LocationModel>, String> getLocationsByCompany;
  late final Command1<List<AssetModel>, String> getAssetsByCompany;
  late final Command1<void, FilterEntity> getFilteredAssetsAndLocation;
  late final Command0<List<TreeNodeEntity>> buildTreeStructure;

  final _debouncer = Debouncer(milliseconds: 500);

  List<LocationModel> _lstLocation = [];
  List<LocationModel> get lstLocation => _lstLocation;
  void setLstLocation(List<LocationModel> value) {
    _lstLocation = value;
    notifyListeners();
  }

  List<AssetModel> _lstAssets = [];
  List<AssetModel> get lstAssets => _lstAssets;
  void setLstAssets(List<AssetModel> value) {
    _lstAssets = value;
    notifyListeners();
  }

  List<TreeNodeEntity> _lstTreeNode = [];
  List<TreeNodeEntity> get lstTreeNode => _lstTreeNode;
  void setLstTreeNode(List<TreeNodeEntity> value) {
    _lstTreeNode = value;
    notifyListeners();
  }

  FilterEntity? _filter;
  FilterEntity? get filter => _filter;
  void setFilter(FilterEntity value) {
    _filter = value;
    getFilteredAssetsAndLocation.execute(value);
  }

  void onSearchChanged(String text) {
    if (_filter == null) return;
    _debouncer.run(() {
      setFilter(_filter!.copyWith(query: text));
    });
  }

  Future<void> init(String companyId) async {
    _filter = FilterEntity(companyId: companyId);

    await Future.wait([
      getLocationsByCompany.execute(companyId),
      getAssetsByCompany.execute(companyId),
    ]);

    buildTreeStructure.execute();
  }

  Future<Result<List<LocationModel>>> _getLocations(String companyId) async {
    final result = await _getLocationsByCompany(companyId: companyId);

    return result.fold(
      (values) => Result.ok(_lstLocation = values),
      (error) => Result.error(error),
    );
  }

  Future<Result<List<AssetModel>>> _getAssets(String companyId) async {
    final result = await _getAssetsByCompany(companyId: companyId);

    return result.fold(
      (values) => Result.ok(_lstAssets = values),
      (error) => Result.error(error),
    );
  }

  Future<Result<void>> _getAssetsAndLocationByFilter(
    FilterEntity filter,
  ) async {
    final locationsResult = await _getLocationsByFilter(filter);
    if (locationsResult.isError) return locationsResult;

    final lstLocationId =
        locationsResult.getOrElse(() => []).map((e) => e.id).toList();

    final assetsResult = await _getAssetsByFilter(filter, lstLocationId);
    if (assetsResult.isError) return assetsResult;

    buildTreeStructure.execute();

    return Result.ok(null);
  }

  Future<Result<List<LocationModel>>> _getLocationsByFilter(
    FilterEntity filter,
  ) async {
    final result = await _getFilteredLocations(
      companyId: filter.companyId,
      query: filter.query,
    );

    return result.fold(
      (values) {
        if (values.isNotEmpty) _lstLocation = values;

        return Result.ok(values);
      },
      (error) {
        return Result.error(error);
      },
    );
  }

  Future<Result<List<AssetModel>>> _getAssetsByFilter(
    FilterEntity filter,
    List<String> lstLocationId,
  ) async {
    final result = await _getFilteredAssets(
      companyId: filter.companyId,
      query: filter.query,
      lstLocationId: lstLocationId,
      sensorType: filter.sensorType,
      status: filter.status,
    );

    return result.fold(
      (values) {
        _lstAssets = values;
        return Result.ok(values);
      },
      (error) {
        return Result.error(error);
      },
    );
  }

  Future<Result<List<TreeNodeEntity>>> _buildTree() async {
    final result = await _buildTreeStructure(
      locations: _lstLocation,
      assets: _lstAssets,
    );

    return result.fold(
      (values) => Result.ok(_lstTreeNode = values),
      (error) => Result.error(error),
    );
  }
}
