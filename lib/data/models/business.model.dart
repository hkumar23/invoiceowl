import 'package:hive/hive.dart';

import '../../constants/app_constants.dart';
import '../../utils/hive_adapter_typeids.dart';
import '../../utils/hive_adapter_names.dart';

part 'business.model.g.dart';

@HiveType(
  typeId: HiveAdapterTypeids.business,
  adapterName: HiveAdapterNames.business,
)
class Business {
  @HiveField(0)
  String? name;
  @HiveField(1)
  String? address;
  @HiveField(2)
  String? email;
  @HiveField(3)
  String? phone;
  @HiveField(4)
  String? gstin;
  @HiveField(5)
  String? upiId;
  @HiveField(6)
  int globalInvoiceNumber;

  Business({
    // this.name = "Shop Owner",
    // this.address = "ABC, 123, State,pincode, Country",
    // this.email = "customer@test.com",
    // this.phone = "9999999999",
    // this.gstin = "22AAAAA0000A1Z5",
    this.name,
    this.address,
    this.email,
    this.phone,
    this.gstin,
    this.upiId,
    this.globalInvoiceNumber = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      AppConstants.name: name,
      AppConstants.address: address,
      AppConstants.email: email,
      AppConstants.phone: phone,
      AppConstants.gstin: gstin,
      AppConstants.upiId: upiId,
      AppConstants.globalInvoiceNumber: globalInvoiceNumber,
    };
  }

  factory Business.fromJson(Map json) {
    return Business(
      name: json[AppConstants.name],
      address: json[AppConstants.address],
      email: json[AppConstants.email],
      phone: json[AppConstants.phone],
      gstin: json[AppConstants.gstin],
      upiId: json[AppConstants.upiId],
      globalInvoiceNumber: json[AppConstants.globalInvoiceNumber],
    );
  }
}
