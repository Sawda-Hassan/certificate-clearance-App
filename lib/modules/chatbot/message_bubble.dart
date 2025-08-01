import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageBubble extends StatelessWidget {
  final dynamic message;
  final bool showTime;

  const MessageBubble({
    super.key,
    required this.message,
    this.showTime = false,
  });

  String _formatTime(DateTime dateTime) {
    final localTime = dateTime.toLocal();
    return DateFormat('h:mm a').format(localTime); // ✅ 4:37 AM style
  }

  @override
  Widget build(BuildContext context) {
    final isUser = message.senderType == 'student';
    final isFromStaff = message.senderType == 'staff';

    final timestamp = message.timestamp != null
        ? DateTime.tryParse(message.timestamp.toString())?.toLocal() ??
            DateTime.now()
        : DateTime.now();

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment:
            isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment:
                isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!isUser) ...[
                Container(
                  width: 32,
                  height: 32,
                  margin: const EdgeInsets.only(right: 8, bottom: 4),
                  decoration: BoxDecoration(
                    color: isFromStaff ? Colors.green : Colors.blue,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    isFromStaff ? Icons.person : Icons.smart_toy,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ],
              Flexible(
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.75,
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isUser
                        ? Colors.blue
                        : (isFromStaff
                            ? Colors.green.shade50
                            : Colors.grey.shade100),
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(18),
                      topRight: const Radius.circular(18),
                      bottomLeft: Radius.circular(isUser ? 18 : 4),
                      bottomRight: Radius.circular(isUser ? 4 : 18),
                    ),
                    border: isFromStaff
                        ? Border.all(color: Colors.green.shade200, width: 1)
                        : null,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (isFromStaff) ...[
                        Text(
                          message.senderName ?? 'Staff',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.green.shade700,
                          ),
                        ),
                        const SizedBox(height: 4),
                      ],
                      Text(
                        message.message ?? '',
                        style: TextStyle(
                          color: isUser ? Colors.white : Colors.black87,
                          fontSize: 15,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (isUser) ...[
                Container(
                  width: 32,
                  height: 32,
                  margin: const EdgeInsets.only(left: 8, bottom: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ],
            ],
          ),
          if (showTime && (isFromStaff || isUser)) ...[
            const SizedBox(height: 4),
            Padding(
              padding: EdgeInsets.only(
                left: isUser ? 0 : 40,
                right: isUser ? 40 : 0,
              ),
              child: Text(
                _formatTime(timestamp),
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
