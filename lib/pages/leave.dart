import 'package:flutter/material.dart';
import 'package:rollcallapp/models/leavemodel.dart';
import 'package:rollcallapp/models/leavetypemodel.dart';
import 'package:rollcallapp/models/resultmodel.dart';
import 'package:rollcallapp/services/leaveservice.dart';
import 'package:rollcallapp/utils/utils.dart';

class LeavePage extends StatefulWidget {
  LeavePage({
    Key? key,
    this.username,
    this.regid,
    this.superid,
    this.emailid,
  }) : super(key: key);

  final String? username;
  final int? regid;
  final int? superid;
  final String? emailid;

  @override
  LeaveState createState() => new LeaveState();
}

class LeaveState extends State<LeavePage> {
  bool isLoading = false;
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  List<LeaveTypeModel>? _leaveTypes;
  LeaveTypeModel? selectedLeaveType;

  TextEditingController _stdatectrl = new TextEditingController();
  TextEditingController _enddatectrl = new TextEditingController();
  TextEditingController _commentsctrl = new TextEditingController();

  DateTime _date = new DateTime.now();
  Future<void> _selecStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: DateTime(2018),
        lastDate: DateTime(2050));

    if (picked != null) {
      setState(() {
        _stdatectrl.text = toyyyyMMdd(picked);
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: DateTime(2018),
        lastDate: DateTime(2050));

    if (picked != null) {
      setState(
        () {
          _enddatectrl.text = toyyyyMMdd(picked);
        },
      );
    }
  }

  Widget buildLeaveTypeControl() {
    if (_leaveTypes == null) {
      return Text('Leave Types');
    } else {
      return InputDecorator(
        decoration: InputDecoration(
          icon: Icon(Icons.build),
          labelText: "Leave type",
        ),
        isEmpty: selectedLeaveType == null,
        child: DropdownButtonHideUnderline(
          child: DropdownButton<LeaveTypeModel>(
            isDense: true,
            value: selectedLeaveType,
            onChanged: (LeaveTypeModel? newValue) {
              setState(() {
                selectedLeaveType = newValue;
              });
            },
            items: _leaveTypes!.map((LeaveTypeModel lvtype) {
              return DropdownMenuItem<LeaveTypeModel>(
                value: lvtype,
                child: Text(lvtype.leaveType != null ? lvtype.leaveType : ""),
              );
            }).toList(),
          ),
        ),
      );
    }
  }

  Widget buildStartDateControl() {
    return Column(
      children: <Widget>[
        ListTile(
          subtitle: Text("Start Date"),
          contentPadding: EdgeInsets.all(0.0),
          leading: Icon(Icons.calendar_today),
          title: Text(_stdatectrl.text),
          onTap: () {
            _selecStartDate(context);
          },
        )
      ],
    );
  }

  Widget buildEndDateControl() {
    return ListTile(
      contentPadding: EdgeInsets.all(0.0),
      leading: Icon(Icons.calendar_today),
      title: Text(_enddatectrl.text),
      subtitle: Text("End Date"),
      onTap: () {
        _selectEndDate(context);
      },
    );
  }

  Widget buildCommentsControl() {
    return TextFormField(
      decoration: InputDecoration(
        icon: Icon(Icons.note),
        hintText: "Comments",
        labelText: 'Comments',
      ),
      keyboardType: TextInputType.text,
      controller: _commentsctrl,
    );
  }

  void _clearForm() {
    String currentDate = toyyyyMMdd(DateTime.now());
    setState(
      () {
        selectedLeaveType = null;
        _stdatectrl.text = currentDate;
        _enddatectrl.text = currentDate;
        _commentsctrl.text = '';
      },
    );
  }

  void onSubmitLeave() {
    if (_formkey.currentState!.validate()) {
      setState(
        () {
          isLoading = true;
        },
      );
      LeaveModel leave = LeaveModel(
          superId: widget.superid!,
          regId: widget.regid!,
          leaveTypeId: selectedLeaveType!.id,
          startDate: DateTime.parse(_stdatectrl.text),
          endDate: DateTime.parse(_enddatectrl.text),
          comments: _commentsctrl.text, updatedBy: '');
      Future<ResultModel> leaveFuture = postLeave(leave);
      Future<Null> dialogFuture;
      leaveFuture.then(
        (result) {
          if (result.status) {
            _clearForm();
            dialogFuture = userDialog(context, result.successMessage, 'Ok');
          } else {
            dialogFuture = userDialog(context, result.errorMessage, 'Retry');
          }
          dialogFuture.then(
            (temp) {
              setState(
                () {
                  isLoading = false;
                },
              );
            },
          );
        },
      ).catchError(
        (error) {
          dialogFuture = userDialog(context, error.toString(), 'Try again');
          dialogFuture.then(
            (temp) {
              setState(
                () {
                  isLoading = false;
                },
              );
            },
          );
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();

    getLeaveTypes(widget.superid!).then(
      (lvtypes) {
        setState(
          () {
            _leaveTypes = lvtypes;
            if (lvtypes != null) {
              selectedLeaveType = lvtypes.elementAt(0);
            }
          },
        );
      },
    );

    setState(
      () {
        String currentDate = toyyyyMMdd(DateTime.now());
        _stdatectrl.text = currentDate;
        _enddatectrl.text = currentDate;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text("Leave Form"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: onSubmitLeave,
            tooltip: 'Save expense',
          ),
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.blueAccent,
              ),
            )
          : SafeArea(
              top: false,
              bottom: false,
              child: Form(
                key: _formkey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 10.0),
                    ),
                    buildLeaveTypeControl(),
                    buildStartDateControl(),
                    buildEndDateControl(),
                    buildCommentsControl(),
                  ],
                ),
              ),
            ),
    );
  }
}
