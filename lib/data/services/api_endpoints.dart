class ApiEndpoints {
  static const String baseUrl = 'http://34.201.105.52:8081/';
  static const String register = 'api/user/register/';
  static const String username = 'username';
  static const String email = 'email';
  static const String password = 'password';
  static const String confirmPassword = 'password2';
  static const String verifyOtp = 'api/user/verify-otp/';
  static const String otp = 'otp';
  static const String profile = 'api/user/profile/';
  static const String resetPass = 'api/user/changepassword/';
  static const String userId = 'user_id';
  static const String createProduct = 'api/user/create-product/';
  static const String forgotPasswordEmailRequest =
      'api/user/send-reset-password-email/';
  static const String resetPassword = 'api/user/reset-password/';
  static const String title = 'title';
  static const String description = 'description';
  static const String price = 'price';
  static const String seller = 'seller';
  static const String categoryId = 'category_id';
  static const String status = 'status';
  static const String updateProduct = 'api/user/product-update/';
  static const String productId = 'product-id';
  static const String myProducts = 'api/user/myproducts';
  static const String prodId = 'product_id';
  static const String login = 'api/user/login/';
  static const String fetchUserData = '$baseUrl/api/user/data';
  static const String updateUserProfile = '$baseUrl/api/user/update';
  static const String productDelete = 'api/user/product-delete/';
  static const categoryList =
      'api/user/category/'; // Adjust as per your backend
  static const String allProducts = 'api/user/products';
  static const String searchProduct = 'api/user/products/search/';
  static const String sendRequest = 'api/user/product/send-request/';
  static const String product = 'product';
  static const String updateRequest = 'api/user/product-request/update/';
  static const String productDetails = 'api/user/product-details/';
  static const String requestId = 'request_id';
  static const String cancelRequest = 'api/user/product-request/cancel/';
  static const String requestReceived = 'api/user/requests/received/';
  static const String receivedRequested = 'api/user/requests/made/';
  static const String chartsList = 'chat/chats/';
  static const String messagelist = 'chat/message/';
  static const String buyHistory = 'api/user/history/buying/';
  static const String sellHistory = 'api/user/history/selling/';
  static const String productsByCategory = '/api/user/products/by-category/';
}
