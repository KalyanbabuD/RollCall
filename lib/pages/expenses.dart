import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rollcallapp/common/common.util.dart';
import 'package:rollcallapp/common/props.dart';
import 'package:rollcallapp/common/rest.service.dart';
import 'package:rollcallapp/models/ExpenseType.dart';
import 'package:rollcallapp/models/regexpense.dart';
import 'package:rollcallapp/models/usermodel.dart';
import 'package:rollcallapp/pages/widgets/menulistview.dart';

class ExpensePage extends StatefulWidget {
  final UserModel? userdata;
  final bool? isEdit;
  final RegExpense? regexp;
  ExpensePage({Key? key,  this.userdata,  this.isEdit, this.regexp})
      : super(key: key);
  @override
  _ExpensePageState createState() => _ExpensePageState();
}

class _ExpensePageState extends State<ExpensePage> {
  bool isLoading = false;
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  RestService rest = RestService();
  TextEditingController _amount = new TextEditingController();
  TextEditingController _reson = new TextEditingController();
  TextEditingController _expdatectrl = new TextEditingController();
  TextEditingController _referencesId = new TextEditingController();
  DateTime _date = new DateTime.now();
  String status = "Please wait";
  bool? _validateAmount;
  bool? _validateExpdate;
  var upfile;
  List<ExpenseType>? exptype;
  ExpenseType? selectedExpType;
  String? stdate;

  @override
  void initState() {
    isLoading = true;
    super.initState();
    loadexptypes();
    setState(() {
      String currentDate = CommonUtil.toddMMyyyy(DateTime.now());
      _expdatectrl.text = currentDate;
      this.stdate = CommonUtil.toyyyyMMdd(DateTime.now());
    });
    if (widget.isEdit!) {
      loadEditData(widget.regexp!);
    }
    
    isLoading = false;
  }

  void loadEditData(RegExpense reg) {
    _amount.text = reg.amount.toString();
    _expdatectrl.text = reg.expenseDate!;
    stdate = reg.expenseDate;
    _reson.text = reg.reason!;
    _referencesId.text = reg.referenceId!;
  }

  void loadexptypes(){
    rest.getExpensesType(widget.userdata!.superId!).then((value){
      if(value!=null){
        setState(() {
          this.exptype = value;
        });
      }{
        //CommonUtil.showAlertDialog(context, true, "Alert", "Expense type are not availble!", "OK");
      }
    }).catchError((error){

    });
  }

  void _clearForm() {
    _amount.text = "";
    String currentDate = CommonUtil.toddMMyyyy(DateTime.now());
    _expdatectrl.text = currentDate;
    stdate = CommonUtil.toyyyyMMdd(DateTime.now());
    _reson.text = "";
    _referencesId.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Expense Form"),
        actions: <Widget>[],
      ),
      drawer: new Drawer(
        child: new MenuListView(),
      ),
      body: Stack(
        children: buildStackWidgets(),
      ),
    );
  }

  Future<void> _selecExpDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
            context: context,
            initialDate: _date,
            firstDate: DateTime(2018),
            lastDate: DateTime(2050))
        .catchError((error) {
      isLoading = false;
      CommonUtil.showAlertDialog(
          context, false, "Date selection failed!", error.toString(), "OK");
    });

    if (picked != null) {
      setState(() {
        _expdatectrl.text = CommonUtil.toddMMyyyy(picked);
        stdate = CommonUtil.toyyyyMMdd(picked);
      });
    }
  }

  // Widget buildExpenseTypeControl() {
  //   if (_leaveTypes == null) {
  //     isLoading = false;
  //     return Text('Leave Types');
  //   } else {
  //     return InputDecorator(
  //       decoration: InputDecoration(
  //         icon: Icon(Icons.build,color: Theme.of(context).primaryColor,),
  //         labelText: "Leave Type",
  //       ),
  //       isEmpty: selectedLeaveType == null,
  //       child: DropdownButtonHideUnderline(
  //         child: DropdownButton<LeaveTypeModel>(
  //           isDense: true,
  //           value: selectedLeaveType,
  //           onChanged: (LeaveTypeModel newValue) {
  //             setState(() {
  //               selectedLeaveType = newValue;
  //             });
  //           },
  //           items: _leaveTypes.map((LeaveTypeModel lvtype) {
  //             return DropdownMenuItem<LeaveTypeModel>(
  //               value: lvtype,
  //               child: Text(lvtype.leaveType != null ? lvtype.leaveType : ""),
  //             );
  //           }).toList(),
  //         ),
  //       ),
  //     );
  //   }
  // }

  List<Widget> buildStackWidgets() {
    var list = <Widget>[];
    list.add(SafeArea(
      top: false,
      bottom: false,
      child: Form(
        key: _formkey,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: Prop.defaultPadding),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
            ),
            Form(
              // ignore: deprecated_member_use
              //autovalidate: true,
              autovalidateMode: AutovalidateMode.always,
              child: Column(
                children: <Widget>[
                  buildExpenseTypeControl(),
                  buildExpenseAmount(),
                  buildExpenseDate(),
                  buildExpenseReson(),
                  buildExpenseReferences(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
            ),
            // GestureDetector(
            //   onTap: () {
            //     if (widget.isEdit) {
            //       onExpenseUpdateClick();
            //     } else {
            //       onExpenseAddClick();
            //     }
            //   },
            //   child: Container(
            //     padding: EdgeInsets.all(10.0),
            //     alignment: Alignment.center,
            //     decoration: BoxDecoration(
            //         shape: BoxShape.rectangle, color: Colors.grey),
            //     child: Column(
            //       children: <Widget>[
            //         Text(
            //           widget.isEdit == true ? 'Update Expense' : 'Add file',
            //           style: TextStyle(color: Colors.white, fontSize: 15.0),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            GestureDetector(
              onTap: () {
                if (widget.isEdit!) {
                  onExpenseUpdateClick();
                } else {
                  onExpenseAddClick();
                }
                
              },
              child: Container(
                padding: EdgeInsets.all(10.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Theme.of(context).primaryColor),
                child: Column(
                  children: <Widget>[
                    Text(
                      widget.isEdit == true
                          ? 'Update Expense'
                          : 'Apply Expense',
                      style: TextStyle(color: Colors.white, fontSize: 15.0),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ));
    if (isLoading) {
      list.add(loaderWidget('Loading..wait..'));
    }
    return list;
  }

  Widget buildExpenseTypeControl() {
    if (exptype == null) {
      isLoading = false;
      return Text('Expense Types');
    } else {
      return InputDecorator(
        decoration: InputDecoration(
          icon: Icon(Icons.build,color: Theme.of(context).primaryColor,),
          labelText: "Expense Type",
        ),
        isEmpty: selectedExpType== null,
        child: DropdownButtonHideUnderline(
          child: DropdownButton<ExpenseType>(
            isDense: true,
            value: selectedExpType,
            onChanged: (ExpenseType? newValue) {
              setState(() {
                selectedExpType = newValue;
              });
            },
            items: exptype?.map((ExpenseType extype) {
              return DropdownMenuItem<ExpenseType>(
                value: extype,
                child: Text(extype.name != null ? extype.name : ""),
              );
            }).toList(),
          ),
        ),
      );
    }
  }

  Future getImage() async {
    // ignore: deprecated_member_use
    var img = await ImagePicker();
    img..pickImage(source: ImageSource.gallery);
    setState(() {
      this.upfile = img;
    });
  }

  Widget buildExpenseAmount() {
    return TextFormField(
      decoration: InputDecoration(
        icon: Icon(Icons.attach_money, color: Theme.of(context).primaryColor),
        labelText: 'Amount.',
        fillColor: Colors.white,
        //errorText: _validateAmount ? 'Amount Can\'t Be Empty' : null,
      ),
      keyboardType: TextInputType.number,
      controller: _amount,
    );
  }

  Widget buildExpenseDate() {
    return ListTile(
      subtitle: Text("Expense Date"),
      contentPadding: EdgeInsets.all(0.0),
      leading: Icon(Icons.date_range, color: Theme.of(context).primaryColor),
      title: Text(_expdatectrl.text),
      onTap: () {
        _selecExpDate(context);
      },
    );
  }

  Widget buildExpenseReson() {
    return TextFormField(
      decoration: InputDecoration(
        icon: Icon(Icons.note, color: Theme.of(context).primaryColor),
        labelText: 'Reason',
        fillColor: Colors.white,
      ),
      obscureText: false,
      keyboardType: TextInputType.text,
      controller: _reson,
    );
  }

  Widget buildExpenseReferences() {
    return TextFormField(
      decoration: InputDecoration(
        icon: Icon(Icons.report, color: Theme.of(context).primaryColor),
        labelText: 'References',
        fillColor: Colors.white,
      ),
      obscureText: false,
      keyboardType: TextInputType.text,
      controller: _referencesId,
    );
  }

  void _showLoader(bool show, {String? status}) {
    setState(() {
      isLoading = show;
      if (status != null) this.status = status;
    });
  }

  void _updateStatus(String status) {
    setState(() {
      this.status = status;
    });
  }

  void onExpenseAddClick() {
    setState(() {
      this.isLoading=false;
    });
    setState(() {
      this._amount.text.isEmpty
          ? _validateAmount = true
          : _validateAmount = false;
      this._expdatectrl.text.isEmpty
          ? _validateExpdate = true
          : _validateExpdate = false;
    });
    if (_validateAmount!) {
      CommonUtil.showAlertDialog(
          context, true, "Alert", "Please add amount and try again!", "OK");
      return;
    } else if (_validateExpdate!) {
      CommonUtil.showAlertDialog(
          context, true, "Alert", "Please add date and try again!", "OK");
      return;
    }

    CommonUtil.checkInternet().then((result) {
      _showLoader(true, status: "Please wait..");
      RegExpense reg = prepareRegExpense();
      rest.saveExpense(reg).then((loginuser) {
        if (loginuser != null && loginuser.result) {
             _clearForm();
            _showLoader(false);
          CommonUtil.showAlertDialog(
              context, true, "Message", "Expense added successfully!", "");
          // if (this.upfile != null) {
          //   _clearForm();
          //   this.isLoading=false;
          // CommonUtil.showAlertDialog(
          //     context, true, "Message", "Expense added successfully!", "");
            // rest.uploadProfileImage(
            //         this.upfile,
            //         widget.userdata.superId,
            //         widget.userdata.registrationId,
            //         widget.userdata.registrationId)
            //     .then((value) {
            //   if (value != null && value != "") {
            //     _showLoader(false);
            //     _clearForm();
            //     CommonUtil.showAlertDialog(context, true, "Message",
            //         "file added successfully!", "");
            //   } else {
            //     _showLoader(false);
            //     _clearForm();
            //     CommonUtil.showAlertDialog(context, true, "Message",
            //         "File Failed!", "");
            //   }
            // }).catchError((error) {
            //   _showLoader(false);
            //   _clearForm();
            //   CommonUtil.showAlertDialog(
            //       context, true, "Error", error.toString(), "OK");
            // });
          // }else{
          //    _showLoader(false);
          // _clearForm();
          // CommonUtil.showAlertDialog(
          //     context, true, "Message", "Expense added successfully!", "");
          // }         
        } else {
          _showLoader(false);
          CommonUtil.showAlertDialog(
              context, true, "Alert", loginuser.successmesage == null?"":loginuser.successmesage, "OK");
        }
      }).catchError((error) {
        _showLoader(false);
        CommonUtil.showAlertDialog(
            context, true, "Alert", error.toString(), "");
      });
    }).catchError((error) {
      _updateStatus("Please chek your internet connection.");
      Future.delayed(Duration(seconds: 2), () {
        _showLoader(false);
      });
    });
  }

  void onExpenseUpdateClick() {
    setState(() {
      this._amount.text.isEmpty
          ? _validateAmount = true
          : _validateAmount = false;
      this._expdatectrl.text.isEmpty
          ? _validateExpdate = true
          : _validateExpdate = false;
    });
    if (_validateAmount!) {
      CommonUtil.showAlertDialog(
          context, true, "Alert", "Please add amount and try again!", "OK");
      return;
    } else if (_validateExpdate!) {
      CommonUtil.showAlertDialog(
          context, true, "Alert", "Please add date and try again!", "OK");
      return;
    }

    CommonUtil.checkInternet().then((result) {
      _showLoader(true, status: "Logging in. Plese wait");
      rest.updateExpense(prepareRegExpense()).then((loginuser) {
        if (loginuser != null) {
          _showLoader(false);
          _clearForm();
          CommonUtil.showAlertDialog(
              context, true, "Message", "Expense added successfully!", "");
        } else {
          _showLoader(false);
          CommonUtil.showAlertDialog(
              context, true, "Alert", "Expense adding faild! Try again", "");
        }
      }).catchError((error) {
        _showLoader(false);
        CommonUtil.showAlertDialog(
            context, true, "Alert", error.toString(), "");
      });
    }).catchError((error) {
      _updateStatus("Please chek your internet connection.");
      Future.delayed(Duration(seconds: 2), () {
        _showLoader(false);
      });
    });
  }

  RegExpense prepareRegExpense() {
    RegExpense reg =  RegExpense();
    double? amount = double.tryParse(_amount.text);
    if (widget.isEdit! && widget.regexp!.id! > 0) {
      reg.id = widget.regexp!.id;
      reg.updatedBy = widget.userdata!.userName;
      reg.updatedOn = DateTime.now().toString();
    } else {
      reg.createdBy = widget.userdata!.userName;
      reg.createdOn = DateTime.now().toString();
    }
    reg.amount = amount!;
    reg.approvedAmount = 0;
    reg.reason = _reson.text;
    reg.expenseDate =stdate!;
    reg.approved = false;
    reg.isActive = true;
    reg.filePath = "";
    reg.payPeriodId = 0;
    reg.referenceId = _referencesId.text;
    reg.regId = widget.userdata!.registrationId;
    reg.superId = widget.userdata!.superId;
    reg.expenseTypeId = this.selectedExpType!.id;
    return reg;
  }
}
