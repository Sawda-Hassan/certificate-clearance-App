class ChatMessage {
  final String id;
  final String senderId;
  final String senderType;
  final String message;
  final String department;
  final String? receiverId;
  final bool? isRead;
  final String? timestamp;

  ChatMessage({
    required this.id,
    required this.senderId,
    
    required this.senderType,
    required this.message,
    required this.department,
    this.receiverId,
    this.isRead,
    this.timestamp,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['_id'],
      senderId: json['senderId'],
      senderType: json['senderType'],
      message: json['message'],
      department: json['department'],
      receiverId: json['receiverId'],
      isRead: json['isRead'],
      timestamp: json['timestamp'],
    );
  }
}