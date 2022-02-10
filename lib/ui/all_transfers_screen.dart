import 'package:basic_banking_app/cubit/app_cubit.dart';
import 'package:basic_banking_app/cubit/app_states.dart';
import 'package:basic_banking_app/models/transfer.dart';
import 'package:basic_banking_app/ui/transfer_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AllTransfersScreen extends StatelessWidget {
  const AllTransfersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        builder: (context, state){
          List<Transfer> transfers = AppCubit.get(context).transfers;
          if(transfers.isEmpty) {
            return const Center(child: Text('No Transfers Yet!'),);
          }else{
            return ListView.separated(
                itemBuilder: (context, index) => TransferListItem(transfer: transfers[index]),
                separatorBuilder: (context, index) => const Divider(),
                itemCount: transfers.length
            );
          }
        },
        listener: (context, state) {}
    );
  }
}
