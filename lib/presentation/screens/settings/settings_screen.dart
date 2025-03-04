import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invoiceowl/presentation/widgets/settings_components/generate_qr_bottomsheet.dart';

import '../../widgets/settings_components/support_dev_button.dart';
import '../../../utils/custom_top_snackbar.dart';
import 'bloc/settings_bloc.dart';
import 'bloc/settings_state.dart';
import '../../widgets/settings_components/business_info_bottomsheet.dart';
import '../../widgets/settings_components/save_upi_bottomsheet.dart';
import '../../../utils/custom_snackbar.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    bool isBottomSheetOpened = false;

    void toggleBottomSheet(bool val) {
      isBottomSheetOpened = val;
    }

    return BlocConsumer<SettingsBloc, SettingsState>(
      listener: (context, state) {
        if (state is SettingsErrorState) {
          if (isBottomSheetOpened) {
            CustomTopSnackbar.error(
              context: context,
              message: state.errorMessage,
            );
          } else {
            CustomSnackbar.error(
              context: context,
              text: state.errorMessage,
            );
          }
        }
        if (state is BusinessInfoSavedState) {
          CustomSnackbar.success(
            context: context,
            text: "Business Details saved successfully !!",
          );
        }
        if (state is UpiIdSavedState) {
          CustomSnackbar.success(
            context: context,
            text: "UPI ID saved successfully !!",
          );
        }
      },
      builder: (context, state) {
        final deviceSize = MediaQuery.of(context).size;
        if (state is SettingsLoadingState) {
          return const Center(child: CircularProgressIndicator());
        }

        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: deviceSize.height * 0.05,
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(
                      "https://cdn-icons-png.flaticon.com/512/3135/3135768.png",
                    ),
                  ),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Your Name",
                        style: theme.textTheme.headlineSmall!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "temporary@email.com",
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: theme.colorScheme.primary,
                          ),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Text(
                          "Edit Profile",
                          style: theme.textTheme.labelMedium,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ListTile(
                title: const Text('Business Info'),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 20,
                ),
                onTap: () {
                  showModalBottomSheet(
                      isScrollControlled: true,
                      context: context,
                      builder: (context) {
                        return const BusinessInfoBottomSheet();
                        // return Container();
                      });
                },
              ),
              ListTile(
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return const SaveUpiBottomsheet();
                      });
                },
                title: const Text('UPI ID'),
                subtitle: const Text('For QR Code generation'),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 20,
                ),
              ),
              ListTile(
                title: const Text('Generate QR Code'),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 20,
                ),
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return const GenerateQrBottomSheet();
                      });
                },
              ),
              const SupportDevButton(),
            ],
          ),
          // ),
        );
      },
    );
  }

  // Widget buildSectionTitle(String title) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 8.0),
  //     child: Text(
  //       title,
  //       style: TextStyle(
  //         fontSize: 16,
  //         fontWeight: FontWeight.bold,
  //         color: Colors.grey[700],
  //       ),
  //     ),
  //   );
  // }
}
