import 'package:basic_banking_app/models/customer.dart';
import 'package:basic_banking_app/ui/customers_details_screen.dart';
import 'package:flutter/material.dart';

class CustomersListItem extends StatelessWidget {

  final Customer customer;
  final List<Customer> customers;

  const CustomersListItem({
    required this.customer,
    required this.customers,
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(
                builder: (context) => CustomerDetailsScreen(customer: customer, customers: customers,)
            )
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  customer.name,
                style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
            Text(
                customer.email,
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
            const Icon(Icons.arrow_forward_ios_rounded)
          ],
        ),
      ),
    );
  }
}
