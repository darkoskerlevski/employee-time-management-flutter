import 'package:firebase_database/firebase_database.dart';

import '../model/Company.dart';

class CompanyService{
  static Future<Company?> getCompanyForUser(String userId) async {
    DatabaseReference ref =
    FirebaseDatabase.instance.ref("users/${userId}");
    DatabaseReference child = ref.child("inCompany");
    DatabaseEvent event = await child.once();
    Object? companyId = event.snapshot.value;
    if (companyId != null) {
      DatabaseReference nameRef =
      FirebaseDatabase.instance.ref("companies/$companyId/name");
      DatabaseReference managerRef =
      FirebaseDatabase.instance.ref("companies/$companyId/manager");
      DatabaseEvent nameEvent = await nameRef.once();
      DatabaseEvent managerEvent = await managerRef.once();
      return Company(
          id: companyId.toString(),
          name: nameEvent.snapshot.value.toString(),
          managerId: managerEvent.snapshot.value.toString());
    }
    return null;
  }

  static Future<List<String>>getAllCompanies() async{
    DatabaseReference ref = FirebaseDatabase.instance.ref("companies");
    DatabaseEvent event = await ref.once();
    Iterable<DataSnapshot> companiesSnapshot = event.snapshot.children;
    List<String> companies = [];
    for (var key in companiesSnapshot){
      companies.add(key.key!);
    }
    return companies;
  }
}