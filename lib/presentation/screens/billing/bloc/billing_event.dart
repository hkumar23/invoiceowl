import '../../../../data/models/bill_item.model.dart';
import '../../../../data/models/invoice.model.dart';

abstract class BillingEvent {}

class GenerateInvoiceEvent extends BillingEvent {
  Invoice invoice;
  GenerateInvoiceEvent({required this.invoice});
}

class GeneratePdfEvent extends BillingEvent {
  Invoice invoice;
  GeneratePdfEvent({required this.invoice});
}

class DeleteInvoiceEvent extends BillingEvent {
  Invoice invoice;
  DeleteInvoiceEvent({required this.invoice});
}

class UpdateInvoiceEvent extends BillingEvent {}

class AddBillItemEvent extends BillingEvent {
  BillItem billItem;
  List<BillItem> billItemList;
  AddBillItemEvent({
    required this.billItem,
    required this.billItemList,
  });
}

class DeleteBillItemEvent extends BillingEvent {
  final String itemDocId;
  List<BillItem> billItemList;
  DeleteBillItemEvent({
    required this.itemDocId,
    required this.billItemList,
  });
}

class UploadInvoicesToFirebaseEvent extends BillingEvent {}

class FetchInvoiceFromFirebaseToLocalEvent extends BillingEvent {}
