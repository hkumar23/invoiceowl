import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';

import '../../../widgets/billing_components/generate_pdf.dart';
import '../../../../data/models/bill_item.model.dart';
import '../../../../data/models/invoice.model.dart';
import '../../../../data/repositories/invoice_repo.dart';
import 'billing_state.dart';
import 'billing_event.dart';

class BillingBloc extends Bloc<BillingEvent, BillingState> {
  BillingBloc() : super(InitialBillingState()) {
    // print("Entered Bloc");
    on<GenerateInvoiceEvent>(_onGenerateInvoiceEvent);
    on<GeneratePdfEvent>(_onGeneratePdfEvent);
  }
  void _onGeneratePdfEvent(
      GeneratePdfEvent event, Emitter<BillingState> emit) async {
    emit(BillingLoadingState());
    try {
      bool isSaved = await GeneratePdf.start(event.invoice);
      if (isSaved) {
        emit(PdfGeneratedState("Pdf Generated and saved/printed"));
      } else {
        emit(PdfNotGeneratedState());
      }
    } catch (err) {
      debugPrint("Billing Bloc Exception: $err");
      emit(BillingErrorState(errorMessage: "Something went wrong!!"));
    }
  }

  void _onGenerateInvoiceEvent(
      GenerateInvoiceEvent event, Emitter<BillingState> emit) async {
    emit(BillingLoadingState());
    Invoice invoice = event.invoice;
    final invoiceRepo = InvoiceRepo();
    if (invoice.billItems == null || invoice.billItems!.isEmpty) {
      emit(BillingErrorState(errorMessage: "You should add atleast 1 item"));
      return;
    }

    double subTotal = calcSubtotal(invoice.billItems!);
    invoice.subtotal = double.parse(subTotal.toStringAsFixed(2));

    List<double> totalTaxAndDiscount = calcTotalTaxAndDiscount(invoice);
    invoice.totalTaxAmount =
        double.parse(totalTaxAndDiscount[0].toStringAsFixed(2));
    invoice.totalDiscount =
        double.parse(totalTaxAndDiscount[1].toStringAsFixed(2));

    double grandTotal = subTotal;
    grandTotal -= invoice.totalDiscount!;
    grandTotal += invoice.totalTaxAmount!;
    grandTotal += invoice.shippingCharges ?? 0;
    invoice.grandTotal =
        double.parse(grandTotal.toStringAsFixed(2)); //Updating Invoice Object
    try {
      await invoiceRepo.addInvoice(invoice);
      bool isSaved = await GeneratePdf.start(invoice);
      if (isSaved) {
        emit(InvoiceGeneratedState("Invoice Generated and saved/printed"));
      } else {
        emit(InvoiceGeneratedState("Invoice Generated"));
      }
    } catch (err) {
      debugPrint("Billing Bloc Exception: $err");
      emit(BillingErrorState(errorMessage: "Something went wrong!!"));
    }
    // print(invoice.toJson());
  }

  double calcSubtotal(List<BillItem> billItems) {
    double subTotal = 0;
    for (int i = 0; i < billItems.length; ++i) {
      subTotal += billItems[i].quantity! * billItems[i].unitPrice!;
    }
    return subTotal;
  }

  List<double> calcTotalTaxAndDiscount(Invoice invoice) {
    final billItems = invoice.billItems!;
    double totalTaxAmount = 0;
    double totalDiscount = 0;

    for (int i = 0; i < billItems.length; ++i) {
      double currDiscount = 0;
      double currPrice = billItems[i].quantity! * billItems[i].unitPrice!;
      if (billItems[i].discount != null) {
        currDiscount = (currPrice * billItems[i].discount!) / 100;
      }
      totalDiscount += currDiscount;

      double currTaxAmount = 0;
      if (billItems[i].tax != null) {
        currTaxAmount = ((currPrice - currDiscount) * billItems[i].tax!) / 100;
      }
      totalTaxAmount += currTaxAmount;
    }
    totalDiscount += invoice.extraDiscount ?? 0;
    return [totalTaxAmount, totalDiscount];
  }
}
