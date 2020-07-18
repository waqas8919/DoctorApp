class StatusClass {
  int id;
  String name;

  StatusClass(this.id, this.name);

  static List<StatusClass> getStatus() {
    return <StatusClass>[
      StatusClass(1, 'Active'),
      StatusClass(1, 'Pending Authentication'),
      StatusClass(2, 'DisCharge'),
    ];
  }
}