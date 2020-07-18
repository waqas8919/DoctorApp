class GenderClass {
  int id;
  String name;

  GenderClass(this.id, this.name);

  static List<GenderClass> getGenders() {
    return <GenderClass>[
      GenderClass(1, 'Male'),
      GenderClass(2, 'Female'),
      GenderClass(3, 'Both'),
    ];
  }
}