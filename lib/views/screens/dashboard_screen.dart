import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:web_admin/constants/dimens.dart';
import 'package:web_admin/generated/l10n.dart';
import 'package:web_admin/theme/theme_extensions/app_button_theme.dart';
import 'package:web_admin/theme/theme_extensions/app_color_scheme.dart';
import 'package:web_admin/theme/theme_extensions/app_data_table_theme.dart';
import 'package:web_admin/views/widgets/card_elements.dart';
import 'package:web_admin/views/widgets/portal_master_layout/portal_master_layout.dart';

import '../../app_router.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _totalcards=0,_totalsms=0;
  final _dataTableHorizontalScrollController = ScrollController();

  @override
  void dispose() {
    _dataTableHorizontalScrollController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    getCardsCount();
    getSmsCount();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final lang = Lang.of(context);
    final themeData = Theme.of(context);
    final appColorScheme = Theme.of(context).extension<AppColorScheme>()!;
    final appDataTableTheme = Theme.of(context).extension<AppDataTableTheme>()!;
    final size = MediaQuery.of(context).size;

    final summaryCardCrossAxisCount = (size.width >= kScreenWidthLg ? 4 : 2);
    final goRouter = GoRouter.of(context);

    return PortalMasterLayout(
      body: ListView(
        padding: const EdgeInsets.all(kDefaultPadding),
        children: [
          Text(
            lang.dashboard,
            style: themeData.textTheme.headlineMedium,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final summaryCardWidth = ((constraints.maxWidth - (kDefaultPadding * (summaryCardCrossAxisCount - 1))) / summaryCardCrossAxisCount);

                return Wrap(
                  direction: Axis.horizontal,
                  spacing: kDefaultPadding,
                  runSpacing: kDefaultPadding,
                  children: [
                    FutureBuilder<int>(
                      future: getUsersCount(),
                      initialData: 0,
                      builder: (context, snapshot) {
                        return SummaryCard(
                          onTap: () => goRouter.go(RouteUri.users),
                          title: lang.newUsers(2),
                          value: snapshot.data != null ? '${snapshot.data}' : '0',
                          icon: Icons.group_rounded,
                          backgroundColor: appColorScheme.warning,
                          textColor: appColorScheme.buttonTextBlack,
                          iconColor: Colors.black12,
                          width: summaryCardWidth,
                        );
                      }
                    ),
                    SummaryCard(
                      onTap: () => goRouter.go(RouteUri.users),
                      title: lang.allCards(2),
                      value: '$_totalcards',
                      icon: Icons.credit_card_rounded,
                      backgroundColor: appColorScheme.info,
                      textColor: themeData.colorScheme.onPrimary,
                      iconColor: Colors.black12,
                      width: summaryCardWidth,
                    ),
                    SummaryCard(
                      onTap:() => goRouter.go(RouteUri.users),
                      title: lang.allsms(2),
                      value: '$_totalsms',
                      icon: Icons.sms_rounded,
                      backgroundColor: appColorScheme.success,
                      textColor: themeData.colorScheme.onPrimary,
                      iconColor: Colors.black12,
                      width: summaryCardWidth,
                    ),
                  ],
                );
              },
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.only(bottom: kDefaultPadding),
          //   child: Card(
          //     clipBehavior: Clip.antiAlias,
          //     child: Column(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: [
          //         CardHeader(
          //           title: lang.recentOrders(2),
          //           showDivider: false,
          //         ),
          //         SizedBox(
          //           width: double.infinity,
          //           child: LayoutBuilder(
          //             builder: (context, constraints) {
          //               final double dataTableWidth = max(kScreenWidthMd, constraints.maxWidth);
          //
          //               return Scrollbar(
          //                 controller: _dataTableHorizontalScrollController,
          //                 thumbVisibility: true,
          //                 trackVisibility: true,
          //                 child: SingleChildScrollView(
          //                   scrollDirection: Axis.horizontal,
          //                   controller: _dataTableHorizontalScrollController,
          //                   child: SizedBox(
          //                     width: dataTableWidth,
          //                     child: Theme(
          //                       data: themeData.copyWith(
          //                         cardTheme: appDataTableTheme.cardTheme,
          //                         dataTableTheme: appDataTableTheme.dataTableThemeData,
          //                       ),
          //                       child: DataTable(
          //                         showCheckboxColumn: false,
          //                         showBottomBorder: true,
          //                         columns: const [
          //                           DataColumn(label: Text('No.'), numeric: true),
          //                           DataColumn(label: Text('Date')),
          //                           DataColumn(label: Text('Item')),
          //                           DataColumn(label: Text('Price'), numeric: true),
          //                         ],
          //                         rows: List.generate(5, (index) {
          //                           return DataRow.byIndex(
          //                             index: index,
          //                             cells: [
          //                               DataCell(Text('#${index + 1}')),
          //                               const DataCell(Text('2022-06-30')),
          //                               DataCell(Text('Item ${index + 1}')),
          //                               DataCell(Text('${Random().nextInt(10000)}')),
          //                             ],
          //                           );
          //                         }),
          //                       ),
          //                     ),
          //                   ),
          //                 ),
          //               );
          //             },
          //           ),
          //         ),
          //         Align(
          //           alignment: Alignment.center,
          //           child: Padding(
          //             padding: const EdgeInsets.all(kDefaultPadding),
          //             child: SizedBox(
          //               height: 40.0,
          //               width: 120.0,
          //               child: ElevatedButton(
          //                 onPressed: () {},
          //                 style: themeData.extension<AppButtonTheme>()!.infoElevated,
          //                 child: Row(
          //                   mainAxisSize: MainAxisSize.min,
          //                   crossAxisAlignment: CrossAxisAlignment.start,
          //                   children: [
          //                     Padding(
          //                       padding: const EdgeInsets.only(right: kDefaultPadding * 0.5),
          //                       child: Icon(
          //                         Icons.visibility_rounded,
          //                         size: (themeData.textTheme.labelLarge!.fontSize! + 4.0),
          //                       ),
          //                     ),
          //                     const Text('View All'),
          //                   ],
          //                 ),
          //               ),
          //             ),
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  Future<int> getUsersCount() async {
    int count=0;
    await FirebaseFirestore.instance
        .collection("users").count().get().then((value) {
      count = value.count;
    });
    return count;
  }

  getCardsCount() async {
    await FirebaseFirestore.instance
        .collection("users").get().then((value) {

      value.docs
          .asMap()
          .entries
          .forEach((e) async {
              QuerySnapshot<Map<String, dynamic>> subcountq = await FirebaseFirestore.instance
                  .collection("users").doc(e.value.id).collection('UserCard').get();
              final int documents = subcountq.docs.length;


              setState(() {
                _totalcards = _totalcards + documents;
              });
      });

    });

  }

  getSmsCount() async {
    await FirebaseFirestore.instance
        .collection("users").get().then((value) {

      value.docs
          .asMap()
          .entries
          .forEach((e) async {
        QuerySnapshot<Map<String, dynamic>> subcountq = await FirebaseFirestore.instance
            .collection("users").doc(e.value.id).collection('UserSMS').get();
        final int documents = subcountq.docs.length;

        setState(() {
          _totalsms = _totalsms + documents;
        });
      });
    });

  }
}

class SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color backgroundColor;
  final Color textColor;
  final Color iconColor;
  final double width;
  final GestureTapCallback onTap;

  const SummaryCard({
    Key? key,
    required this.title,
    required this.value,
    required this.icon,
    required this.backgroundColor,
    required this.textColor,
    required this.iconColor,
    required this.width,
    required this.onTap
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: 120.0,
        width: width,
        child: Card(
          clipBehavior: Clip.antiAlias,
          color: backgroundColor,
          child: Stack(
            children: [
              Positioned(
                top: kDefaultPadding * 0.5,
                right: kDefaultPadding * 0.5,
                child: Icon(
                  icon,
                  size: 80.0,
                  color: iconColor,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(kDefaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: kDefaultPadding * 0.5),
                      child: Text(
                        value,
                        style: textTheme.headlineMedium!.copyWith(
                          color: textColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Text(
                      title,
                      style: textTheme.labelLarge!.copyWith(
                        color: textColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
