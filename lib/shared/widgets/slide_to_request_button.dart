import 'package:collegefied/config/routes/app_routes.dart';
import 'package:collegefied/config/theme/colors.dart';
import 'package:collegefied/modules/product/controllers/product_controller.dart';
import 'package:collegefied/shared/utils/app_sizes.dart';
import 'package:collegefied/shared/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SlideToRequestButton extends StatefulWidget {
  final double height;
  final double width;
  final isCompleted;
  final int productId;
  final int requestId;

  const SlideToRequestButton(
      {super.key,
      this.height = AppSizes.buttonSize,
      this.width = double.infinity,
      required this.isCompleted,
      required this.productId,
      required this.requestId
      });

  @override
  State<SlideToRequestButton> createState() => _SlideToRequestButtonState();
}

class _SlideToRequestButtonState extends State<SlideToRequestButton>
    with SingleTickerProviderStateMixin {
  double _dragX = 0;
  bool _isCompleted = false;
  late AnimationController _gradientController;
  final ProductController _productController = Get.put(ProductController());

  @override
  void initState() {
    super.initState();
    // _isCompleted=widget.isCompleted;
    _gradientController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _gradientController.dispose();
    super.dispose();
  }

  _onDragEnd() {
    if (_isCompleted || widget.isCompleted) {
      if (_dragX > widget.width * 0.6) {
        setState(() {
          _dragX = widget.width - AppSizes.buttonSize;
          _isCompleted = true;
        });
        //  _productController.cancelReqest(requestId: widget.requestId, status: "rejected");
        // print("The product is requested");
        // Get.toNamed(AppRoutes.chat);
      } else {
        setState(() {
          _dragX = 0;
        });
      }
      return;
    }
    if (_dragX > widget.width * 0.6) {
      setState(() {
        _dragX = widget.width - AppSizes.buttonSize;
        _isCompleted = true;
      });
      _productController.sendProductRequest(productId: widget.productId);
      // print("The product is requested");
      // Get.toNamed(AppRoutes.chat);
    } else {
      setState(() {
        _dragX = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: widget.height,
          width: widget.width,
          decoration: BoxDecoration(
            color: AppColors.success,
            borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
            gradient: !_isCompleted
                ? LinearGradient(
                    colors: [
                      AppColors.success,
                      AppColors.primary,
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    stops: [
                      (_dragX / widget.width).clamp(0.0, 1.0),
                      (_dragX / widget.width + 0.2).clamp(0.0, 1.0),
                    ],
                  )
                : null,
          ),
          alignment: Alignment.center,
          child: Text(
            _isCompleted
                ? "Canceled Request!"
                : widget.isCompleted
                    ? "Slide to Cancel Request"
                    : "Slide to Request Product",
            style: AppTextStyles.f14w500.copyWith(color: Colors.white),
          ),
        ),
        if (!_isCompleted)
          Positioned(
            left: _dragX,
            child: GestureDetector(
              onHorizontalDragUpdate: (details) {
                setState(() {
                  _dragX += details.delta.dx;
                  _dragX = _dragX.clamp(0, widget.width - AppSizes.buttonSize);
                });
              },
              onHorizontalDragEnd: (_) => _onDragEnd(),
              child: ScaleTransition(
                scale: Tween(begin: 1.0, end: 1.1).animate(CurvedAnimation(
                    parent: _gradientController, curve: Curves.easeInOut)),
                child: Container(
                  height: AppSizes.buttonSize,
                  width: AppSizes.buttonSize,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 3),
                    gradient: const LinearGradient(
                      colors: [
                        AppColors.primary,
                        AppColors.primary,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(45),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    _isCompleted ? Icons.check : Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
