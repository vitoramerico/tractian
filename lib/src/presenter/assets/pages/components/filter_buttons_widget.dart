import 'package:flutter/material.dart';

import '../../../../domain/enum/sensor_type_enum.dart';
import '../../../../domain/enum/status_enum.dart';
import '../../view_models/assets_view_model.dart';
import 'button_widget.dart';

class FilterButtonsWidget extends StatefulWidget {
  final AssetsViewModel viewModel;

  const FilterButtonsWidget({super.key, required this.viewModel});

  @override
  State<FilterButtonsWidget> createState() => _FilterButtonsWidgetState();
}

class _FilterButtonsWidgetState extends State<FilterButtonsWidget> {
  bool _isFilterEnergy = false;
  bool _isFilterCritical = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ButtonWidget(
          filled: _isFilterEnergy,
          text: 'Sensor de Energia',
          iconData: Icons.bolt_outlined,
          onPressed: () {
            setState(() {
              _isFilterEnergy = !_isFilterEnergy;
            });
            widget.viewModel.setFilter(
              widget.viewModel.filter!.copyWith(
                sensorType: _isFilterEnergy ? SensorTypeEnum.energy.name : '',
              ),
            );
          },
        ),
        const SizedBox(width: 8),
        ButtonWidget(
          filled: _isFilterCritical,
          text: 'Crítico',
          iconData: Icons.error_outline,
          onPressed: () {
            setState(() {
              _isFilterCritical = !_isFilterCritical;
            });
            widget.viewModel.setFilter(
              widget.viewModel.filter!.copyWith(
                status: _isFilterCritical ? StatusEnum.alert.name : '',
              ),
            );
          },
        ),
      ],
    );
  }
}
