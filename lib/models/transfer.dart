
class Transfer {
  late int? id;
  late int receiverId;
  late int senderId;
  late double transferAmount;

  Transfer({
    this.id,
    required this.receiverId,
    required this.senderId,
    required this.transferAmount
  }
      );

  Transfer.fromJson(Map<String, dynamic> json) {
    id = json['transferId'];
    receiverId = json['receiverId'];
    senderId = json['senderId'];
    transferAmount = json['transferAmount'];
  }

  Map<String, dynamic> toJson() => {
    'receiverId' : receiverId,
    'senderId' : senderId,
    'transferAmount' : transferAmount
  };
}