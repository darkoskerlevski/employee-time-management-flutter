
import '../model/Company.dart';

class CompanyFactory{

  CompanyFactory();

  Company toCompany({id,name,managerId}){
    return Company(
        id: id,
        name: name,
        managerId: managerId);
  }
}