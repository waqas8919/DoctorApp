class AppointmentTypeClass {
  int id;
  String name;

  AppointmentTypeClass(this.id, this.name);

  static List<AppointmentTypeClass> getAppointments() {
    return <AppointmentTypeClass>[
      AppointmentTypeClass(1, 'TeleConsultation'),
      AppointmentTypeClass(2, 'New Follow Up'),
    ];
  }
}