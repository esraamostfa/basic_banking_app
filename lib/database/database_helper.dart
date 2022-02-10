import 'dart:async';
import 'package:basic_banking_app/models/customer.dart';
import 'package:basic_banking_app/models/transfer.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqlbrite/sqlbrite.dart';
import 'package:synchronized/synchronized.dart';

class DatabaseHelper {
  static const _databaseName = 'bank_db.db';
  static const _databaseVersion = 1;

  static const customerTable = 'customer';
  static const transferTable = 'transfer';
  static const customerId = 'customerId';
  static const transferId = 'transferId';

  static late BriteDatabase _streamDatabase;

  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static var lock = Lock();

  static Database? _database;

  Future _onCreate(Database db, int version) async {
    await db.execute('''CREATE TABLE $customerTable (
          $customerId INTEGER PRIMARY KEY,
          name TEXT,
          email TEXT,
          currentBalance REAL)
          ''');

    await db.execute('''CREATE TABLE $transferTable (
          $transferId INTEGER PRIMARY KEY,
          receiverId INTEGER,
          senderId INTEGER,
          transferAmount REAL)
          ''');
  }

  // this opens the database (and creates it if it doesn't exist)
  Future<Database> _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, _databaseName);

    // TODO: Remember to turn off debugging before deploying app to store(s).
    //Sqflite.setDebugModeOn(true);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    // Use this object to prevent concurrent access to data
    await lock.synchronized(
      () async {
        // lazily instantiate the db the first time it is accessed
        if (_database == null) {
          _database = await _initDatabase();
          _streamDatabase = BriteDatabase(_database!);
        }
      },
    );
    return _database!;
  }

  Future<BriteDatabase> get streamDatabase async {
    await database;
    return _streamDatabase;
  }

  List<Customer> parseCustomer(List<Map<String, dynamic>> customerMaps) {
    final List<Customer> customers = [];

    for (var customerMap in customerMaps) {
      final customer = Customer.fromJson(customerMap);
      customers.add(customer);
    }

    return customers;
  }

  List<Transfer> parseTransfer(List<Map<String, dynamic>> transferMaps) {
    final List<Transfer> transfers = [];

    for (var transferMap in transferMaps) {
      final transfer = Transfer.fromJson(transferMap);
      transfers.add(transfer);
    }

    return transfers;
  }

  Future<List<Customer>> getAllCustomers() async {
    final db = await instance.streamDatabase;
    final customerMaps = await db.query(customerTable);
    final List<Customer> customers = parseCustomer(customerMaps);
    if(customers.isEmpty) insertDummyData();
    return customers;
  }

  Stream<List<Customer>> watchAllCustomers() async* {
    final db = await instance.streamDatabase;
    yield* db.createQuery(customerTable).mapToList((row) {
      return Customer.fromJson(row);
    });
  }

  Future<List<Transfer>> getAllTransfers() async {
    final db = await instance.streamDatabase;
    final transferMaps = await db.query(transferTable);
    final transfers = parseTransfer(transferMaps);
    return transfers;
  }

  Stream<List<Transfer>> watchAllTransfer() async* {
    final db = await instance.streamDatabase;
    yield* db
        .createQuery(transferTable)
        .mapToList((row) => Transfer.fromJson(row));
  }

  Future<Customer> findCustomerById(int id) async {
    final db = await instance.streamDatabase;
    final customerMaps =
        await db.query(customerTable, where: 'customerId = $id');
    final List<Customer> customers = parseCustomer(customerMaps);
    return customers.first;
  }

  Future<int> insert(String table, Map<String, dynamic> row) async {
    final db = await instance.streamDatabase;
    return db.insert(table, row);
  }

  Future<int> insertCustomer(Customer customer) {
    return insert(customerTable, customer.toJson());
  }

  Future<int> insertTransfer(Transfer transfer) {
    return insert(transferTable, transfer.toJson());
  }


  Future updateCustomer(Customer customer, double currentBalance) async {
    final db = await instance.streamDatabase;
    return db.rawUpdate('''
     UPDATE $customerTable SET currentBalance = $currentBalance WHERE $customerId = ${customer.id}
     ''');
  }

  Future insertDummyData() async {
      insertCustomer(Customer(
          name: "Ahmad Khaled",
          email: "ahmad33@gmail.com",
          currentBalance: 3000.0));
      insertCustomer(Customer(
          name: "Mohammad Ashraf",
          email: "mohammad53@gmail.com",
          currentBalance: 5000.0));
     insertCustomer(Customer(
          name: "Mokhtar Ibrahim",
          email: "mokhtar21@gmail.com",
          currentBalance: 4550.0));
     insertCustomer(Customer(
          name: "Asmaa Helal",
          email: "asmaa29@gmail.com",
          currentBalance: 9500.0));
     insertCustomer(Customer(
          name: "Hazem Sabry",
          email: "hazem15@gmail.com",
          currentBalance: 7350.0));
     insertCustomer(Customer(
          name: "Hend Barkat",
          email: "hend39@gmail.com",
          currentBalance: 3950.0));
     insertCustomer(Customer(
          name: "Hatem Ahmad",
          email: "hatem57@gmail.com",
          currentBalance: 5900.0));
     insertCustomer(Customer(
          name: "Sara Maher",
          email: "sara31@gmail.com",
          currentBalance: 3370.0));
     insertCustomer(Customer(
          name: "Mazen Ahmad",
          email: "mazen95@gmail.com",
          currentBalance: 7500.0));
     insertCustomer(Customer(
          name: "Mai Rashed",
          email: "Mai75@gmail.com",
          currentBalance: 9500.0));
     getAllCustomers();
  }

  void close() {
    _streamDatabase.close();
  }
}
