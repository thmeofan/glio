import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../consts/app_colors.dart';

class IncomeTotalDisplay extends StatelessWidget {
  final double totalIncome;

  IncomeTotalDisplay({Key? key, required this.totalIncome}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: screenSize.height * 0.15,
        width: double.infinity,
        padding: EdgeInsets.all(
          screenSize.width * 0.03,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.greenColor,
              AppColors.lightBlueColor,
            ],
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'Hello!',
                  style: TextStyle(
                      color: AppColors.whiteColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 17),
                ),
                Spacer(),
                const Text(
                  'Your Income',
                  style: TextStyle(
                      color: AppColors.whiteColor,
                      fontWeight: FontWeight.w400,
                      fontSize: 14),
                ),
                SizedBox(height: screenSize.height * 0.005),
                Text(
                  '\$ ${totalIncome.toStringAsFixed(0)}',
                  style: const TextStyle(
                      color: AppColors.lightBlueColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 15),
                ),
              ],
            ),
            Spacer(),
            SvgPicture.asset('assets/images/money.svg'),
            SizedBox(
              width: screenSize.width * 0.01,
            ),
          ],
        ),
      ),
    );
  }
}
