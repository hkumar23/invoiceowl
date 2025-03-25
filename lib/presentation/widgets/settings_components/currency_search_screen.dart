import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invoiceowl/presentation/screens/settings/bloc/settings_bloc.dart';
import 'package:invoiceowl/presentation/screens/settings/bloc/settings_event.dart';
import 'package:invoiceowl/utils/app_methods.dart';

class CurrencySearchScreen extends StatefulWidget {
  const CurrencySearchScreen({super.key});

  @override
  _CurrencySearchScreenState createState() => _CurrencySearchScreenState();
}

class _CurrencySearchScreenState extends State<CurrencySearchScreen> {
  List<Map<String, dynamic>> currencyList = [];

  List<Map<String, dynamic>> filteredList = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    AppMethods.loadCurrencies().then((list) {
      currencyList = list;
      filteredList = List.from(currencyList); // Initialize with all data
    });
  }

  void filterSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredList = List.from(currencyList);
      });
      return;
    }

    setState(() {
      filteredList = currencyList.where((item) {
        return item.values
            .any((value) => value.toLowerCase().contains(query.toLowerCase()));
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Search Currency")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: const InputDecoration(
                labelText: "Search",
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search),
              ),
              onChanged: filterSearch,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredList.length,
              itemBuilder: (context, index) {
                final item = filteredList[index];
                return ListTile(
                  title: Text(item["name"]!),
                  subtitle: Text("${item["symbol"]} - ${item["code"]}"),
                  onTap: () {
                    BlocProvider.of<SettingsBloc>(context)
                        .add(UpdateCurrencyEvent(currency: item));
                    Navigator.of(context).pop();
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
