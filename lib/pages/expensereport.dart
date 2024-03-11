import 'package:flutter/material.dart';
import 'package:rollcallapp/common/rest.service.dart';
import 'package:rollcallapp/models/regexpense.dart';
import 'package:rollcallapp/models/usermodel.dart';
import 'package:rollcallapp/pages/widgets/menulistview.dart';

class ExpenseReport extends StatefulWidget {
  final UserModel userdata;
  ExpenseReport({Key? key, required this.userdata}) : super(key: key);
  @override
  _ExpenseReportState createState() => _ExpenseReportState();
}

class _ExpenseReportState extends State<ExpenseReport> {
  bool isLoading = false;
  RestService rest = RestService();
  String status = "Please wait";
  List<RegExpense> _regexpense=[];

  void loadRegExpense() {
    this
        .rest
        .getRegExpenses(widget.userdata.superId, widget.userdata.registrationId)
        .then((data) {
      setState(() {
        this._regexpense = data;
      });
    }).catchError((error) {});
  }

  @override
  void initState() {
    isLoading = true;
    super.initState();
    loadRegExpense();
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("Expense Report"),
      ),
      drawer: new Drawer(
        child: new MenuListView(),
      ), 
      body: _loadData(),
    );
  }

  Widget _loadData() {
    if (this._regexpense == null) {
      return new Container(
          child: Center(
        child: Text(
          "Loading...",
          style: TextStyle(color: Colors.indigo, fontSize: 20.0),
        ),
      ));
    }
    return ListView.builder(
      itemCount: this._regexpense.length,
      itemBuilder: (context, index) {
        return SingleExpense(
            index: index,
            regExpense: this._regexpense[index],
            userdata: widget.userdata);
      },
    );
  }
}

class SingleExpense extends StatefulWidget {
  final RegExpense? regExpense;
  final int? index;
  final UserModel? userdata;
  SingleExpense(
      {@required this.regExpense,
      @required this.index,
      @required this.userdata});

  @override
  _SingleExpenseState createState() => _SingleExpenseState();
}

class _SingleExpenseState extends State<SingleExpense> {
  // void _navigateToExpensePage() {
  //   Navigator.of(context).pop();
  //   Navigator.of(context).push(MaterialPageRoute(
  //       builder: (BuildContext context) => ExpensePage(
  //             userdata: widget.userdata,
  //             regexp: widget.regExpense,
  //             isEdit: true,
  //           )));
  // }

  @override
  Widget build(BuildContext context) {
    if (widget.regExpense!.id! > 0) {
      return Card(
        child: ListTile(
          leading: new CircleAvatar(
            backgroundColor: Theme.of(context).primaryColor,
            child: new Text(
              (widget.index! + 1).toString(),
            ),
          ),
          title: new Text(widget.regExpense!.expenseDate!),
          subtitle: new Column(
            children: <Widget>[
              new Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: new Text("Type:"),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: new Text(
                      widget.regExpense!.expenseType!,
                      style: TextStyle(color: Colors.indigo),
                    ),
                  ),
                ],
              ),
              new Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: new Text("Reason:"),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: new Text(
                      widget.regExpense!.reason!,
                      style: TextStyle(color: Colors.indigo),
                    ),
                  ),
                ],
              ),
              
              new Container(
                alignment: Alignment.topLeft,
                child: new Text(
                  "\u20B9${(widget.regExpense!.amount)}",
                  style: TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo),
                ),
              ),
            ],
          ),
          // onTap: () {
          //   if (!widget.regExpense.approved) {
          //     _navigateToExpensePage();
          //   }
          // },
        ),
      );
    } else {
      return new Container();
    }
  }
}
