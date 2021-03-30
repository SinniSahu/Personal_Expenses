import 'dart:io';

import 'package:flutter/cupertino.dart';  // for IOS 
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

import './widgets/chart.dart';
import './widgets/new_transaction.dart';
import './widgets/transaction_list.dart';
import './models/transaction.dart';

void main() {
  // to keep app always in portrait mode
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown,
  // ]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expenses',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        accentColor: Colors.deepPurpleAccent,
        errorColor: Colors.red.shade600,
        fontFamily: 'OpenSans',
        textTheme: ThemeData.light().textTheme.copyWith(
          subtitle1: TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 17,
            fontWeight: FontWeight.w400,
          ),
          button: TextStyle(
            color: Colors.white,
          ),
        ),
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
            subtitle1: TextStyle(
              fontFamily: 'Quicksand',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white
            ),
          ),
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => _MyHomePageState();

}

class _MyHomePageState extends State<MyHomePage> {

    final List<Transaction> _userTransaction = [
    //   Transaction(
    //   id: 't1',
    //   title: 'Shoes',
    //   amount: 250,
    //   date: DateTime.now(),
    // ),
    // Transaction(
    //   id: 't2',
    //   title: 'Tshirt 13',
    //   amount: 300,
    //   date: DateTime.now(),
    // ),
    
  ];

  bool _showChart = false;

  List<Transaction> get _recentTransactions {
    return _userTransaction.where((tx) {
      return tx.date.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  void _addNewTransaction(String txTitle, double txAmount, DateTime chosenDate){
    final newTx = Transaction(
      id: DateTime.now().toString(), 
      title: txTitle, 
      amount: txAmount, 
      date: chosenDate,
      );

    setState((){
      _userTransaction.add(newTx);
   });

  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransaction.removeWhere((tx) => tx.id == id);
    
    });
  }


  void _startAddNewTransaction(BuildContext ctx){
    showModalBottomSheet(
      context: ctx, 
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: NewTransaction(_addNewTransaction),
          behavior: HitTestBehavior.opaque,  // avoid to close sheet when taping it
          );
      },
      );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context); // to prevent repeatative use of this object - optimisation

    final isLandscape = mediaQuery.orientation == Orientation.landscape; 

// AppBar stored in variable so that is globally accessable, to adjust height of container dynamically
    final PreferredSizeWidget appbar = Platform.isIOS 
      ? CupertinoNavigationBar(
        middle: Text('Personal Expenses'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            GestureDetector(
              child: Icon(CupertinoIcons.add),
              onTap: () => _startAddNewTransaction(context),
            ),
          ],
        ),
        )
      : AppBar(
          //textTheme: Theme.of(context).appBarTheme.textTheme,
          title: Text(
            'Personal Expenses',
           style: Theme.of(context).appBarTheme.textTheme.subtitle1,
          ),
          
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add), 
              onPressed: () => _startAddNewTransaction(context)
              ),
          ],
        );


    final txListWidget = Container(
                height: (mediaQuery.size.height 
                          - appbar.preferredSize.height 
                          - mediaQuery.padding.top) * 0.72,
                child: TransactionList(_userTransaction, _deleteTransaction),
                ); 
            
    final pageBody = SafeArea(child: SingleChildScrollView(
            child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[

              if(!isLandscape) Container(
                height: (mediaQuery.size.height - appbar.preferredSize.height - mediaQuery.padding.top)*0.28,
                child: Chart(_recentTransactions),
                ),
              if(!isLandscape) txListWidget, 

              if(isLandscape)
               Row( 
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                Text('Show Chart'),
                Switch.adaptive(
                  //activeColor: Theme.of(context).accentColor,
                  value: _showChart, 
                  onChanged: (val) {
                  setState(() {
                    _showChart = val;
                  });
                }),
              ],
              ),
              if(isLandscape)
               _showChart 
              ? Container(
                height: (mediaQuery.size.height - appbar.preferredSize.height - mediaQuery.padding.top)*0.7,
                child: Chart(_recentTransactions),
                )
              : txListWidget
              ],
          ),
        ) );

    return Platform.isIOS 
    ? CupertinoPageScaffold(
      child: pageBody,) 

    : Scaffold(
        appBar: appbar,
        body: pageBody,

        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Platform.isIOS 
        ? Container() 
        : FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: ()=> _startAddNewTransaction(context),
          ),
        );
  }
}
