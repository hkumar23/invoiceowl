import 'package:hive/hive.dart';
import 'package:invoiceowl/data/repositories/business_repo.dart';

import '../../utils/app_methods.dart';
import '../../constants/app_constants.dart';
import '../models/invoice.model.dart';

class InvoiceRepo {
  final Box<Invoice> _invoiceBox = Hive.box<Invoice>(AppConstants.invoiceBox);
  final BusinessRepo _businessRepo = BusinessRepo();

  // Method to  Generate docId for invoice
  String generateInvoiceDocId(int invNum) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return 'INV-$timestamp-$invNum';
  }

  // Method to add a new invoice
  Future<void> addInvoice(Invoice invoice) async {
    try {
      invoice.invoiceNumber = await _businessRepo.getNextInvoiceNumber();
      invoice.docId = generateInvoiceDocId(invoice.invoiceNumber!);
      // Save the new invoice
      await _invoiceBox.put(invoice.docId, invoice);
    } catch (err) {
      rethrow;
    }
  }

  // Retrieve an invoice by ID
  Invoice? getInvoice(String id) {
    return _invoiceBox.get(id);
  }

  // Retrieve all invoices
  List<Invoice> getAllInvoices() {
    return _invoiceBox.values.toList();
  }

  // Delete an invoice by ID
  Future<void> deleteInvoice(String id) async {
    try {
      await _invoiceBox.delete(id);
    } catch (err) {
      rethrow;
    }
  }

  Future<void> deleteAllInvoiceFromLocal() async {
    await _invoiceBox.clear();
  }

  // Update an invoice by id
  Future<void> updateInvoice(Invoice updatedInvoice) async {
    try {
      await _invoiceBox.put(updatedInvoice.docId, updatedInvoice);
    } catch (err) {
      rethrow;
    }
  }

  // Update all invoices with a custom update function
  Future<void> updateAllInvoices(List<Invoice> invoices) async {
    for (int i = 0; i < invoices.length; ++i) {
      await updateInvoice(invoices[i]);
    }
  }
}
