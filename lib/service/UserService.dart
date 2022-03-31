
import 'package:etm_flutter/model/user.dart';
import 'package:firebase_database/firebase_database.dart';

class UserService{
  static Future<String> worksFor(String userId) async{
    DatabaseReference ref =
    FirebaseDatabase.instance.ref("users/${userId}");
    DatabaseReference child = ref.child("inCompany");
    DatabaseEvent event = await child.once();
    Object? companyId = event.snapshot.value;
    return companyId.toString();
  }
  static Future<List<CustomUser>> listUsers(String companyId) async{
    DatabaseReference ref = FirebaseDatabase.instance.ref("users");
    DatabaseEvent event = await ref.once();
    Iterable<DataSnapshot> listUsers = event.snapshot.children;
    List<CustomUser> users = [];
    for (DataSnapshot user in listUsers){
      String id = user.key!;
      String email = user.child("email").value.toString();
      String companyId = user.child("inCompany").value.toString();
      users.add(CustomUser(id: id, Email: email, companyId: companyId));
    }
    return users.where((element) => element.companyId==companyId).toList();
  }
}