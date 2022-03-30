import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../components/button.dart';
import '../model/Company.dart';

class CompanyScreen extends StatefulWidget {
  User user;
  Company? company;
  bool state = false;
  CompanyScreen({Key? key,required this.user}) : super(key: key);
  @override
  _CompanyScreenState createState() => _CompanyScreenState();
}

class _CompanyScreenState extends State<CompanyScreen> {

  final createCompanyFieldController = TextEditingController();
  final joinCompanyFieldController = TextEditingController();

  Future<Company?> getCompany() async{
    DatabaseReference ref = FirebaseDatabase.instance.ref("users/${widget.user.uid}");
    DatabaseReference child = ref.child("ownerOf");
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

  @override
  void initState() {
    getCompany().then((value) => {
    setState(() {
      widget.company = value;
      widget.state = true;
    })
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.state)
      {
        if (widget.company!=null)
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
        else{
          return Scaffold(
              appBar: AppBar(
                title: const Text('Company'),
              ),
              body:  Center(
                child: Container(
                  padding: EdgeInsets.all(12),
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 150,),
                      TextField(
                        controller: createCompanyFieldController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Enter company name',
                          isDense: true,

                        ),
                      ),
                      SizedBox(height: 16,),
                      TextButton(
                        style: raisedButtonStyle,
                        onPressed: () { },
                        child: Text('Create company'),
                      ),
                      SizedBox(height: 16,),
                      TextField(
                        controller: joinCompanyFieldController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Enter company ID',
                          isDense: true,

                        ),
                      ),
                      SizedBox(height: 16,),
                      TextButton(
                        style: raisedButtonStyle,
                        onPressed: () { },
                        child: Text('Join company'),
                      )
                    ],
                  ),
                )
              )
          );
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