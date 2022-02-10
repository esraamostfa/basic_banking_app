
class Customer {

  int? id;
  late String name;
  late String email;
  late double currentBalance;

  Customer({
    this.id,
    required this.name,
    required this.email,
    required this.currentBalance
  });

   Customer.fromJson(Map<String, dynamic> json) {
      id = json['customerId'];
      name = json['name'];
      email = json['email'];
      currentBalance = json['currentBalance'];
  }

  Map<String, dynamic> toJson () =>
      {
        'name' : name,
        'email' : email,
        'currentBalance' : currentBalance
      };

  @override
  bool operator ==(Object other) => other is Customer && other.name == name;

  @override
  int get hashCode => name.hashCode;
}