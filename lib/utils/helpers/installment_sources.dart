import 'package:dabka/utils/shared.dart';
import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:google_fonts/google_fonts.dart';

@immutable
final class InstallmentPeriodModel {
  final String methodPath;
  final String sixMonth;
  final String twelveMonth;
  final String twentyfourMonth;
  final String thirtysixMonth;

  const InstallmentPeriodModel({required this.methodPath, required this.sixMonth, required this.twelveMonth, required this.twentyfourMonth, required this.thirtysixMonth});
}

class RestorableInstallmentPeriodSelections extends RestorableProperty<Set<int>> {
  Set<int> _installmentPeriodSelections = <int>{};

  bool isSelected(int index) => _installmentPeriodSelections.contains(index);

  @override
  Set<int> createDefaultValue() => _installmentPeriodSelections;

  @override
  Set<int> fromPrimitives(Object? data) {
    final selectedItemIndices = data as List<dynamic>;
    _installmentPeriodSelections = <int>{...selectedItemIndices.map<int>((dynamic id) => id as int)};
    return _installmentPeriodSelections;
  }

  @override
  void initWithValue(Set<int> value) {
    _installmentPeriodSelections = value;
  }

  @override
  Object toPrimitives() => _installmentPeriodSelections.toList();
}

class InstallmentPeriodDataSource extends DataTableSource {
  InstallmentPeriodDataSource.empty(this.context) {
    installmentPeriods = <InstallmentPeriodModel>[];
  }

  InstallmentPeriodDataSource(this.context, this.installmentPeriods);

  final BuildContext context;
  List<InstallmentPeriodModel> installmentPeriods = <InstallmentPeriodModel>[];
  final bool hasRowTaps = true;
  final bool hasRowHeightOverrides = true;
  final bool hasZebraStripes = true;

  @override
  DataRow2 getRow(int index, [Color? color]) {
    assert(index >= 0);
    if (index >= installmentPeriods.length) throw 'index > _installmentPeriods.length';
    final InstallmentPeriodModel installmentPeriod = installmentPeriods[index];
    return DataRow2.byIndex(
      index: index,
      color: color != null ? WidgetStateProperty.all(color) : (hasZebraStripes && index.isEven ? WidgetStateProperty.all(Theme.of(context).highlightColor) : null),
      cells: <DataCell>[
        DataCell(
          Container(
            width: 80,
            height: 60,
            margin: const EdgeInsets.symmetric(vertical: 8),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              image: DecorationImage(image: AssetImage("assets/images/${installmentPeriod.methodPath}.png"), fit: BoxFit.cover),
            ),
          ),
        ),
        DataCell(Text(installmentPeriod.sixMonth, style: GoogleFonts.abel(fontSize: 12, fontWeight: FontWeight.w500, color: dark))),
        DataCell(Text(installmentPeriod.twelveMonth, style: GoogleFonts.abel(fontSize: 12, fontWeight: FontWeight.w500, color: dark))),
        DataCell(Text(installmentPeriod.twentyfourMonth, style: GoogleFonts.abel(fontSize: 12, fontWeight: FontWeight.w500, color: dark))),
        DataCell(Text(installmentPeriod.thirtysixMonth, style: GoogleFonts.abel(fontSize: 12, fontWeight: FontWeight.w500, color: dark))),
      ],
    );
  }

  @override
  int get rowCount => installmentPeriods.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => installmentPeriods.length;
}
