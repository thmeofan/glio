import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:glio/views/app/widgets/chosen_action_button_widget.dart';
import 'package:glio/views/operation/widgets/income_total_display_widget.dart';
import '../../../consts/app_colors.dart';
import '../../../consts/app_text_styles/home_screen_text_style.dart';
import '../../../consts/app_text_styles/operation_text_style.dart';

import '../../../util/shared_pref_service.dart';
import 'constructor_screen.dart';

class FinanceScreen extends StatefulWidget {
  @override
  _FinanceScreenState createState() => _FinanceScreenState();
}

class _FinanceScreenState extends State<FinanceScreen> {
  List<Map<String, dynamic>> operations = [];
  String _operationType = 'Income';
  double totalIncome = 0.0;

  @override
  void initState() {
    super.initState();
    _loadOperations();
  }

  List<bool> _isSelected = [true, false];

  void _toggleOperationType(int index) {
    setState(() {
      if (index == 0) {
        _operationType = 'Income';
        _isSelected = [true, false];
      } else {
        _operationType = 'Spendings';
        _isSelected = [false, true];
      }
    });
  }

  void _loadOperations() async {
    operations = await SharedPreferencesService.loadOperations();
    totalIncome = _calculateTotalIncome();
    setState(() {});
  }

  double _calculateTotalIncome() {
    return operations.fold(0, (sum, op) {
      final amount = op['amount'] as double;
      final type = op['type'] as String;

      if (type == 'Income') {
        return sum + amount;
      } else if (type == 'Spendings') {
        return sum - amount;
      } else {
        return sum;
      }
    });
  }

  void _addOperation(Map<String, dynamic> operation) async {
    setState(() {
      operations.add(operation);
    });
    await SharedPreferencesService.saveOperations(operations);
  }

  List<Map<String, dynamic>> get _filteredOperations {
    return operations.where((op) => op['type'] == _operationType).toList();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: AppColors.blackColor,
      ),
      body: Container(
        color: AppColors.blackColor,
        child: Column(
          children: <Widget>[
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                double width90Percent = constraints.maxWidth * 0.95;

                return Center(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    width: width90Percent,
                    child: Stack(
                      children: [
                        Center(
                          child: ToggleButtons(
                            isSelected: _isSelected,
                            onPressed: _toggleOperationType,
                            borderRadius: BorderRadius.circular(5.0),
                            selectedColor: AppColors.darkBlueColor,
                            fillColor: AppColors.darkBlueColor,
                            renderBorder: false,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: size.width * 0.14,
                                    vertical: size.height * 0.016),
                                decoration: BoxDecoration(
                                  color: _isSelected[0]
                                      ? AppColors.lightBlueColor
                                      : AppColors.darkBlueColor,
                                  borderRadius: _isSelected[0]
                                      ? BorderRadius.only(
                                          topRight: Radius.circular(5.0),
                                          bottomRight: Radius.circular(5.0),
                                        )
                                      : BorderRadius.circular(0.0),
                                ),
                                child: Text(
                                  'Income',
                                  style: TextStyle(
                                    color: _isSelected[0]
                                        ? AppColors.whiteColor
                                        : AppColors.whiteColor,
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: size.width * 0.125,
                                    vertical: size.height * 0.016),
                                decoration: BoxDecoration(
                                  color: _isSelected[1]
                                      ? AppColors.lightBlueColor
                                      : AppColors.darkBlueColor,
                                  borderRadius: _isSelected[1]
                                      ? BorderRadius.only(
                                          topLeft: Radius.circular(5.0),
                                          bottomLeft: Radius.circular(5.0),
                                        )
                                      : BorderRadius.circular(0.0),
                                ),
                                child: Text(
                                  'Spendings',
                                  style: TextStyle(
                                    color: _isSelected[1]
                                        ? AppColors.whiteColor
                                        : AppColors.whiteColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            SizedBox(
              height: size.height * 0.01,
            ),
            Expanded(
              child: _filteredOperations.isEmpty
                  ? Center(
                      child: Column(
                        children: [
                          SizedBox(
                            height: size.height * 0.03,
                          ),
                          SvgPicture.asset(
                            'assets/images/homescreen.svg',
                            width: size.width * 0.9,
                            //height: size.height * 0.3,
                          ),
                          SizedBox(
                            height: size.height * 0.02,
                          ),
                          Text(
                            'There\'s no info',
                            style: HomeScreenTextStyle.emptyTitle,
                          ),
                          SizedBox(
                            height: size.height * 0.01,
                          ),
                          Text(
                            'Add your incomes and expenses',
                            style: HomeScreenTextStyle.emptySubtitle,
                          ),
                          SizedBox(
                            height: size.height * 0.01,
                          ),
                        ],
                      ),
                    )
                  : CustomScrollView(
                      slivers: [
                        SliverToBoxAdapter(
                            child:
                                IncomeTotalDisplay(totalIncome: totalIncome)),
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.darkBlueColor,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: ListTile(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  tileColor: AppColors.lightGreyColor,
                                  title: Text(
                                    '\S ${_filteredOperations[index]['amount']} ',
                                    style: OperationTextStyle.tileSum,
                                  ),
                                  subtitle: Text(
                                    DateTime.now().toString().substring(0, 10),
                                    style: OperationTextStyle.date,
                                  ),
                                  trailing: Text(
                                    _filteredOperations[index]['description']
                                        .toString(),
                                    style: OperationTextStyle.tileSubtitle,
                                  ),
                                ),
                              ),
                            );
                          }, childCount: _filteredOperations.length),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: _filteredOperations.isEmpty
          ? ChosenActionButton(
              text: 'Add operation',
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ConstructorScreen()),
                );

                if (result != null) {
                  _addOperation(result);
                }
              },
            )
          : FloatingActionButton(
              backgroundColor: AppColors.lightBlueColor,
              shape: CircleBorder(),
              child: const Icon(
                Icons.add,
                color: AppColors.darkBlueColor,
              ),
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ConstructorScreen()),
                );

                if (result != null) {
                  _addOperation(result);
                }
              },
            ),
      floatingActionButtonLocation: _filteredOperations.isEmpty
          ? FloatingActionButtonLocation.centerFloat
          : FloatingActionButtonLocation.endFloat,
    );
  }
}
