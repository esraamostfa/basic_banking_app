import 'package:basic_banking_app/cubit/app_cubit.dart';
import 'package:basic_banking_app/cubit/app_states.dart';
import 'package:basic_banking_app/models/customer.dart';
import 'package:basic_banking_app/ui/Customers_list_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AllCustomersScreen extends StatelessWidget {
  const AllCustomersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        builder: (context, state) {
          var appCubit = AppCubit.get(context);
          return FutureBuilder(
            future: appCubit.repository.getAllCustomers(),
            builder: (BuildContext context, AsyncSnapshot<List<Customer>?> snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              } else {
                final customers = snapshot.data ?? [];
                return ListView.separated(
                    itemBuilder: (context, index) => CustomersListItem(
                      customer: customers[index],
                      customers: customers,
                    ),
                    separatorBuilder: (context, index) => const Divider(),
                    itemCount: customers.length);
              }
            },
          );
        },
        listener: (context, state) {});
  }


}
