import '../../../../data/models/bill_item.model.dart';

abstract class BillingState {}

class InitialBillingState extends BillingState {}

class BillingLoadingState extends BillingState {}

class BillingErrorState extends BillingState {
  final String errorMessage;
  BillingErrorState({required this.errorMessage});
}

class BillItemDeletedState extends BillingState {
  List<BillItem>? billItems;
  BillItemDeletedState({required this.billItems});
}

class InvoiceGeneratedState extends BillingState {
  String message;
  InvoiceGeneratedState(this.message);
}

class PdfGeneratedState extends BillingState {
  String message;
  PdfGeneratedState(this.message);
}

class PdfNotGeneratedState extends BillingState {}

class InvoiceUpdatedState extends BillingState {}

class LocalInvoicesFetchedState extends BillingState {}

class InvoiceDeletedState extends BillingState {}
