import 'package:collegefied/data/services/api_client.dart';
import 'package:collegefied/data/services/api_endpoints.dart';
import 'package:collegefied/data/services/api_exceptions.dart';
import 'package:collegefied/modules/history/models/history_model.dart';
import 'package:get/get.dart';

class HistoryController extends GetxController {
  final _apiClient = ApiClient();

  final isLoading = false.obs;
  final isBuyHistoryLoaded = false.obs;
  final isSellHistoryLoaded = false.obs;

  final buyHistory = <HistoryModel>[].obs;
  final sellHistory = <HistoryModel>[].obs;

  Future<void> fetchBuyHistory() async {
    if (isBuyHistoryLoaded.value) return;

    isLoading.value = true;
    try {
      final response = await _apiClient.get(ApiEndpoints.buyHistory);
      if (response.statusCode == 200) {
        buyHistory.assignAll(_extractList(response.data));
        isBuyHistoryLoaded.value = true;
      } else {
        Get.snackbar('Error', _extractError(response.data));
      }
    } catch (e) {
      Get.snackbar('Error', e is ApiException ? e.message : 'Unexpected error');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchSellHistory() async {
    if (isSellHistoryLoaded.value) return;

    isLoading.value = true;
    try {
      final response = await _apiClient.get(ApiEndpoints.sellHistory);
      if (response.statusCode == 200) {
        sellHistory.assignAll(_extractList(response.data));
        isSellHistoryLoaded.value = true;
      } else {
        Get.snackbar('Error', _extractError(response.data));
      }
    } catch (e) {
      Get.snackbar('Error', e is ApiException ? e.message : 'Unexpected error');
    } finally {
      isLoading.value = false;
    }
  }

  List<HistoryModel> _extractList(dynamic data) {
    if (data is List) {
      return data.map((item) => HistoryModel.fromJson(item)).toList();
    }
    if (data is Map && data['data'] is List) {
      return (data['data'] as List)
          .map((item) => HistoryModel.fromJson(item))
          .toList();
    }
    return [];
  }

  String _extractError(dynamic data) {
    if (data is Map && data['detail'] != null) return data['detail'];
    return 'Something went wrong';
  }

  @override
  void onInit() {
    super.onInit();
    fetchBuyHistory();
    fetchSellHistory();
  }
}
