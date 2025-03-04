import 'package:hive/hive.dart';
import 'package:invoiceowl/constants/app_constants.dart';
import 'package:invoiceowl/data/models/business.model.dart';

class BusinessRepo {
  final Box<Business> _businessBox =
      Hive.box<Business>(AppConstants.businessBox);

  Future<void> saveBusinessInfo(Business business) async {
    try {
      await _businessBox.put(0, business);
    } catch (err) {
      rethrow;
    }
  }

  Future<void> deleteBusinessInfoFromLocal() async {
    await _businessBox.clear();
  }

  Business? getBusinessInfo() {
    return _businessBox.get(0);
  }

  Future<void> saveUpiId(String upiId) async {
    try {
      Business? business = getBusinessInfo();
      if (business == null) {
        await _businessBox.put(0, Business(upiId: upiId));
      } else {
        business.upiId = upiId;
        await _businessBox.put(0, business);
      }
    } catch (err) {
      rethrow;
    }
  }

  String? getUpiId() {
    final Business? business = getBusinessInfo();
    if (business == null) return null;
    return business.upiId;
  }

  Future<int> getNextInvoiceNumber() async {
    try {
      final business = getBusinessInfo();
      if (business == null) {
        await _businessBox.put(0, Business());
        return 0;
      }
      business.globalInvoiceNumber++;
      await _businessBox.put(0, business);
      return business.globalInvoiceNumber;
    } catch (err) {
      rethrow;
    }
  }

  Future<int> getGlobalInvoiceNumber() async {
    try {
      final Business? business = getBusinessInfo();
      if (business == null) {
        await _businessBox.put(0, Business());
        return 0;
      }
      return business.globalInvoiceNumber;
    } catch (err) {
      rethrow;
    }
  }
}
