import 'package:collegefied/config/routes/app_routes.dart';
import 'package:collegefied/config/theme/colors.dart';
import 'package:collegefied/modules/chat/views/controller/chart_controller.dart';
import 'package:collegefied/shared/utils/app_text_styles.dart';
import 'package:collegefied/shared/widgets/app_back_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChartsList extends StatefulWidget {
  const ChartsList({super.key});

  @override
  State<ChartsList> createState() => _ChartsListState();
}

class _ChartsListState extends State<ChartsList> {
  final ChartController _chartController = Get.put(ChartController());

  @override
  void initState() {
    _chartController.fetchChartList();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: AppBackButton(),
        title: Text('Chats', style: AppTextStyles.f18w500),
       
      ),
      body: _buildChatList(),
    );
  }

  Widget _buildChatList() {
    return Obx(() {
      return ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 10),
        itemCount: _chartController.chartsList.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              print( _chartController.chartsList[index]);
              Get.toNamed(AppRoutes.chat,
                  arguments: [
                    _chartController.chartsList[index]['product_name'],
                     _chartController.chartsList[index]['id'],
                     _chartController.chartsList[index]['group_name']??0,
                     _chartController.chartsList[index]['request_id'].toString(),
                     _chartController.chartsList[index]['seller'],
                     _chartController.chartsList[index]['is_active']
                  ]);
            },
            child: Card(
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 3,
              child: ListTile(
                contentPadding: const EdgeInsets.all(10),
                leading: CircleAvatar(
                    // backgroundImage: NetworkImage(chat['avatarUrl']!),
                    ),
                title: Text(
                  _chartController.chartsList[index]['product_name'] ??
                      'Seller name',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                trailing: Icon(Icons.circle,
                    color: _chartController.chartsList[index]['is_active']
                        ? Colors.green
                        : Colors.grey),
              ),
            ),
          );
        },
      );
    });
  }
}
