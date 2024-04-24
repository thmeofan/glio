import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../consts/app_colors.dart';
import '../../../util/app_routes.dart';

class IncomeTotalDisplay extends StatelessWidget {
  final double totalIncome;

  IncomeTotalDisplay({Key? key, required this.totalIncome}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: screenSize.height * 0.2,
        width: double.infinity,
        padding: EdgeInsets.all(
          screenSize.width * 0.03,
        ),
        decoration: BoxDecoration(
            color: AppColors.lightGreyColor,
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Personal Income',
            ),
            const SizedBox(height: 4),
            Text(
              '${totalIncome.toStringAsFixed(0)} \$',
            ),
          ],
        ),
      ),
    );
  }
}
