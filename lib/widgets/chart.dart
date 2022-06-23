import 'package:flutter/material.dart';
import 'package:personal_app/models/transaction.dart';
import 'package:intl/intl.dart';
import 'chart_bar.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'dart:ui';
class Chart extends StatelessWidget {
  // const Chart({Key? key}) : super(key: key);
  final List<Transaction> recentTransactions;
  Chart(this.recentTransactions);

  List<Map<String, dynamic>> get groupedTransactionValues {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(
        Duration(days: index),
      );
      var totalSum = 0.0;

      for (int i = 0; i < recentTransactions.length; i++) {
        if (recentTransactions[i].date.day == weekDay.day &&
            recentTransactions[i].date.month == weekDay.month &&
            recentTransactions[i].date.year == weekDay.year) {
          totalSum += recentTransactions[i].amount;
        }
      }

      return {
        'day': Intl.withLocale('tr', () => DateFormat.E().format(weekDay)),
        'amount': totalSum
      };
    }).reversed.toList();
  }

  double get totalSpending {
    return groupedTransactionValues.fold(0.0, (sum, item) {
      return sum + (item['amount'] as double);
    });
  }
  
  @override
  Widget build(BuildContext context) {
  initializeDateFormatting('tr');
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: Flexible(
        fit: FlexFit.tight,
        child: Padding(
          padding:const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: groupedTransactionValues.map((data) {
              return ChartBar(data['day'].toString(), (data['amount'] as double),
                  totalSpending == 0.0 ? 0.0 : (data['amount'] as double) / totalSpending);
            }).toList(),
          ),
        ),
      ),
    );
  }
}
