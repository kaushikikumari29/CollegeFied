import 'package:collegefied/config/routes/app_routes.dart';
import 'package:collegefied/config/theme/colors.dart';
import 'package:collegefied/modules/product/controllers/product_controller.dart';
import 'package:collegefied/shared/utils/app_text_styles.dart';
import 'package:collegefied/shared/widgets/app_back_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ManageRequestPage extends StatefulWidget {
  const ManageRequestPage({super.key});

  @override
  _ManageRequestPageState createState() => _ManageRequestPageState();
}

class _ManageRequestPageState extends State<ManageRequestPage> {
  final ProductController _productController = Get.put(ProductController());
  @override
  void initState() {
    _productController.getRequestReceivedChart();
    _productController.getReceivedRequest();
    // TODO: implement initState
    super.initState();
  }

  final List<Map<String, String>> _yourRequests = [
    {
      "name": "Kaushiki",
      "lastMessage": "Let's meet tomorrow.",
      "avatarUrl": "https://i.pravatar.cc/300?img=1"
    },
    {
      "name": "John",
      "lastMessage": "How are you?",
      "avatarUrl": "https://i.pravatar.cc/300?img=2"
    },
  ];

  final List<Map<String, String>> _receivedRequests = [
    {
      "name": "Sita",
      "lastMessage": "Finished the project.",
      "avatarUrl": "https://i.pravatar.cc/300?img=3"
    },
    {
      "name": "Amit",
      "lastMessage": "Let's grab lunch!",
      "avatarUrl": "https://i.pravatar.cc/300?img=4"
    },
    {
      "name": "Priya",
      "lastMessage": "Can you send the file?",
      "avatarUrl": "https://i.pravatar.cc/300?img=5"
    },
  ];

  Widget _buildChatList(List<Map<String, String>> chatList) {
    return Obx(() {
      return ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 10),
        itemCount: _productController.receivedRequestChart.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Get.toNamed(AppRoutes.productDetail,
                  arguments: {
                    'id': _productController.receivedRequestChart[index]['product']
                  }
                  );
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
                  _productController.receivedRequestChart[index]['product_name'] ??
                      'Seller name',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
             _productController.receivedRequestChart[index]['status']=='rejected'?'Rejected':
               _productController.receivedRequestChart[index]['status']=='rejected'?'Pending': _productController.receivedRequestChart[index]['status'],
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color:
                    
                    _productController.receivedRequestChart[index]['status']=='rejected'?
                     Colors.red:AppColors.success,
                  ),
                ),
                trailing: Icon(Icons.chevron_right, color: Colors.blueAccent),
              ),
            ),
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: AppBackButton(),
          title: Text('Manage Request', style: AppTextStyles.f18w500),
          bottom: TabBar(
            indicatorColor: Colors.blueAccent,
            labelColor: Colors.blueAccent,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(text: 'Your Requests'),
              Tab(text: 'Received Requests'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildChatList(_yourRequests),
            _buildRequestReceivedChart(_receivedRequests),
          ],
        ),
      ),
    );
  }

  Widget _buildRequestReceivedChart(List<Map<String, String>> chatList) {
    return Obx(() {
      return ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 10),
        itemCount: _productController.requestReceivedChart.length,
        itemBuilder: (context, index) {
          // final chat = chatList[index];
          return GestureDetector(
            onTap: () {
             Get.toNamed(AppRoutes.productDetail,
              arguments: {
                    'id': _productController.requestReceivedChart[index]['product']
                  }
                
                  );
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
                  _productController.requestReceivedChart[index]['product_name'] ??
                      'buyer name',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 2.0),
                  child: Row(
                    children: [
                      _productController.requestReceivedChart[index]
                                  ['status'] ==
                              'rejected'
                          ? SizedBox()
                          : InkWell(
                              onTap: () async {
                                if (_productController
                                            .requestReceivedChart[index]
                                        ['status'] ==
                                    'pending') {
                                  await _productController.updateRequest(
                                    requestId: _productController
                                        .requestReceivedChart[index]['id'],
                                    status: "accepted",
                                    
                                  );
                                  _productController.getRequestReceivedChart();
                                } else {
                                  //navigate to chart page.
                                }
                              },
                              child: Text(
                                _productController.requestReceivedChart[index]
                                            ['status'] ==
                                        'pending'
                                    ? 'Accept'
                                    : "Chat",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                      _productController.requestReceivedChart[index]
                                  ['status'] ==
                              'rejected'
                          ? SizedBox()
                          : SizedBox(
                              width: 20,
                            ),
                      InkWell(
                        onTap: () async {
                          if (_productController.requestReceivedChart[index]
                                  ['status'] ==
                              'rejected') {
                            return;
                          }

                          await _productController.updateRequest(
                            requestId: _productController
                                .requestReceivedChart[index]['id'],
                            status: "rejected",
                            
                          );
                          _productController.getRequestReceivedChart();
                        },
                        child: Text(
                          _productController.requestReceivedChart[index]
                                      ['status'] ==
                                  'rejected'
                              ? 'Rejected'
                              : "Reject",
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.red,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    ],
                  ),
                ),
                trailing: Icon(Icons.chevron_right, color: Colors.blueAccent),
              ),
            ),
          );
        },
      );
    });
  }
}
