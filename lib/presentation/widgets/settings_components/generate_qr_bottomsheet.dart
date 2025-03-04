import 'package:flutter/material.dart';
import 'package:invoiceowl/data/repositories/business_repo.dart';

import '../../../utils/custom_snackbar.dart';
import '../../../utils/generate_qr_code.dart';

class GenerateQrBottomSheet extends StatefulWidget {
  const GenerateQrBottomSheet({super.key});

  @override
  State<GenerateQrBottomSheet> createState() => _GenerateQrBottomSheetState();
}

class _GenerateQrBottomSheetState extends State<GenerateQrBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _business = BusinessRepo().getBusinessInfo();

  void _onSubmit(context) {
    final upiId = _business?.upiId;
    FocusScope.of(context).unfocus();
    final businessName = _business == null ? "" : _business.name ?? "";
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    Navigator.of(context).pop();
    if (upiId == null || upiId.isEmpty) {
      CustomSnackbar.error(
        context: context,
        text: "Please save UPI ID first",
      );
      return;
    }
    showDialog(
      context: context,
      builder: (context) => GenerateQrCode(
        // upiId: "9873541772@ptsbi",
        upiId: upiId,
        businessName: businessName,
        amount: _amountController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        height: 150,
        width: double.maxFinite,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Generate QR Code",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        label: Text("Enter Amount"),
                      ),
                      validator: (value) {
                        if (value == null) {
                          return "Some amount is required";
                        }
                        if (double.tryParse(value) == null) {
                          return "Enter valid amount";
                        }
                        return null;
                      },
                      onFieldSubmitted: (value) {
                        _onSubmit(context);
                      },
                    ),
                  ),
                  FilledButton(
                    onPressed: () {
                      _onSubmit(context);
                    },
                    child: const Text(
                      "Show",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
