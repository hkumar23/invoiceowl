import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:invoiceowl/constants/app_constants.dart';

import 'data/models/bill_item.model.dart';
import 'data/models/business.model.dart';
import 'data/models/invoice.model.dart';
import 'presentation/screens/billing/bloc/billing_bloc.dart';
import 'presentation/screens/main_screen.dart';
import 'presentation/screens/settings/bloc/settings_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // MobileAds.instance.initialize();
  await Hive.initFlutter();

  Hive.registerAdapter(InvoiceAdapter());
  Hive.registerAdapter(BillItemAdapter());
  Hive.registerAdapter(BusinessAdapter());

  // opening box here so that it is easily available appwide right after start
  await Hive.openBox<Invoice>(AppConstants.invoiceBox);
  await Hive.openBox<Business>(AppConstants.businessBox);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => BillingBloc()),
        BlocProvider(create: (context) => SettingsBloc()),
      ],
      child: MaterialApp(
          title: 'Invoice Owl',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 103, 58, 183),
              brightness: Brightness.dark,
            ),
            useMaterial3: true,
          ),
          home: const MainScreen()),
    );
  }
}
