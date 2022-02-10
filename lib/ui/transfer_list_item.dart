import 'package:basic_banking_app/cubit/app_cubit.dart';
import 'package:basic_banking_app/cubit/app_states.dart';
import 'package:basic_banking_app/models/customer.dart';
import 'package:basic_banking_app/models/transfer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransferListItem extends StatelessWidget {
  final Transfer transfer;

   TransferListItem({
    required this.transfer,
    Key? key
  }) : super(key: key);

  Future<List<Customer>?>? senderReceiver;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        builder: (context, state) {
          var appCubit = AppCubit.get(context);

          return FutureBuilder(
            future: appCubit.getSenderReceiverById(transfer.senderId, transfer.receiverId),
              builder: (BuildContext context,
              AsyncSnapshot<List<Customer?>> snapshot){
                if(!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator(),);
                } else {
                  return Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sender: ${snapshot.data?.first?.name}',
                          style: const TextStyle(fontSize: 19),
                        ),
                        const SizedBox(height: 9,),
                        Text('Receiver: ${snapshot.data?.last?.name}',
                          style: const TextStyle(fontSize: 19),),
                        const SizedBox(height: 9,),
                        Text(
                          'Transfer Amount: ${transfer.transferAmount}',
                          style: const TextStyle(fontSize: 19),),
                      ],
                    ),
                  );
                }
              });
        },
    listener: (context, state) {}
    );
  }
}
