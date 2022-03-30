import 'package:etm_flutter/widgets/newEmployee.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../components/button.dart';
import '../model/Company.dart';
import '../widgets/newCompanyForm.dart';
import 'package:uuid/uuid.dart';

class CompanyScreen extends StatefulWidget {
  User user;
  Company? company;
  bool state = false;
  CompanyScreen({Key? key,required this.user}) : super(key: key);
  @override
  _CompanyScreenState createState() => _CompanyScreenState();
}

class _CompanyScreenState extends State<CompanyScreen> {

  Future<Company?> getCompany() async{
    DatabaseReference ref = FirebaseDatabase.instance.ref("users/${widget.user.uid}");
    DatabaseReference child = ref.child("inCompany");
    DatabaseEvent event = await child.once();
    Object? companyId = event.snapshot.value;
    if(companyId!=null)
    {
      DatabaseReference nameRef = FirebaseDatabase.instance.ref("companies/$companyId/name");
      DatabaseReference managerRef = FirebaseDatabase.instance.ref("companies/$companyId/manager");
      DatabaseEvent nameEvent = await nameRef.once();
      DatabaseEvent managerEvent = await managerRef.once();
      return widget.company = Company(id: companyId.toString(),name:nameEvent.snapshot.value.toString(),managerId: managerEvent.snapshot.value.toString());
    }
    return null;
  }

  void _createNewCompanyWidget(BuildContext ct) {
    showModalBottomSheet(
        context: ct,
        builder: (_) {
          return GestureDetector(
            onTap: () {},
            child: NewCompany(_createNewCompanyCallback),
            behavior: HitTestBehavior.opaque,
          );
        });
  }

  void _createNewCompanyCallback(BuildContext ctx, String naslov) {
    var uuid = Uuid();
    String uid = uuid.v1();
    DatabaseReference ref = FirebaseDatabase.instance.ref("companies/$uid");
    ref.set({
      "name" : naslov,
      "manager" : widget.user.uid
    });

    DatabaseReference ref2 = FirebaseDatabase.instance.ref("users/${widget.user.uid}");
    ref2.set({
      "inCompany":uid
    });
    initState();
  }

  void _inviteEmployee(BuildContext ct) {
    showModalBottomSheet(
        context: ct,
        builder: (_) {
          return GestureDetector(
            onTap: () {},
            child: NewEmployee(_inviteEmployeeCallback),
            behavior: HitTestBehavior.opaque,
          );
        });
  }

  void _inviteEmployeeCallback(BuildContext ctx, String companyUuid) {

    DatabaseReference ref2 = FirebaseDatabase.instance.ref("users/${widget.user.uid}");
    ref2.set({
      "inCompany": companyUuid
    });
    initState();
  }

  @override
  void initState() {
    getCompany().then((value) => {
    setState(() {
      widget.company = value;
      widget.state = true;
    })
    });
  }

  Widget _noCompany(BuildContext context)
  {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Company'),
        ),
        body:  Center(
            child: Container(
              padding: EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "You're not in a company",
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      TextButton(
                        style: raisedButtonStyle,
                        onPressed: () { _createNewCompanyWidget(context); },
                        child: Text('Create company'),
                      ),
                      SizedBox(width: 16,),
                      TextButton(
                        style: raisedButtonStyle,
                        onPressed: () {_inviteEmployee(context);},
                        child: Text('Join company'),
                      )
                    ],
                  )

                ],
              ),
            )
        )
    );
  }

  Widget _managerView(BuildContext context)
  {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Company'),
        ),
        body: const Center(
          child: Text(
            'Ima',
            style: TextStyle(fontSize: 24),
          ),
        )
    );
  }

  Widget _employeeView(BuildContext context)
  {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Company'),
        ),
        body: const Center(
          child: Text(
            'Your company:',
            style: TextStyle(fontSize: 24),
          ),
        )
    );
  }


  @override
  Widget build(BuildContext context) {
    if (widget.state)
      {
        if (widget.company!=null)
        {
          return _employeeView(context);
        }
        else{
          return _noCompany(context);
        }
      }
    else{
      return Scaffold(
          appBar: AppBar(
            title: const Text('Company'),
          )
      );
    }
  }

}