enum NodeTypeEnum {
  location('location'),
  asset('asset'),
  component('component'),
  none('');

  final String name;

  const NodeTypeEnum(this.name);

  static NodeTypeEnum fromString(String value) {
    return NodeTypeEnum.values.firstWhere(
      (e) => e.name == value,
      orElse: () => NodeTypeEnum.none,
    );
  }
}
