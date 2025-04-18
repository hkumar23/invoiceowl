import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:invoiceowl/data/repositories/business_repo.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';

import '../../../utils/app_methods.dart';
import '../../../constants/app_constants.dart';
import '../../../data/models/business.model.dart';
import '../../../data/models/invoice.model.dart';

abstract class GeneratePdf {
  static Future<bool> start(Invoice invoice) async {
    try {
      final doc = pw.Document();
      await _createPage(doc, invoice);

      // final pdfBytes = await doc.save();

      await AppMethods.requestStoragePermission();
      // if (!isGranted) {
      //   throw "Storage Permission not granted";
      // }
      bool isPdfSaved = await _previewPdf(doc);

      if (!isPdfSaved) {
        // String path = await _savePdfToLocal(pdfBytes, invoice);
        // return "Pdf saved to: $path";
        return false;
      }
      return true;
    } catch (err) {
      rethrow;
    }
  }

  static Future<String> _savePdfToLocal(pdfBytes, invoice) async {
    try {
      final dir = await getExternalStorageDirectory();
      if (dir == null) {
        throw "Unable to access external storage directory";
      }

      String path;
      if (await AppMethods.isAndroid10OrAbove()) {
        path = "${dir.path}/Invoices";

        final invoicesDir = Directory(path);
        if (!await invoicesDir.exists()) {
          await invoicesDir.create(recursive: true);
        }
      } else {
        path = "${dir.parent.parent.parent.parent.path}/Download";

        // Create the Downloads directory if it doesn't exist
        final downloadDir = Directory(path);
        if (!await downloadDir.exists()) {
          await downloadDir.create(recursive: true);
        }
      }

      final file = File(
          '$path/${invoice.clientName.trim()} ${AppConstants.invoiceIdPrefix}${invoice.invoiceNumber}.pdf');
      await file.writeAsBytes(pdfBytes);

      debugPrint('PDF saved to ${file.path}');
      return file.path;
    } catch (err) {
      rethrow;
    }
  }

  static Future<bool> _previewPdf(doc) async {
    return Printing.layoutPdf(
      onLayout: (format) async => doc.save(),
    );
  }

  static Future<Uint8List> _loadAssetImage(String path) async {
    final data = await rootBundle.load(path);
    return data.buffer.asUint8List();
  }

  static Future<pw.Font> _loadFont() async {
    final ByteData data =
        await rootBundle.load('assets/fonts/Roboto-Regular.ttf');
    return pw.Font.ttf(data);
  }

  static Future<void> _createPage(doc, Invoice invoice) async {
    final font = await _loadFont();
    final defaultTextStyle = pw.TextStyle(font: font);
    // final logoImageData =
    //     await _loadAssetImage("assets/logo/invoiceowl_logo.png");
    // final googlePlayImageData =
    //     await _loadAssetImage("assets/images/get_it_on_google_play.png");
    final Business? business = BusinessRepo().getBusinessInfo();
    final currency = business?.currency;
    final currSymbol = currency == null ? '₹ ' : "${currency["symbol"]} ";
    // print(business?.toJson());
    final List<List<dynamic>> tableData = [
      // Header Row
      [
        'S.No.',
        'Item Name',
        'Quantity',
        'Unit Price',
        'Tax (%)',
        'Discount (%)',
        'Total Price',
      ],
      // Item Rows
      ...invoice.billItems!.asMap().entries.map((item) {
        return [
          item.key + 1,
          item.value.itemName,
          item.value.quantity,
          (currSymbol + item.value.unitPrice.toString()),
          item.value.tax,
          item.value.discount,
          (currSymbol + item.value.totalPrice.toString()),
        ];
      }),
    ];
    doc.addPage(
      pw.Page(
        margin: const pw.EdgeInsets.all(24),
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // Invoice Header
            pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'Invoice',
                        style: defaultTextStyle.copyWith(
                          fontSize: 36,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      // User Information
                      // pw.Text('Contact us',
                      //     style: defaultTextStyle.copyWith(
                      //         fontSize: 20, fontWeight: pw.FontWeight.bold)),
                      pw.SizedBox(height: 9),
                      if (business != null &&
                          business.name != null &&
                          business.name!.isNotEmpty)
                        pw.Text(
                          business.name!,
                          style: defaultTextStyle.copyWith(
                            fontSize: 20,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      if (business != null &&
                          business.address != null &&
                          business.address!.isNotEmpty)
                        pw.Text(
                          'Address: ${business.address}',
                          style: defaultTextStyle,
                        ),
                      if (business != null &&
                          business.email != null &&
                          business.email!.isNotEmpty)
                        pw.Text(
                          'Email: ${business.email}',
                          style: defaultTextStyle,
                        ),
                      if (business != null &&
                          business.phone != null &&
                          business.phone!.isNotEmpty)
                        pw.Text(
                          'Phone: ${business.phone}',
                          style: defaultTextStyle,
                        ),
                      if (business != null &&
                          business.gstin != null &&
                          business.gstin!.isNotEmpty)
                        pw.Text(
                          'GSTIN / TIN : ${business.gstin}',
                          style: defaultTextStyle,
                        ),
                      // Invoice Details
                      pw.SizedBox(height: 5),
                      pw.Text(
                        'Invoice ID: ${AppConstants.invoiceIdPrefix}${invoice.invoiceNumber}',
                        style: defaultTextStyle,
                      ),
                      pw.Text(
                        'Invoice Date: ${DateFormat('dd MMM yyyy').format(invoice.invoiceDate!)}',
                        style: defaultTextStyle,
                      ),
                      pw.Text(
                        'Payment Method: ${invoice.paymentMethod ?? AppConstants.notMentioned}',
                        style: defaultTextStyle,
                      ),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      // Client Details
                      pw.SizedBox(height: 46),
                      pw.Text(
                        'Bill To',
                        style: defaultTextStyle.copyWith(
                          fontSize: 20,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.Text(
                        'Name: ${invoice.clientName}',
                        style: defaultTextStyle,
                      ),
                      if (invoice.clientAddress != null)
                        pw.Text(
                          'Address: ${invoice.clientAddress}',
                          style: defaultTextStyle,
                        ),
                      if (invoice.clientEmail != null)
                        pw.Text(
                          'Email: ${invoice.clientEmail}',
                          style: defaultTextStyle,
                        ),
                      if (invoice.clientPhone != null)
                        pw.Text(
                          'Phone: ${invoice.clientPhone}',
                          style: defaultTextStyle,
                        ),
                      // pw.Row(
                      //   mainAxisAlignment: pw.MainAxisAlignment.end,
                      //   children: [
                      //     pw.SizedBox(width: 100),
                      //     pw.Column(
                      //       children: [
                      //         pw.Image(
                      //           pw.MemoryImage(logoImageData),
                      //           width: 70,
                      //           height: 70,
                      //         ),
                      //         pw.SizedBox(height: 7),
                      //         pw.Text(
                      //           AppLanguage.appName,
                      //           style: defaultTextStyle.copyWith(
                      //             fontSize: 15,
                      //             fontWeight: pw.FontWeight.bold,
                      //           ),
                      //         ),
                      //         pw.Image(
                      //           pw.MemoryImage(googlePlayImageData),
                      //           // width: 100,
                      //           height: 22,
                      //         ),
                      //       ],
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),
                ]),
            pw.SizedBox(height: 10),

            pw.TableHelper.fromTextArray(
              context: context,
              data: tableData,
              cellAlignment: pw.Alignment.centerLeft,
              cellStyle: defaultTextStyle.copyWith(
                  // fontSize: 14,
                  ),
              headerAlignment: pw.Alignment.centerLeft,
              headerStyle: defaultTextStyle.copyWith(
                fontWeight: pw.FontWeight.bold,
                fontSize: 14,
                color: PdfColors.white,
              ),

              headerDecoration: const pw.BoxDecoration(
                color: PdfColors.blueGrey, // Header background color
              ),
              border: pw.TableBorder.all(
                width: 1,
                color: PdfColors.grey,
              ), // Table border
              cellDecoration: (a, b, c) => const pw.BoxDecoration(
                color: PdfColors.grey100, // Row background color for all cells
              ),
            ),
            // pw.Table.fromTextArray(
            //   headers: ['Item', 'Quantity', 'Price'],
            //   data:
            // ),
            pw.SizedBox(height: 10),

            // Summary Details
            pw.Text('Summary',
                style: defaultTextStyle.copyWith(
                    fontSize: 20, fontWeight: pw.FontWeight.bold)),
            pw.Text(
              'Subtotal: ${currSymbol + invoice.subtotal.toString()}',
              style: defaultTextStyle,
            ),
            if (invoice.extraDiscount != null)
              pw.Text(
                'Extra Discount: ${currSymbol + invoice.extraDiscount.toString()}',
                style: defaultTextStyle,
              ),
            pw.Text(
              'Total Discount: ${currSymbol + invoice.totalDiscount.toString()}',
              style: defaultTextStyle,
            ),
            pw.Text(
              'Total Tax: ${currSymbol + invoice.totalTaxAmount.toString()}',
              style: defaultTextStyle,
            ),
            if (invoice.shippingCharges != null)
              pw.Text(
                'Shipping Charges: ${currSymbol + invoice.shippingCharges.toString()}',
                style: defaultTextStyle,
              ),

            pw.Divider(endIndent: 300),
            pw.Text(
              'Grand Total: ${currSymbol + invoice.grandTotal.toString()}',
              style: defaultTextStyle.copyWith(
                fontSize: 15,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(height: 10),

            // Notes
            if (invoice.notes != null)
              pw.Text(
                'Notes',
                style: defaultTextStyle.copyWith(
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            if (invoice.notes != null)
              pw.Text(
                invoice.notes!,
                style: defaultTextStyle,
              ),
            pw.Spacer(),
            pw.Align(
              alignment: pw.Alignment.bottomCenter,
              child: pw.Text(
                "Generated with Invoice Owl - Easy Invoice and receipt maker",
                style: defaultTextStyle.copyWith(color: PdfColors.blueGrey),
              ),
            ),
            pw.Align(
              alignment: pw.Alignment.bottomCenter,
              child: pw.Text(
                "App available on Play Store!",
                style: defaultTextStyle.copyWith(color: PdfColors.blueGrey),
              ),
            ),

            // if (invoice.notes != null) pw.SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
