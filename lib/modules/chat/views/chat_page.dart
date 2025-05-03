import 'package:collegefied/data/models/chart_model.dart';
import 'package:collegefied/modules/chat/views/controller/chart_controller.dart';
import 'package:collegefied/modules/product/controllers/product_controller.dart';
import 'package:collegefied/shared/utils/app_paddings.dart';
import 'package:collegefied/shared/utils/app_sizes.dart';
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
  final TextEditingController _controller = TextEditingController();
  String productName = '';
  int chartId = 0;
  String groupName = '';
  String requestiD='';
  int sellerId=0;
  bool isActive=false;
  final ChartController _chartController = Get.put(ChartController());
  final ProductController _productController = Get.put(ProductController());
  @override
  void initState() {
    productName = Get.arguments[0];
    chartId = Get.arguments[1];
    groupName = Get.arguments[2];
    requestiD=Get.arguments[3]??'';
    sellerId=Get.arguments[4]??0;
    isActive=Get.arguments[5]??false;
    print("seeler id =$sellerId");
    _chartController.fetchMessage(chartId.toString(), groupName);
    super.initState();
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    _controller.clear();
    _chartController.sendMessage(text);
  }

  Widget _buildMessage(String message, bool isMe) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        padding: const EdgeInsets.all(12),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: AppBackButton(),
        title: Row(
          children: [
            Text(
              productName,
              style: AppTextStyles.f16w500,
            ),
          ],
        ),
         actions: [

      isActive?    Obx(() {
              return _chartController.myUserI.value!=sellerId? SizedBox():   InkWell(
            onTap: (){
_productController.updateRequest(
  requestId: int.parse(requestiD), 
  status: 'approved');
            },
            child: Icon(Icons.check,size:20,color: Colors.green,));

          }):SizedBox()
      ,
          SizedBox(width: 20,),
    
     isActive?  Obx(() {
              return _chartController.myUserI.value!=sellerId? SizedBox():   InkWell(
            onTap: (){
_productController.updateRequest(
  requestId: int.parse(requestiD), 
  status: 'rejected');
            },
            child:  Icon(Icons.close,size:20,color: Colors.red,));

          }):SizedBox(),
 
              SizedBox(width: 20,),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              return _chartController.messageList.isEmpty
                  ? Center(child: Text("No Message"))
                  : AnimatedList(
                      key: _chartController.listKey,
                      reverse: true,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      initialItemCount: _chartController.messageList.length,
                      itemBuilder: (context, index, animation) {
                        ChartModel chartModel = _chartController.messageList[index];
                        return SlideTransition(
                          position: animation.drive(
                            Tween<Offset>(
                              begin: const Offset(1, 0),
                              end: Offset.zero,
                            ).chain(CurveTween(curve: Curves.easeOut)),
                          ),
                          child: _buildMessage(
                            chartModel.message,
                            chartModel.isMe,
                          ),
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
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    enabled: isActive,
                    controller: _controller,
                    decoration:  InputDecoration(
                      hintText:isActive? 'Type a message...':"Chat has been closed",
                      border: InputBorder.none,
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
        isActive?        GestureDetector(
                  onTap: _sendMessage,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ):SizedBox(),
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
    super.dispose();
  }
}
