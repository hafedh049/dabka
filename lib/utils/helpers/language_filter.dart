import 'package:animated_custom_dropdown/custom_dropdown.dart';

class Language with CustomDropdownListFilter {
  final String name;
  const Language(this.name);

  @override
  String toString() => name;

  @override
  bool filter(String query) => name.toLowerCase().contains(query.toLowerCase());
}
