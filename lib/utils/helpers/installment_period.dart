import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'installment_sources.dart';

class InstallmentPeriod extends StatefulWidget {
  const InstallmentPeriod({super.key});

  @override
  State<InstallmentPeriod> createState() => _InstallmentPeriodState();
}

class _InstallmentPeriodState extends State<InstallmentPeriod> with RestorationMixin {
  final RestorableInt _rowIndex = RestorableInt(0);

  late InstallmentPeriodDataSource _installmentPeriodsDataSource;

  bool _initialized = false;

  final List<String> _columns = const <String>["\t\t", "6 Month", "12 Month", "24 Month", "32 Month"];

  final List<InstallmentPeriodModel> _installmentPeriods = <InstallmentPeriodModel>[
    const InstallmentPeriodModel(
      methodPath: "aman",
      sixMonth: "Allowed",
      twelveMonth: "Allowed",
      twentyfourMonth: "Allowed",
      thirtysixMonth: "Allowed",
    ),
    const InstallmentPeriodModel(
      methodPath: "contact",
      sixMonth: "Allowed",
      twelveMonth: "No",
      twentyfourMonth: "No",
      thirtysixMonth: "No",
    ),
    const InstallmentPeriodModel(
      methodPath: "valu",
      sixMonth: "Allowed",
      twelveMonth: "No",
      twentyfourMonth: "No",
      thirtysixMonth: "No",
    ),
  ];

  @override
  String get restorationId => 'paginated_installmentPeriod_table';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_rowIndex, 'current_row_index');

    if (!_initialized) {
      _installmentPeriodsDataSource = InstallmentPeriodDataSource(context, _installmentPeriods);
      _initialized = true;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _installmentPeriodsDataSource = InstallmentPeriodDataSource(context, _installmentPeriods);
      _initialized = true;
    }
  }

  @override
  void dispose() {
    _installmentPeriodsDataSource.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 275,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text("Installment Period", style: GoogleFonts.abel(fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Expanded(
            child: PaginatedDataTable2(
              availableRowsPerPage: const <int>[3],
              renderEmptyRowsInTheEnd: false,
              minWidth: 650,
              dataRowHeight: 60,
              showCheckboxColumn: false,
              showFirstLastButtons: true,
              hidePaginator: true,
              wrapInCard: true,
              initialFirstRowIndex: _rowIndex.value,
              columns: <DataColumn2>[for (final String column in _columns) DataColumn2(label: Text(column), fixedWidth: null, size: ColumnSize.L)],
              source: _installmentPeriodsDataSource,
              isHorizontalScrollBarVisible: false,
              isVerticalScrollBarVisible: false,
            ),
          )
        ],
      ),
    );
  }
}
