import 'package:basic_banking_app/models/customer.dart';
import 'package:basic_banking_app/models/transfer.dart';

abstract class Repository {

  Future init();

  void close();

  Stream<List<Customer>>? watchAllCustomers();

 Stream<List<Transfer>>? watchAllTransfer();

  Future<List<Customer>>? getAllCustomers();

  Future<List<Transfer>>? getAllTransfer();

  Future<Customer>? findCustomerById(int id);

  Future<int> insertCustomer(Customer customer);

  Future<int> insertTransfer(Transfer transfer);

  Future updateCustomer(Customer customer, double currentBalance);

}