enum SensorTypeEnum {
  vibration('vibration'),
  energy('energy'),
  none('');

  final String name;

  const SensorTypeEnum(this.name);

  static SensorTypeEnum fromString(String value) {
    return SensorTypeEnum.values.firstWhere(
      (e) => e.name == value,
      orElse: () => SensorTypeEnum.none,
    );
  }
}
