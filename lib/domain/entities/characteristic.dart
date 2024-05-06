class Characteristic {
  final String m;
  final String t;
  final String sv;
  final String w;
  final String ld;
  final String oc;

  Characteristic({
    required this.m,
    required this.t,
    required this.sv,
    required this.w,
    required this.ld,
    required this.oc,
  });

  factory Characteristic.empty() {
    return Characteristic(m: '', t: '', sv: '', w: '', ld: '', oc: '');
  }
}