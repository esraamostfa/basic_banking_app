import 'package:basic_banking_app/cubit/app_cubit.dart';
import 'package:basic_banking_app/cubit/app_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var appCubit = AppCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              title: const Text('Bankin App'),
            ),
            body: appCubit.screens[appCubit.currentIndex],
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: AppCubit.get(context).currentIndex,
              onTap: (index) {
                appCubit.changeIndex(index);
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline),
                  label: 'Customers',
                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.monetization_on_outlined),
                    label: 'Transfers'),
              ],
            ),
          );
        });
  }
}
