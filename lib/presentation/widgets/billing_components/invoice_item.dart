import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:invoiceowl/data/repositories/business_repo.dart';

import '../../../constants/app_constants.dart';
import '../../../data/models/invoice.model.dart';
import 'invoice_details_bottomsheet.dart';

class InvoiceItem extends StatefulWidget {
  const InvoiceItem({
    super.key,
    required this.invoice,
  });
  final Invoice invoice;

  @override
  State<InvoiceItem> createState() => _InvoiceItemState();
}

class _InvoiceItemState extends State<InvoiceItem> {
  void showInvoice(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Ensures the bottom sheet can expand fully
      enableDrag: true,
      builder: (BuildContext context) {
        return InvoiceBottomsheet.bottomSheet(context, widget.invoice);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final currency = BusinessRepo().getCurrency();
    final currSymbol = currency == null ? '₹ ' : "${currency["symbol"]} ";

    return GestureDetector(
      onTap: () => showInvoice(context),
      child: Container(
        margin: const EdgeInsets.only(bottom: 5),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Card(
          elevation: 6,
          color: Theme.of(context).colorScheme.surfaceContainerHigh,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            // side: BorderSide(color: Theme.of(context).colorScheme.outline),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.invoice.clientName,
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall!
                          .copyWith(fontWeight: FontWeight.bold),
                      // textAlign: TextAlign.left,
                    ),
                    Icon(
                      Icons.info_outline,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.6),
                    ),
                  ],
                ),
                // Wrap(
                //   // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   runAlignment: WrapAlignment.spaceBetween,
                //   children: [
                //     Text(
                //       "Vend Gopal MutuSwami Iyer",
                //       style: Theme.of(context)
                //           .textTheme
                //           .headlineSmall!
                //           .copyWith(fontWeight: FontWeight.bold),
                //     ),
                //     const Icon(Icons.edit)
                //   ],
                // ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Text(
                      "${AppConstants.invoiceIdPrefix}${widget.invoice.invoiceNumber}",
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total: ${currSymbol + widget.invoice.grandTotal.toString()}',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: Text(
                        DateFormat('dd-MM-yyyy')
                            .format(widget.invoice.invoiceDate!),
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.6),
                            ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
