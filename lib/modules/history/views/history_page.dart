import 'package:collegefied/modules/history/controllers/history_controller.dart';
import 'package:collegefied/modules/history/models/history_model.dart';
import 'package:collegefied/modules/history/views/widgets/history_item_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:collegefied/shared/utils/app_text_styles.dart';
import 'package:collegefied/shared/utils/app_paddings.dart';
import 'package:collegefied/shared/widgets/app_back_button.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final HistoryController _historyController = Get.find<HistoryController>();

  final List<Tab> _tabs = const [
    Tab(text: 'Buy History'),
    Tab(text: 'Sell History'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  Widget _buildList(List<HistoryModel> list) {
    if (list.isEmpty) {
      return const Center(child: Text("No History Found"));
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: AppPaddings.pagePadding),
      child: ListView.separated(
        itemCount: list.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final item = list[index];
          return Padding(
            padding: const EdgeInsets.fromLTRB(AppPaddings.pagePadding,
                AppPaddings.pagePadding, AppPaddings.pagePadding, 0),
            child: HistoryCard(
              history: item,
            ),
          );
        },
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),

        title: Padding(
          padding: const EdgeInsets.only(top: AppPaddings.small),
          child: Text('History', style: AppTextStyles.f16w500),
        ),
        bottom: TabBar(
          indicatorSize: TabBarIndicatorSize.tab,
          controller: _tabController,
          tabs: _tabs,
          labelStyle: AppTextStyles.f16w500,
          unselectedLabelStyle: AppTextStyles.f14w400,
          indicatorColor: Colors.blueAccent,
        ),
      ),
      body: Obx(() {
        // Show loader only while both lists are loading for the first time
        if (_historyController.isLoading.value &&
            _historyController.buyHistory.isEmpty &&
            _historyController.sellHistory.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return TabBarView(
          controller: _tabController,
          children: [
            _buildList(_historyController.buyHistory),
            _buildList(_historyController.sellHistory),
          ],
        );
      }),
    );
  }
}
