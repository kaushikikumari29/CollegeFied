import 'dart:async';
import 'dart:convert';

import 'package:collegefied/data/models/chart_model.dart';
import 'package:collegefied/data/services/api_client.dart';
import 'package:collegefied/data/services/api_endpoints.dart';
import 'package:collegefied/data/services/api_exceptions.dart';
import 'package:collegefied/modules/profile/controllers/profile_controller.dart';
import 'package:collegefied/socket/socket_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChartController extends GetxController {
  final chartsList = [].obs;
  final isloading = true.obs;
  final ApiClient _apiClient = ApiClient();
  final SocketService _socketService = SocketService();
  final GlobalKey<AnimatedListState> listKey = GlobalKey();
  RxList<ChartModel> messageList = <ChartModel>[].obs;
  StreamController<String> chartStream = StreamController<String>.broadcast();
  final ProfileController _profileController = Get.put(ProfileController());
  RxInt myUserI=0.obs;
  @override
  void onClose() {
    super.onClose();
    disconnectSocket();
  }

  void fetchChartList() async {
    isloading.value = true;
    try {
      final response = await _apiClient.get(ApiEndpoints.chartsList);
      if (response.statusCode == 200) {
        chartsList.value = response.data;
      } else {
        Get.snackbar('Error', 'Failed to fetch products');
      }
    } catch (e) {
      final msg = e is ApiException ? e.message : 'Unexpected error';
      Get.snackbar('Error', msg);
    } finally {
      isloading.value = false;
    }
  }

  void fetchMessage(String messageId, String groupName) async {
    isloading.value = true;
    await _profileController.fetchProfileData();
    myUserI.value= _profileController.profileData['user'];
    try {
      final response = await _apiClient.get(ApiEndpoints.messagelist + messageId);
      if (response.statusCode == 200) {
        List messages = response.data;
        messageList.clear();
        messages = messages.reversed.toList();
        for (var msg in messages) {
          messageList.add(
            ChartModel(
              message: msg['content'],
              messageId: msg['id'],
              isMe: msg['sender'].toString() == _profileController.profileData['user'].toString(),
              time: msg['timestamp'].toString(),
            ),
          );
        }
        update();
        connectSocket(groupName);
      } else {
        Get.snackbar('Error', 'Failed to fetch messages');
      }
    } catch (e) {
      final msg = e is ApiException ? e.message : 'Unexpected error';
      Get.snackbar('Error', msg);
    } finally {
      isloading.value = false;
    }
  }

  void sendMessage(String message) {
    if (message.trim().isEmpty) return;

    _socketService.sendMessage(message);

    final insertIndex = 0;
    messageList.insert(
      insertIndex,
      ChartModel(
        message: message,
        messageId: 0,
        isMe: true,
        time: '',
      ),
    );

    Future.delayed(const Duration(milliseconds: 50), () {
      listKey.currentState?.insertItem(
        insertIndex,
        duration: const Duration(milliseconds: 300),
      );
    });
  }

  void connectSocket(String groupName) {
    _socketService.connect(groupName, chartStream);
    listenSocketMessages();
  }

  void disconnectSocket() {
    try {
      if (!chartStream.isClosed) {
        chartStream.close();
      }
    } catch (e) {
      print('Error closing stream: $e');
    }
    _socketService.disconnect();
  }

  void listenSocketMessages() {
    chartStream.stream.listen(
      (val) {
        try {
          final insertIndex = 0;
          final obj = jsonDecode(val);
          
          if (obj['type'] != 'info') {
            if (obj['sender'].toString().trim() != _profileController.profileData['username'].toString().trim()) {
              messageList.insert(
                insertIndex,
                ChartModel(
                  message: obj['message'],
                  messageId: 0,
                  isMe: false,
                  time: '',
                ),
              );

              Future.delayed(const Duration(milliseconds: 50), () {
                listKey.currentState?.insertItem(
                  insertIndex,
                  duration: const Duration(milliseconds: 300),
                );
              });
            }
          }
        } catch (e) {
          print('Error parsing socket message: $e');
        }
      },
      onError: (error) {
        print('Socket Listen Error: $error');
      },
      cancelOnError: true,
    );
  }
}
