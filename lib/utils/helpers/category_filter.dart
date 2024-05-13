import 'package:animated_custom_dropdown/custom_dropdown.dart';

class Category with CustomDropdownListFilter {
  final String name;
  const Category(this.name);

  @override
  String toString() => name;

  @override
  bool filter(String query) => name.toLowerCase().contains(query.toLowerCase());
}
