import 'dart:isolate';

import '../../core/utils/result.dart';
import '../../data/models/asset_model.dart';
import '../../data/models/location_model.dart';
import '../entity/tree_node_entity.dart';
import '../enum/node_type_enum.dart';
import '../enum/sensor_type_enum.dart';
import '../enum/status_enum.dart';
import '../errors/tractian_error.dart';

class BuildTreeStructure {
  const BuildTreeStructure();

  Future<Result<List<TreeNodeEntity>>> call({
    required List<LocationModel> locations,
    required List<AssetModel> assets,
  }) async {
    try {
      return Isolate.run(() {
        // 1. Create map {id -> item}
        final itemMap = _buildItemMap(locations, assets);

        // 2. Build tree structure
        var result = _buildTreeStructure(itemMap, locations, assets);

        // 3. Remove empty locations
        result = removeEmptyLocations(result);

        return Result.ok(result);
      });
    } catch (error, stackTrace) {
      return Result.error(
        TractianDataError(
          stackTrace: stackTrace,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  Map<String, TreeNodeEntity> _buildItemMap(
    List<LocationModel> locations,
    List<AssetModel> assets,
  ) {
    Map<String, TreeNodeEntity> itemMap = {};

    // Add Locations to the map
    for (final location in locations) {
      itemMap[location.id] = TreeNodeEntity(
        id: location.id,
        name: location.name,
        type: NodeTypeEnum.location,
      );
    }

    // Add Assets to the map
    for (final asset in assets) {
      itemMap[asset.id] = TreeNodeEntity(
        id: asset.id,
        name: asset.name,
        type:
            asset.sensorId != null
                ? NodeTypeEnum.component
                : NodeTypeEnum.asset,
        sensorType: SensorTypeEnum.fromString(asset.sensorType ?? ''),
        status: StatusEnum.fromString(asset.status ?? ''),
      );
    }

    return itemMap;
  }

  List<TreeNodeEntity> _buildTreeStructure(
    Map<String, TreeNodeEntity> itemMap,
    List<LocationModel> locations,
    List<AssetModel> assets,
  ) {
    List<TreeNodeEntity> tree = [];

    // Add each Location to its correct parent
    for (final location in locations) {
      if (location.parentId != null && itemMap.containsKey(location.parentId)) {
        itemMap[location.parentId]!.children.add(itemMap[location.id]!);
      } else {
        tree.add(itemMap[location.id]!); // If it has no parentId, it's a root
      }
    }

    // Add each Asset to its correct parent (Location or another Asset)
    for (final asset in assets) {
      final assetNode = itemMap[asset.id]!;

      if (asset.parentId != null && itemMap.containsKey(asset.parentId)) {
        // If the asset has a parent (another asset), add it there
        itemMap[asset.parentId]!.children.add(assetNode);
      } else if (asset.locationId != null &&
          itemMap.containsKey(asset.locationId)) {
        // If the asset belongs to a location, add it there
        itemMap[asset.locationId]!.children.add(assetNode);
      } else {
        // If it has no parent or location, add it to the root
        tree.add(assetNode);
      }
    }

    return tree;
  }

  List<TreeNodeEntity> removeEmptyLocations(List<TreeNodeEntity> tree) {
    return tree.where((item) {
      if (item.type == NodeTypeEnum.location) {
        item.children = removeEmptyLocations(item.children);
        return item.children.isNotEmpty;
      }

      return true;
    }).toList();
  }
}
