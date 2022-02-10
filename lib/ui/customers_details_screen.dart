//import 'dart:js';

import 'package:basic_banking_app/cubit/app_cubit.dart';
import 'package:basic_banking_app/cubit/app_states.dart';
import 'package:basic_banking_app/models/customer.dart';
import 'package:basic_banking_app/models/transfer.dart';
import 'package:basic_banking_app/styles/colores.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class CustomerDetailsScreen extends StatelessWidget {
  final Customer customer;
  final List<Customer> customers;

  CustomerDetailsScreen({
    required this.customer,
    required this.customers,
    Key? key
  }) : super(key: key);

  var transferAmountController = TextEditingController();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var appCubit = AppCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              title: const Text('Customer Details'),
            ),
            body: Container(
                padding: const EdgeInsets.all(15.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Name: ${customer.name}',
                        style: const TextStyle(fontSize: 25),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Text(
                        'Email: ${customer.email}',
                        style: const TextStyle(fontSize: 25),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Text(
                        'Current Balance: ${customer.currentBalance}',
                        style: const TextStyle(fontSize: 25),
                      ),
                      const SizedBox(
                        height: 55,
                      ),
                      MaterialButton(
                        onPressed: () {
                          enterTransferDetails(appCubit, context, customers,
                              customer);
                        },
                        child: const Text(
                          'Transfer Money',
                          style: TextStyle(color: Colors.white, fontSize: 25),
                        ),
                        elevation: 5,
                        color: secondaryColor,
                        padding: const EdgeInsets.all(15.0),
                      ),
                    ],
                  ),
                )),
          );
        },
    );
  }

   enterTransferDetails(AppCubit appCubit, context, List<Customer> customrs, Customer sender,) {
    return showMaterialModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: const EdgeInsets.all(15.0),
            height: 295,
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButtonHideUnderline(
                      child: DropdownButtonFormField2(
                        items: customrs
                            .map((Customer item) => DropdownMenuItem(
                                  value: item,
                                  child: Text(
                                    item.name,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )).toList(),
                        value: appCubit.dropDawnValue,
                        onSaved: (Customer? value) {
                          appCubit.changeDropDownValue(value);
                        },
                        onChanged: (Customer? value) {
                          appCubit.changeDropDownValue(value);
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Please Select valid customer';
                          } else if (value == customer) {
                            return 'You can\'t transfer money to your self' ;
                          }
                          return null;
                        },
                        isExpanded: true,
                        hint: Row(
                          children: const [
                            Icon(
                              Icons.person_outline,
                              size: 16,
                              color: Colors.yellow,
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            Expanded(
                              child: Text(
                                'Select Customer',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.yellow,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        icon: const Icon(
                          Icons.arrow_forward_ios_outlined,
                        ),
                        iconSize: 14,
                        iconEnabledColor: Colors.white,
                        iconDisabledColor: Colors.grey,
                        buttonHeight: 50,
                        buttonWidth: 160,
                        buttonPadding: const EdgeInsets.only(left: 14, right: 14),
                        buttonDecoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: Colors.black26,
                          ),
                          color: accentColor,
                        ),
                        buttonElevation: 2,
                        itemHeight: 40,
                        itemPadding: const EdgeInsets.only(left: 14, right: 14),
                        dropdownMaxHeight: 200,
                        dropdownWidth: 200,
                        dropdownPadding: null,
                        dropdownDecoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          color: accentColor,
                        ),
                        dropdownElevation: 8,
                        scrollbarRadius: const Radius.circular(40),
                        scrollbarThickness: 6,
                        scrollbarAlwaysShow: true,
                        offset: const Offset(-20, 0),
                      )
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    controller: transferAmountController,
                    decoration: const InputDecoration(
                      labelText: 'please enter amount of money',
                    ),
                    keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Amount of can\'t be empty';
                        } else if (value.isNotEmpty && double.parse(value) >= customer.currentBalance) {
                          return 'No sufficient balance';
                        }
                        return null;
                      }
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  MaterialButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()){
                        if(appCubit.dropDawnValue != null && appCubit.dropDawnValue != customer) {
                          appCubit.makeTransfer(
                              Transfer(
                                  receiverId: appCubit.dropDawnValue!.id!,
                                  senderId: sender.id!,
                                  transferAmount:
                                  double.parse(transferAmountController.text)),
                              sender,
                              appCubit.dropDawnValue!);
                          sender.currentBalance -= double.parse(transferAmountController.text);
                          appCubit.changeDropDownValue(null);
                          transferAmountController.clear();
                          Navigator.pop(context);
                          showSnackBar(context);
                        } else {appCubit.changeDropDownValue(null);}
                      }
                    },
                    child: const Text('Transfer Money'),
                    elevation: 5,
                    color: secondaryColor,
                  ),
                ],
              ),
            ),
          );
        },
        expand: false,
        isDismissible: false
    );
  }

  void showSnackBar(context) {
    final snackBar = SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Text("Transfer was made successfully!"),
          Icon(Icons.done_outline_rounded, color: Colors.greenAccent,)
        ],
      ),

      );
    ScaffoldMessenger.of(context)
        .showSnackBar(snackBar);

  }
}
