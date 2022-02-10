import 'package:basic_banking_app/database/database_helper.dart';
import 'package:basic_banking_app/database/repository/repository.dart';
import 'package:basic_banking_app/models/customer.dart';
import 'package:basic_banking_app/models/transfer.dart';

class SqliteRepository extends Repository{

  final dbHelper = DatabaseHelper.instance;

  @override
  Future init() async {
    await dbHelper.database;
    return Future.value();
  }

  @override
  void close() {
    dbHelper.close();
  }

  @override
  Stream<List<Customer>>? watchAllCustomers() {
    return dbHelper.watchAllCustomers();
  }

  @override
    Stream<List<Transfer>>? watchAllTransfer() {
    return dbHelper.watchAllTransfer();
  }

  @override
  Future<List<Customer>>? getAllCustomers() {
    return dbHelper.getAllCustomers();
  }

  @override
  Future<List<Transfer>>? getAllTransfer() {
    return dbHelper.getAllTransfers();
  }

  @override
  Future<Customer>? findCustomerById(int id) {
    return dbHelper.findCustomerById(id);
  }

  @override
  Future<int> insertCustomer(Customer customer) {
    return Future(() async {

      final id = await dbHelper.insertCustomer(customer);
      customer.id = id;

      return id;
    });
  }

  @override
  Future<int> insertTransfer(Transfer transfer) {
    return Future(() async {

      final id = await dbHelper.insertTransfer(transfer);
      transfer.id = id;

      return id;
    });
  }

  @override
  Future updateCustomer(Customer customer, double currentBalance) {
    return dbHelper.updateCustomer(customer, currentBalance);
  }

}