import 'dart:convert';
import 'dart:io';

import 'package:collegefied/config/global_variable.dart';
import 'package:collegefied/data/services/api_client.dart';
import 'package:collegefied/data/services/api_endpoints.dart';
import 'package:collegefied/data/services/api_exceptions.dart';
import 'package:collegefied/modules/profile/controllers/profile_controller.dart';
import 'package:collegefied/shared/services/shared_pref.dart';
import 'package:get/get.dart';

class ProductController extends GetxController {
  final isLoading = false.obs;
  final isDeleting = false.obs;
  final products = [].obs;
  final allProducts = [].obs;
  final filteredProducts = [].obs;
  final categories = [].obs;
  final categoryProducts = <dynamic>[].obs;
  final productDetails = {}.obs;
  final requestReceivedChart = [].obs;
  final receivedRequestChart = [].obs;
  final ProfileController _profileController = Get.put(ProfileController());
  RxBool isMyProduct = false.obs;
  final ApiClient _apiClient = ApiClient();

  @override
  void onInit() {
    super.onInit();
    getAllProducts();
  }

  Future<void> createProduct({
    required String title,
    required String description,
    required double price,
    required int sellerId,
    required String cateId,
    required List<File> prodImage,
  }) async {
    isLoading.value = true;
    try {
      final response = await _apiClient.postWithImage(
        ApiEndpoints.createProduct,
        data: {
          ApiEndpoints.title: title,
          ApiEndpoints.description: description,
          ApiEndpoints.price: price,
          ApiEndpoints.seller: sellerId,
          ApiEndpoints.categoryId: cateId,
        },
        images: prodImage,
      );

      if (response.statusCode == 201) {
        Get.snackbar('Success', 'Product created successfully');
        getMyProducts();
      } else {
        Get.snackbar('Error', 'Failed to create product');
      }
    } catch (e) {
      final msg = e is ApiException ? e.message : 'Unexpected error';
      Get.snackbar('Error', msg);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> editProduct({
    required String title,
    required String description,
    required double price,
    required int sellerId,
    required int productId,
    required String catId,
    required List<File>? images,
  }) async {
    isLoading.value = true;
    try {
      final response = await _apiClient.patch(
        ApiEndpoints.updateProduct,
        data: {
          ApiEndpoints.title: title,
          ApiEndpoints.description: description,
          ApiEndpoints.price: price,
          ApiEndpoints.seller: sellerId,
          ApiEndpoints.prodId: productId,
          ApiEndpoints.categoryId: catId,
        },
      );

      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Product updated successfully');
        getMyProducts();
      } else {
        Get.snackbar('Error', 'Failed to update product');
      }
    } catch (e) {
      final msg = e is ApiException ? e.message : 'Unexpected error';
      Get.snackbar('Error', msg);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProduct({
    required int productId,
    required String status,
  }) async {
    isLoading.value = true;
    try {
      final response = await _apiClient.patch(
        ApiEndpoints.updateProduct,
        data: {
          ApiEndpoints.prodId: productId,
          ApiEndpoints.status: status,
        },
      );

      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Product updated successfully');
        getMyProducts();
      } else {
        Get.snackbar('Error', 'Failed to update product');
      }
    } catch (e) {
      final msg = e is ApiException ? e.message : 'Unexpected error';
      Get.snackbar('Error', msg);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteProduct({
    required int productId,
  }) async {
    isDeleting.value = true;
    try {
      final response = await _apiClient.delete(
        ApiEndpoints.productDelete,
        data: {
          ApiEndpoints.prodId: productId,
        },
      );

      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Product deleted successfully');
        getMyProducts();
      } else {
        Get.snackbar('Error', 'Failed to delete product');
      }
    } catch (e) {
      final msg = e is ApiException ? e.message : 'Unexpected error';
      Get.snackbar('Error', msg);
    } finally {
      isDeleting.value = false;
    }
  }

  Future<void> getMyProducts() async {
    isLoading.value = true;
    try {
      final response = await _apiClient.get(ApiEndpoints.myProducts);

      if (response.statusCode == 200) {
        products.value = response.data;
      } else {
        Get.snackbar('Error', 'Failed to fetch products');
      }
    } catch (e) {
      final msg = e is ApiException ? e.message : 'Unexpected error';
      Get.snackbar('Error', msg);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getCategories() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.categoryList);

      if (response.statusCode == 200) {
        categories.value = response.data;
      } else {
        Get.snackbar('Error', 'Failed to fetch categories');
      }
    } catch (e) {
      final msg = e is ApiException ? e.message : 'Unexpected error';
      Get.snackbar('Error', msg);
    }
  }

  Future<void> getAllProducts() async {
    isLoading.value = true;
    try {
      final response = await _apiClient.get(ApiEndpoints.allProducts);

      if (response.statusCode == 200) {
        allProducts.value = response.data;
        filteredProducts.value = response.data;
        update();
      } else {
        Get.snackbar('Error', 'Failed to fetch all products');
      }
    } catch (e) {
      final msg = e is ApiException ? e.message : 'Unexpected error';
      Get.snackbar('Error', msg);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sendProductRequest({
    required int productId,
  }) async {
    isLoading.value = true;
    try {
      final response = await _apiClient.post(
        ApiEndpoints.sendRequest,
        data: {
          ApiEndpoints.product: productId,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar('Success', 'Request sent successfully');
        getProductDetails(productId: productId);
        return;
      }

      if (response.statusCode == 400) {
        Get.snackbar('Failed', 'Request already sent');
      } else {
        Get.snackbar('Error', 'Failed to send request');
      }
    } catch (e) {
      final msg = e is ApiException ? e.message : 'Unexpected error';
      Get.snackbar('Error', msg);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> cancelRequest({
    required int requestId,
    required String status,
    required int productId,
  }) async {
    isLoading.value = true;
    try {
      final response = await _apiClient.patch(
        ApiEndpoints.cancelRequest,
        data: {
          ApiEndpoints.requestId: requestId,
          ApiEndpoints.status: status,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar('Success', 'Request cancelled successfully');
        return;
      }

      if (response.statusCode == 400) {
        Get.snackbar('Failed', 'Request already handled');
      } else {
        Get.snackbar('Error', 'Failed to cancel request');
      }
    } catch (e) {
      final msg = e is ApiException ? e.message : 'Unexpected error';
      Get.snackbar('Error', msg);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateRequest({
    required int requestId,
    required String status,
  }) async {
    isLoading.value = true;
    try {
      final response = await _apiClient.patch(
        ApiEndpoints.updateRequest,
        data: {
          ApiEndpoints.requestId: requestId,
          ApiEndpoints.status: status,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar('Success', 'Request updated successfully');
        return;
      }

      if (response.statusCode == 400) {
        Get.snackbar('Failed', 'Request already handled');
      } else {
        Get.snackbar('Error', 'Failed to update request');
      }
    } catch (e) {
      final msg = e is ApiException ? e.message : 'Unexpected error';
      Get.snackbar('Error', msg);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getProductDetails({
    required int productId,
  }) async {
    isMyProduct.value = false;

    if (myUserId == 0) {
      await _profileController.fetchProfileData();
    }

    try {
      final response = await _apiClient.get(
        ApiEndpoints.productDetails + productId.toString(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        productDetails.value = response.data;
        if (productDetails['product']['seller_id'] == myUserId) {
          isMyProduct.value = true;
        }
        update();
        return;
      }

      if (response.statusCode == 400) {
        Get.snackbar('Failed', 'Bad request');
      } else {
        Get.snackbar('Error', 'Failed to fetch product details');
      }
    } catch (e) {
      final msg = e is ApiException ? e.message : 'Unexpected error';
      Get.snackbar('Error', msg);
    }
  }

  Future<void> getRequestReceivedChart() async {
    isLoading.value = true;
    try {
      final response = await _apiClient.get(ApiEndpoints.requestReceived);

      if (response.statusCode == 200 || response.statusCode == 201) {
        requestReceivedChart.value = response.data;
        update();
        return;
      }

      if (response.statusCode == 400) {
        Get.snackbar('Failed', 'Request already sent');
      } else {
        Get.snackbar('Error', 'Failed to fetch chart');
      }
    } catch (e) {
      final msg = e is ApiException ? e.message : 'Unexpected error';
      Get.snackbar('Error', msg);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getReceivedRequest() async {
    isLoading.value = true;
    try {
      final response = await _apiClient.get(ApiEndpoints.receivedRequested);

      if (response.statusCode == 200 || response.statusCode == 201) {
        receivedRequestChart.value = response.data;
        update();
        return;
      }

      if (response.statusCode == 400) {
        Get.snackbar('Failed', 'Request already sent');
      } else {
        Get.snackbar('Error', 'Failed to fetch received requests');
      }
    } catch (e) {
      final msg = e is ApiException ? e.message : 'Unexpected error';
      Get.snackbar('Error', msg);
    } finally {
      isLoading.value = false;
    }
  }

  void searchProduct({String query = ''}) {
    if (query.isEmpty) {
      filteredProducts.value = allProducts;
      return;
    }

    final lowerQuery = query.toLowerCase();

    filteredProducts.value = allProducts.where((product) {
      final title = (product['title'] ?? '').toString().toLowerCase();
      final description =
          (product['description'] ?? '').toString().toLowerCase();
      return title.contains(lowerQuery) || description.contains(lowerQuery);
    }).toList();
  }

  Future<void> getProductsByCategory(String category) async {
    try {
      isLoading.value = true;
      final response = await _apiClient.get(
        '${ApiEndpoints.productsByCategory}?category=$category',
      );

      if (response.statusCode == 200) {
        categoryProducts.value = response.data;
      } else {
        categoryProducts.value = [];
        Get.snackbar('Error', 'Failed to fetch products');
      }
    } catch (e) {
      categoryProducts.value = [];
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
