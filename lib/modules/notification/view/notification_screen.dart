/*mport '../controller/notification_controller.dart';

class NotificationPage extends StatelessWidget {
  final ctrl = Get.put(NotificationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Notifications")),
      body: Obx(() {
        if (ctrl.isLoading.value) return Center(child: CircularProgressIndicator());
        if (ctrl.notifications.isEmpty) return Center(child: Text("No notifications"));

        return ListView.builder(
          itemCount: ctrl.notifications.length,
          itemBuilder: (context, index) {
            final note = ctrl.notifications[index];
            return ListTile(
              title: Text(note.message),
              subtitle: Text(note.type),
              trailing: note.isRead
                  ? Icon(Icons.check, color: Colors.green)
                  : TextButton(
                      onPressed: () => ctrl.markAsRead(note.id),
                      child: Text("Mark as read"),
                    ),
            );
          },
        );
      }),
    );
  }
}
*/