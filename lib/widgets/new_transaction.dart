import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function addTx;

  NewTransaction(this.addTx);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleControler = TextEditingController();
  final _amountControler = TextEditingController();
  DateTime _selectedDate;

  void _submitData() {
    final enteredTitle = _titleControler.text;
    final enteredAmt = double.parse(_amountControler.text) ;

    if(enteredTitle.isEmpty || enteredAmt <= 0 || _selectedDate == null)
      return;

    widget.addTx(
      enteredTitle,
      enteredAmt,
      _selectedDate,
      );

      Navigator.of(context).pop();  // closes sheet after submitting
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context, 
      initialDate: DateTime.now(), 
      firstDate: DateTime(2021), 
      lastDate: DateTime.now(),
      ).then((pickedDate) {
        if(pickedDate == null)
          return;
        setState(() {
           _selectedDate = pickedDate;
        });
       
      }
      );

  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
          child: Card(
                elevation: 5,
                child: Container(
                  //height: 400,
                  padding: EdgeInsets.only(
                    top: 10, 
                    left: 10, 
                    right: 10, 
                    bottom: MediaQuery.of(context).viewInsets.bottom + 10,
                    ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      TextField(
                        decoration: InputDecoration(labelText: 'Title',), 
                        controller: _titleControler,
                        onSubmitted: (_) => _submitData,
                      ),
                      TextField(
                        decoration: InputDecoration(labelText: 'Amount',),
                        controller: _amountControler,
                        keyboardType: TextInputType.number,
                        onSubmitted: (_) => _submitData,
                      ),
                      Container(
                        height: 70, 
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(_selectedDate == null ? 'No Date Chosen!' : 'Picked Date: ${DateFormat.yMd().format(_selectedDate)}')),
                            TextButton(
                              onPressed: _presentDatePicker, 
                              child: Text(
                                'Choose Date', 
                                style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              style: TextButton.styleFrom(primary: Theme.of(context).primaryColor),
                              ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: _submitData,
                        child: Text('Add Transaction'),
                        //style: TextButton.styleFrom(primary: Colors.indigoAccent.shade700),
                        )
                    ],
                  ),
                ),
              ),
    );
  }
}