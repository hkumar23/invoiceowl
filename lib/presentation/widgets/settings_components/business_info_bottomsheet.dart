import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invoiceowl/data/repositories/business_repo.dart';

import '../../../data/models/business.model.dart';
import '../../screens/settings/bloc/settings_bloc.dart';
import '../../screens/settings/bloc/settings_event.dart';

class BusinessInfoBottomSheet extends StatefulWidget {
  const BusinessInfoBottomSheet({super.key});

  @override
  State<BusinessInfoBottomSheet> createState() =>
      _BusinessInfoBottomSheetState();
}

class _BusinessInfoBottomSheetState extends State<BusinessInfoBottomSheet> {
  final _formKey = GlobalKey<FormState>();

  final _businessNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _gstinController = TextEditingController();
  // final _business = BusinessRepo().getBusinessInfo();
  final _business = BusinessRepo().getBusinessInfo();

  bool validateGSTNumber(String gstNumber) {
    const gstRegEx =
        r'^[0-3][0-9][A-Z]{5}[0-9]{4}[A-Z]{1}[A-Z0-9]{1}[Z]{1}[A-Z0-9]{1}$';
    return RegExp(gstRegEx).hasMatch(gstNumber);
  }

  void _onSubmit(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;

    final business = Business(
      address: _addressController.text.trim(),
      email: _emailController.text.trim(),
      gstin: _gstinController.text.trim(),
      name: _businessNameController.text.trim(),
      phone: _phoneController.text.trim(),
    );
    context.read<SettingsBloc>().add(SaveBusinessInfoEvent(business: business));
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();
    if (_business != null) {
      _addressController.text = _business.address ?? "";
      _businessNameController.text = _business.name ?? "";
      _emailController.text = _business.email ?? "";
      _phoneController.text = _business.phone ?? "";
      _gstinController.text = _business.gstin ?? "";
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        // decoration: BoxDecoration(
        //   borderRadius: const BorderRadius.all(
        //     Radius.circular(50),
        //   ),
        //   color: colorScheme.surface,
        // ),
        padding: const EdgeInsets.symmetric(
          vertical: 24,
          horizontal: 20,
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Add / Update your business details",
                  style: textTheme.headlineMedium,
                ),
                TextFormField(
                  controller: _businessNameController,
                  decoration: const InputDecoration(
                    label: Text("Business Name"),
                  ),
                  keyboardType: TextInputType.name,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Business Name is required..!";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _addressController,
                  decoration: const InputDecoration(
                    label: Text("Address"),
                  ),
                  keyboardType: TextInputType.streetAddress,
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    label: Text("Email Address"),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) return null;

                    value = value.trim();
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    prefix: Text("+91"),
                    label: Text("Phone Number"),
                  ),
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  validator: (value) {
                    if (value == null || value.isEmpty) return null;
                    if (value.length < 10 || double.tryParse(value) == null) {
                      return 'Please enter a valid phone number';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _gstinController,
                  decoration: const InputDecoration(
                    label: Text("GST Number"),
                  ),
                  keyboardType: TextInputType.text,
                  maxLength: 15,
                  validator: (value) {
                    if (value == null || value.isEmpty) return null;
                    if (!validateGSTNumber(value)) {
                      return "Invalid GST Number..!";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FilledButton(
                        onPressed: () {
                          _onSubmit(context);
                        },
                        child: Text(
                          "Save Details",
                          style: textTheme.labelLarge!.copyWith(
                              color: colorScheme.onPrimary,
                              fontWeight: FontWeight.bold),
                        )),
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
