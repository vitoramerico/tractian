enum StatusEnum {
  operating('operating'),
  alert('alert'),
  none('');

  final String name;

  const StatusEnum(this.name);

  static StatusEnum fromString(String value) {
    return StatusEnum.values.firstWhere(
      (e) => e.name == value,
      orElse: () => StatusEnum.none,
    );
  }
}
