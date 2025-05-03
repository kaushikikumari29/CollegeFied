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
  final products = [].obs; // You can change the type if you have a model
  final ApiClient _apiClient = ApiClient();
  final categories = [].obs; // This will hold the fetched categories
  final allProducts = [].obs;
  final productDetails = {}.obs;
  final requestReceivedChart = [].obs;
  final receivedRequestChart = [].obs;
  final ProfileController _profileController = Get.put(ProfileController());
  RxBool isMyProduct = false.obs;
  final isDeleting = false.obs;


  Future<void> createProduct({
    required String title,
    required String description,
    required double price,
    required int sellerId,
    required String cateId,
    required List<File> prodImage, // You already have the image here
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
        images: prodImage, // <-- Send the image too
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

  Future<void> editProduct(
      {required String title,
      required String description,
      required double price,
      required int sellerId,
      required int productId,
      required String catId}) async {
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
          ApiEndpoints.categoryId: catId
        },
      );

      if (response.statusCode == 200) {
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

  /// ✅ New: Fetch Products Created by Current User
  Future<void> getMyProducts() async {
    isLoading.value = true;
    try {
      final response = await _apiClient.get(
        '${ApiEndpoints.myProducts}',
      );

      if (response.statusCode == 200) {
        products.value = response.data; // You can map to a model if needed
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
    // isLoading.value = true;
    try {
      final response = await _apiClient.get(
        ApiEndpoints.categoryList, // Replace with the correct endpoint
      );

      if (response.statusCode == 200) {
        categories.value =
            response.data; // Map this response to your model if needed
        // Get.snackbar('Success', 'Categories fetched successfully');
      } else {
        Get.snackbar('Error', 'Failed to fetch categories');
      }
    } catch (e) {
      final msg = e is ApiException ? e.message : 'Unexpected error';
      Get.snackbar('Error', msg);
    } finally {
      // isLoading.value = false;
    }
  }

  Future<void> getAllProducts() async {
    isLoading.value = true;
    try {
      final response = await _apiClient
          .get(ApiEndpoints.allProducts); // Replace with actual endpoint

      if (response.statusCode == 200) {
        allProducts.value = response.data;
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
        ApiEndpoints
            .sendRequest, // Make sure this endpoint exists in ApiEndpoints
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
        ApiEndpoints
            .cancelRequest, // Make sure this endpoint exists in ApiEndpoints
        data: {ApiEndpoints.requestId: requestId, ApiEndpoints.status: status},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar('Success', 'Request sent successfully');

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

  Future<void> updateRequest({
    required int requestId,
    required String status,
  }) async {
    isLoading.value = true;
    try {
      final response = await _apiClient.patch(
        ApiEndpoints
            .updateRequest, // Make sure this endpoint exists in ApiEndpoints
        data: {ApiEndpoints.requestId: requestId, ApiEndpoints.status: status},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar('Success', 'Request sent successfully');

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

  Future<void> getProductDetails({
    required int productId,
  }) async {
    isMyProduct.value = false;
    // isLoading.value = true;
    if (myUserId == 0) {
      await _profileController.fetchProfileData();
    }
    try {
      final response = await _apiClient.get(
        ApiEndpoints.productDetails +
            productId
                .toString(), // Make sure this endpoint exists in ApiEndpoints
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        productDetails.value = response.data;
        print("my user id= $myUserId");
        if (productDetails['product']['seller_id'] == myUserId) {
          isMyProduct.value = true;
          print("Its my product");
        }
        update();
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

  Future<void> getRequestReceivedChart() async {
    isLoading.value = true;
    try {
      final response = await _apiClient.get(
        ApiEndpoints
            .requestReceived, // Make sure this endpoint exists in ApiEndpoints
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        requestReceivedChart.value = response.data;
        update();
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

  Future<void> getReceivedRequest() async {
    isLoading.value = true;
    try {
      final response = await _apiClient.get(
        ApiEndpoints
            .receivedRequested, // Make sure this endpoint exists in ApiEndpoints
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        receivedRequestChart.value = response.data;
        update();
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
}
