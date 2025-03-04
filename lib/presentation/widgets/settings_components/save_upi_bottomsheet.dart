import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:invoiceowl/data/repositories/business_repo.dart';

import '../../../constants/app_constants.dart';
import '../../screens/settings/bloc/settings_bloc.dart';
import '../../screens/settings/bloc/settings_event.dart';

class SaveUpiBottomsheet extends StatefulWidget {
  const SaveUpiBottomsheet({super.key});

  @override
  State<SaveUpiBottomsheet> createState() => _SaveUpiBottomsheetState();
}

class _SaveUpiBottomsheetState extends State<SaveUpiBottomsheet> {
  final _formKey = GlobalKey<FormState>();
  final _upiController = TextEditingController();
  final _business = BusinessRepo().getBusinessInfo();

  @override
  void initState() {
    super.initState();
    final upiId = _business != null ? _business.upiId ?? "" : "";
    _upiController.text = upiId;
  }

  void _onSubmit(context) {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    BlocProvider.of<SettingsBloc>(context).add(
      SaveUpiIdEvent(
        upiId: _upiController.text.trim(),
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        height: 150,
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        width: double.maxFinite,
        alignment: Alignment.center,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Add / Update your UPI ID",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        // border: OutlineInputBorder(),
                        label: Text("UPI ID"),
                      ),
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        value = value?.trim();

                        // Regular expression for UPI ID validation
                        final RegExp upiRegex =
                            RegExp(r'^[a-zA-Z0-9._]+@[a-zA-Z0-9]+$');

                        if (value == null || value.isEmpty) {
                          return 'UPI ID cannot be empty';
                        } else if (!upiRegex.hasMatch(value)) {
                          return 'Please enter a valid UPI ID';
                        }

                        return null;
                      },
                      controller: _upiController,
                    ),
                  ),
                  FilledButton(
                      onPressed: () {
                        _onSubmit(context);
                      },
                      child: const Text(
                        "Save",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
