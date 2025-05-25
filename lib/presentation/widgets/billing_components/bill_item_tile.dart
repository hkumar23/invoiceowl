import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invoiceowl/data/repositories/business_repo.dart';
import 'package:invoiceowl/presentation/screens/billing/bloc/billing_bloc.dart';
import 'package:invoiceowl/presentation/screens/billing/bloc/billing_event.dart';

import '../../../data/models/bill_item.model.dart';

class BillItemTile extends StatelessWidget {
  const BillItemTile({
    super.key,
    required this.billItem,
    required this.billItemList,
  });
  final BillItem billItem;
  final List<BillItem> billItemList;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final currency = BusinessRepo().getCurrency();
    final currSymbol = currency == null ? '₹ ' : "${currency["symbol"]} ";
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
      margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 7, // Item Name
            child: Text(
              billItem.itemName!,
              style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            flex: 4, // Quantity
            child: Column(
              children: [
                Text(
                  'Qty:',
                  style: textTheme.bodySmall!
                      .copyWith(fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
                Text(
                  billItem.quantity.toString(),
                  style: textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Expanded(
            flex: 6, // Price
            child: Column(
              children: [
                Text(
                  'Price:',
                  style: textTheme.bodySmall!
                      .copyWith(fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
                Text(
                  currSymbol + billItem.unitPrice.toString(),
                  style: textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          if (billItem.tax != null)
            Expanded(
              flex: 4, // Price
              child: Column(
                children: [
                  Text(
                    'Tax:',
                    style: textTheme.bodySmall!
                        .copyWith(fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    '${billItem.tax}%',
                    style: textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          if (billItem.discount != null)
            Expanded(
              flex: 7, // Price
              child: Column(
                children: [
                  Text(
                    'Discount:',
                    style: textTheme.bodySmall!
                        .copyWith(fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    '${billItem.discount}%',
                    style: textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          Expanded(
            flex: 6, // Total
            child: Column(
              children: [
                Text(
                  'Total:',
                  style: textTheme.bodySmall
                      ?.copyWith(fontWeight: FontWeight.w600),
                  textAlign: TextAlign.end,
                ),
                Text(
                  currSymbol + billItem.totalPrice.toString(),
                  style: textTheme.bodySmall
                      ?.copyWith(fontWeight: FontWeight.w600),
                  textAlign: TextAlign.end,
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: GestureDetector(
              onTap: () {
                BlocProvider.of<BillingBloc>(context).add(
                  DeleteBillItemEvent(
                    itemDocId: billItem.docId,
                    billItemList: billItemList,
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 1),
                // margin: const EdgeInsets.only(left: 5),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.all(
                    Radius.circular(50),
                  ),
                ),
                child: const Icon(
                  Icons.close,
                  size: 17,
                ),
              ),
            ),
            // child: IconButton(
            //   alignment: Alignment.topCenter,
            //   padding: const EdgeInsets.all(0),
            //   onPressed: () {
            //     BlocProvider.of<BillingBloc>(context).add(
            //       DeleteBillItemEvent(
            //         itemDocId: billItem.docId,
            //         billItemList: billItemList,
            //       ),
            //     );
            //   },
            //   icon: const Icon(Icons.cancel),
            //   color: Colors.red,
            // ),
          ),
        ],
      ),
    );
  }
}
