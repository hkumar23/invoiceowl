import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:invoiceowl/data/repositories/business_repo.dart';
import 'package:invoiceowl/utils/banner_ad_widget.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../screens/billing/bloc/billing_event.dart';
import '../../screens/billing/bloc/billing_state.dart';
import '../../../utils/custom_snackbar.dart';
import '../../screens/billing/bloc/billing_bloc.dart';
import '../../../constants/app_constants.dart';
import '../../../data/models/invoice.model.dart';

abstract class InvoiceBottomsheet {
  static BottomSheet bottomSheet(BuildContext context, Invoice invoice) {
    // print(invoice.toJson());
    final theme = Theme.of(context);
    final currency = BusinessRepo().getCurrency();
    final currSymbol = currency == null ? '₹ ' : "${currency["symbol"]} ";
    return BottomSheet(
      onClosing: () {}, // Required callback, but we handle closing manually
      builder: (BuildContext context) {
        return BlocConsumer<BillingBloc, BillingState>(
          listener: (context, state) {
            if (state is PdfGeneratedState) {
              CustomSnackbar.success(
                context: context,
                text: state.message,
              );
              Navigator.of(context).pop();
            }
          },
          builder: (context, state) {
            if (state is BillingLoadingState) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return Container(
              height: MediaQuery.of(context).size.height *
                  0.95, // Almost full-screen
              padding: const EdgeInsets.all(16.0),
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 74),
                        // const SizedBox(height: 10),
                        // Invoice Details
                        Text(
                          'Invoice Details',
                          style: theme.textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Invoice ID: ${AppConstants.invoiceIdPrefix}${invoice.invoiceNumber}',
                          style: theme.textTheme.bodyLarge,
                        ),
                        Text(
                          'Invoice Date: ${DateFormat('dd MMM yyyy').format(invoice.invoiceDate!)}',
                          style: theme.textTheme.bodyLarge,
                        ),
                        Text(
                          'Payment Method: ${invoice.paymentMethod ?? AppConstants.notMentioned}',
                          style: theme.textTheme.bodyLarge,
                        ),

                        const SizedBox(height: 20),

                        // Client Details
                        Text(
                          'Client Details',
                          style: theme.textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Text('Client Name: ${invoice.clientName}',
                            style: theme.textTheme.bodyLarge),
                        // Text('Contact Person: John Doe',
                        //     style: theme.textTheme.bodyLarge),
                        if (invoice.clientAddress != null)
                          Text(
                            'Address: ${invoice.clientAddress}',
                            style: theme.textTheme.bodyLarge,
                          ),
                        // Text('Shipping Address: 456, Another St, City, ZIP',
                        //     style: theme.textTheme.bodyLarge),
                        if (invoice.clientEmail != null)
                          Text(
                            'Email: ${invoice.clientEmail}',
                            style: theme.textTheme.bodyLarge,
                          ),
                        if (invoice.clientPhone != null)
                          Text(
                            'Phone: +91 ${invoice.clientPhone}',
                            style: theme.textTheme.bodyLarge,
                          ),
                        const SizedBox(height: 20),

                        // Item Details
                        Text(
                          'Item Details',
                          style: theme.textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            // decoration: BoxDecoration(border: Border.all()),
                            border: TableBorder.symmetric(
                                inside: BorderSide(
                                    color: Colors.white.withOpacity(0.3))),
                            columnSpacing: 0,
                            headingRowColor: WidgetStateProperty.all(
                              // theme.colorScheme.primaryContainer,
                              Colors.white12,
                            ),
                            columns: [
                              DataColumn(
                                label: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Text(
                                    'S.No',
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  child: Text(
                                    'Item',
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Text(
                                    'Quantity',
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Text(
                                    'Unit Price',
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Text(
                                    'Tax',
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Text('Discount',
                                      style: theme.textTheme.bodyMedium),
                                ),
                              ),
                              DataColumn(
                                label: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Text('Total',
                                      style: theme.textTheme.bodyMedium),
                                ),
                              ),
                            ],

                            rows:
                                invoice.billItems!.asMap().entries.map((item) {
                              int serialNo = item.key + 1;
                              return DataRow(cells: [
                                DataCell(
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    alignment: Alignment.center,
                                    child: Text(
                                      "$serialNo",
                                      // "0",
                                      style: theme.textTheme.bodySmall,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    alignment: Alignment.center,
                                    child: Text(
                                      item.value.itemName!,
                                      style: theme.textTheme.bodySmall,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    alignment: Alignment.center,
                                    child: Text(
                                      item.value.quantity.toString(),
                                      style: theme.textTheme.bodySmall,
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    alignment: Alignment.center,
                                    child: Text(
                                      currSymbol +
                                          item.value.unitPrice.toString(),
                                      style: theme.textTheme.bodySmall,
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    alignment: Alignment.center,
                                    child: Text(
                                      '${item.value.tax}%',
                                      style: theme.textTheme.bodySmall,
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    alignment: Alignment.center,
                                    child: Text(
                                      '${item.value.discount}%',
                                      style: theme.textTheme.bodySmall,
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    alignment: Alignment.center,
                                    child: Text(
                                        currSymbol +
                                            item.value.totalPrice.toString(),
                                        style: theme.textTheme.bodySmall),
                                  ),
                                ),
                              ]);
                            }).toList(),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Summary
                        Text(
                          'Summary',
                          style: theme.textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Subtotal: ${currSymbol + invoice.subtotal.toString()}',
                          style: theme.textTheme.bodyLarge,
                        ),
                        if (invoice.extraDiscount != null)
                          Text(
                            'Extra Discount: ${currSymbol + invoice.extraDiscount.toString()}',
                            style: theme.textTheme.bodyLarge,
                          ),
                        Text(
                          'Total Discount: ${currSymbol + invoice.totalDiscount.toString()}',
                          style: theme.textTheme.bodyLarge,
                        ),
                        Text(
                          'Total Tax: ${currSymbol + invoice.totalTaxAmount.toString()}',
                          style: theme.textTheme.bodyLarge,
                        ),
                        if (invoice.shippingCharges != null)
                          Text(
                            'Shipping Charges: ${currSymbol + invoice.shippingCharges.toString()}',
                            style: theme.textTheme.bodyLarge,
                          ),
                        Text(
                          'Grand Total: ${currSymbol + invoice.grandTotal.toString()}',
                          style: theme.textTheme.bodyLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Additional Notes
                        if (invoice.notes != null)
                          Text(
                            'Notes:',
                            style: theme.textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        if (invoice.notes != null) const SizedBox(height: 10),
                        if (invoice.notes != null)
                          Text(
                            invoice.notes!,
                            style: theme.textTheme.bodyLarge,
                          ),
                        const SizedBox(height: 40)
                      ],
                    ),
                  ),
                  // Close Button
                  Align(
                    // alignment: const Alignment(1, -1),// Normal
                    alignment: const Alignment(1, -0.8), // With ads
                    child: IconButton(
                      icon: Icon(MdiIcons.closeCircle),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: GestureDetector(
                      onTap: () {
                        context.read<BillingBloc>().add(
                              GeneratePdfEvent(
                                invoice: invoice,
                              ),
                            );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(50)),
                          color: theme.colorScheme.primaryContainer,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.download,
                              color: theme.colorScheme.onPrimaryContainer,
                            ),
                            Text(
                              "Generate Pdf",
                              style: theme.textTheme.labelLarge!.copyWith(
                                color: theme.colorScheme.onPrimaryContainer,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const Align(
                    alignment: Alignment.topCenter,
                    child: BannerAdWidget(),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }
}
