import 'package:flutter/material.dart';
import 'package:personal_app/widgets/chart.dart';
import 'package:personal_app/widgets/text_field.dart';
import 'package:personal_app/widgets/transaction_list.dart';
import './models/transaction.dart';
import 'widgets/chart.dart';
import 'dart:ui';
 
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  static const MaterialColor expense = MaterialColor(_expensePrimaryValue, <int, Color>{
  50: Color(0xFFFBE1E5),
  100: Color(0xFFF5B4BE),
  200: Color(0xFFEE8293),
  300: Color(0xFFE74F67),
  400: Color(0xFFE22A47),
  500: Color(_expensePrimaryValue),
  600: Color(0xFFD90322),
  700: Color(0xFFD4031C),
  800: Color(0xFFCF0217),
  900: Color(0xFFC7010D),
});
static const int _expensePrimaryValue = 0xFFDD0426;

static const MaterialColor expenseAccent = MaterialColor(_expenseAccentValue, <int, Color>{
  100: Color(0xFFFFEFEF),
  200: Color(_expenseAccentValue),
  400: Color(0xFFFF898C),
  700: Color(0xFFFF6F73),
});
static const int _expenseAccentValue = 0xFFFFBCBE;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kişisel Harcamalar',
      theme: ThemeData(
        primarySwatch: expense,
        accentColor: Colors.lightBlue,
        fontFamily: 'Quicksand',
        appBarTheme: AppBarTheme( 
          textTheme: ThemeData.light().textTheme.copyWith(headline6: const TextStyle(fontFamily:'OpenSans', fontWeight: FontWeight.bold)),
        )
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _transactions = [
    // Transaction(
    //     id: 't1', title: 'Prezarvatif', amount: 20.00, date: DateTime.now()),
    // Transaction(
    //   id: 't2',
    //   title: '240V FUCK MASTER PRO',
    //   amount: 331.31,
    //   date: DateTime.now(),
    // ),
  ];

  List<Transaction> get _recentTransactions{
    return _transactions.where((tx) {
      return tx.date.isAfter(DateTime.now().subtract(const Duration(days: 7),));
    }).toList();
  }

  void _addTransaction(String txTitle, double txAmount, DateTime chosenDate) {
    final newTx = Transaction(
      title: txTitle,
      amount: txAmount,
      date: chosenDate,
      id: DateTime.now().toString(),
    );
    setState(() {
      _transactions.add(newTx);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: NewTransaction(_addTransaction),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  void _deleteTransaction(String id) {
    setState(() {
      _transactions.removeWhere((element) => element.id == id
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Harcama Tablosu', style: TextStyle(fontFamily: 'Open Sans')),
        actions: [
          IconButton(
            onPressed: () {
              _startAddNewTransaction(context);
            },
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Chart(_recentTransactions),
            TransactionList(_transactions, _deleteTransaction)
            ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          _startAddNewTransaction(context);
        },
      ),
    );
  }
}
