import 'package:flutter/material.dart';

class EnergyAndAlertWidget extends StatelessWidget {
  final bool isEnergy;
  final bool hasAlert;

  const EnergyAndAlertWidget({
    super.key,
    required this.isEnergy,
    required this.hasAlert,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (isEnergy)
          const Padding(
            padding: EdgeInsets.only(left: 4),
            child: Icon(size: 16, color: Color(0xff53c31b), Icons.bolt),
          ),
        if (hasAlert)
          const Padding(
            padding: EdgeInsets.only(left: 4),
            child: Icon(
              size: 16,
              color: Color(0xffee3833),
              Icons.fiber_manual_record,
            ),
          ),
      ],
    );
  }
}
