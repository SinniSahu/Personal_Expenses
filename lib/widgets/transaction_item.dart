import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';

class TransactionItem extends StatelessWidget {

  final Transaction transaction;
  final Function deletetx;

  const TransactionItem({
    Key key,
    @required this.transaction,
    @required this.deletetx,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(
        vertical: 6,
        horizontal: 17,
      ),
      child: ListTile(
        leading: CircleAvatar(
         // backgroundColor: Theme.of(context).accentColor,
          radius: 30,
          child: Padding(
            padding: EdgeInsets.all(6),
            child: FittedBox(
              child: Text(
                '₹${transaction.amount.toStringAsFixed(2)}', // toStringAsFixed(integer x) upto x decimal place
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                 // color: Theme.of(context).textTheme.subtitle1,
                ),
              ),
            ),
          ),
        ),
        title: Text(
          transaction.title,
          style: Theme.of(context).textTheme.subtitle1,
        ),
        subtitle: Text(
          DateFormat.yMMMEd().format(transaction.date),
        ),
        trailing: MediaQuery.of(context).size.width > 460 
        ? TextButton(
          child: TextButton.icon(
            onPressed: () => deletetx(transaction.id), 
            icon: Icon(Icons.delete), 
            label: Text('Delete'),
            style: TextButton.styleFrom(primary: Theme.of(context).errorColor),
            ),
          onPressed: () => deletetx(transaction.id),
          )
        : IconButton(
          icon: Icon(Icons.delete),
          color: Theme.of(context).errorColor,
          onPressed: () => deletetx(transaction.id),
        ),
      ),
    );
  }
}
