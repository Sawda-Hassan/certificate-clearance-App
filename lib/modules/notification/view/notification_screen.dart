import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../controller/notification_controller.dart';
import '../model/notification_model.dart';
import '../../Final Clearance Status/veiw/final_clearance_status.dart';
import '../../notification_detail/notification_detail_screen.dart';
import '../../../routes/app_routes.dart';
class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NotificationController());
    final box = GetStorage();
    final studentId = box.read('studentId');

    // Fetch notifications when screen is built
    controller.fetchNotifications(studentId);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
      final route = Get.arguments?['returnToRoute'] ?? AppRoutes.finalStatus;
      Get.offAllNamed(route);
    },
        ),
        title: const Text('Notifications'),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 24),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 26, 14, 94),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.notifications.isEmpty) {
          return const Center(child: Text('No notifications found.'));
        }

        return ListView.separated(
          padding: const EdgeInsets.all(10),
          separatorBuilder: (_, __) => const Divider(height: 0),
          itemCount: controller.notifications.length,
          itemBuilder: (context, index) {
            final NotificationModel notif = controller.notifications[index];

            return ListTile(
              leading: Icon(
                notif.isRead ? Icons.notifications_none : Icons.notifications_active,
                color: notif.isRead ? Colors.grey : const Color.fromARGB(255, 11, 7, 68),
              ),
              title: Text(
                notif.type,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                notif.message,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: Text(
                _formatTimeAgo(notif.createdAt),
                style: const TextStyle(color: Colors.grey),
              ),
              onTap: () async {
                // ✅ Mark as read
                await controller.markNotificationAsRead(notif.id);
                controller.fetchNotifications(studentId);

                // ✅ Navigate to detail screen with full data
                Get.to(() => NotificationDetailScreen(notification: notif));
              },
            );
          },
        );
      }),
    );
  }

  String _formatTimeAgo(DateTime timestamp) {
    final diff = DateTime.now().difference(timestamp);
    if (diff.inSeconds < 60) return 'now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}
