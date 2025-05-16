import 'package:collegefied/data/models/chart_model.dart';
import 'package:collegefied/modules/chat/views/controller/chart_controller.dart';
import 'package:collegefied/modules/product/controllers/product_controller.dart';
import 'package:collegefied/shared/utils/app_paddings.dart';
import 'package:collegefied/shared/utils/app_text_styles.dart';
import 'package:collegefied/shared/widgets/app_back_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChartController _chartController = Get.put(ChartController());
  final ProductController _productController = Get.put(ProductController());

  late final String productName;
  late final int chartId;
  late final String groupName;
  late final String requestId;
  late final int sellerId;
  late final bool isActive;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments;
    productName = args[0];
    chartId = args[1];
    groupName = args[2];
    requestId = args[3] ?? '';
    sellerId = args[4] ?? 0;
    isActive = args[5] ?? false;

    debugPrint("Seller ID: $sellerId");

    _chartController.fetchMessage(chartId.toString(), groupName);
  }

  void _sendMessage() {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    _messageController.clear();
    _chartController.sendMessage(message);
  }

  Widget _buildMessage(String message, bool isMe) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        padding: const EdgeInsets.all(12),
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
        decoration: BoxDecoration(
          color: isMe ? Colors.blueAccent : Colors.grey.shade300,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isMe ? 16 : 0),
            bottomRight: Radius.circular(isMe ? 0 : 16),
          ),
        ),
        child: Text(
          message,
          style: TextStyle(color: isMe ? Colors.white : Colors.black87),
        ),
      ),
    );
  }

  Widget _buildApprovalActions() {
    final isMyChat = _chartController.myUserI.value == sellerId;

    if (!isActive || !isMyChat) return const SizedBox();

    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.check, size: 20, color: Colors.green),
          onPressed: () => _productController.updateRequest(
            requestId: int.parse(requestId),
            status: 'approved',
          ),
        ),
        IconButton(
          icon: const Icon(Icons.close, size: 20, color: Colors.red),
          onPressed: () => _productController.updateRequest(
            requestId: int.parse(requestId),
            status: 'rejected',
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        title: Text(productName, style: AppTextStyles.f16w500),
        actions: [
          Obx(() => _buildApprovalActions()),
          const SizedBox(width: 20)
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              final messages = _chartController.messageList;

              if (messages.isEmpty) {
                return const Center(child: Text("No Message"));
              }

              return AnimatedList(
                
                key: _chartController.listKey,
                reverse: true,
                padding: const EdgeInsets.symmetric(vertical: 10),
                initialItemCount: messages.length,
                itemBuilder: (context, index, animation) {
                  final message = messages[index];
                  return SlideTransition(
                    position: animation.drive(
                      Tween<Offset>(
                        begin: const Offset(1, 0),
                        end: Offset.zero,
                      ).chain(CurveTween(curve: Curves.easeOut)),
                    ),
                    child: _buildMessage(message.message, message.isMe),
                  );
                },
              );
            }),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(
              AppPaddings.medium,
              AppPaddings.small,
              AppPaddings.medium,
              AppPaddings.medium,
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    enabled: isActive,
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: isActive
                          ? 'Type a message...'
                          : "Chat has been closed",
                      border: InputBorder.none,
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                if (isActive)
                  GestureDetector(
                    onTap: _sendMessage,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: Colors.blueAccent,
                        shape: BoxShape.circle,
                      ),
                      child:
                          const Icon(Icons.send, color: Colors.white, size: 18),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _chartController.disconnectSocket();
    _messageController.dispose();
    super.dispose();
  }
}
