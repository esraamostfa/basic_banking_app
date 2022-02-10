import 'package:basic_banking_app/cubit/app_cubit.dart';
import 'package:basic_banking_app/styles/colores.dart';
import 'package:basic_banking_app/ui/home_screen.dart';
import 'package:basic_banking_app/ui/splash_screen.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'cubit/bloc_observer.dart';
import 'database/repository/repository.dart';
import 'database/repository/sqlite_repository.dart';

Future<void> main() async {

  await Hive.initFlutter();

  Bloc.observer = MyBlocObserver();

  final repository = SqliteRepository();
  await repository.init();

  runApp(MyApp(repository: repository));
}

class MyApp extends StatelessWidget {

  final Repository repository;

  const MyApp({
    required this.repository,
    Key? key
  }) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit(repository: repository)..getAllTransfers(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          appBarTheme: const AppBarTheme(color: primaryColor),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            selectedItemColor: primaryColor ,)
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
