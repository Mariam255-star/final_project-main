import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_color.dart';
import '../../../core/utils/text_style.dart';
import '../../../models/product_model.dart';
import '../../../services/product/product_details_service.dart';
import '../../../services/product/product_cart_service.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Product product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  late int _quantity;

  @override
  void initState() {
    super.initState();
    _quantity = 1;
  }

  /// Handle add to cart action
  void _handleAddToCart() {
    try {
      ProductCartService.addToCart(widget.product, quantity: _quantity);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${widget.product.name} x$_quantity added to cart!'),
          duration: const Duration(seconds: 2),
          backgroundColor: AppColor.primaryColor,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error adding to cart: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  /// Build rating section with stars
  Widget _buildRatingSection() {
    final ratingStars = ProductDetailsService.getRatingStarsCount(
      widget.product.rating,
    );
    final ratingDescription = ProductDetailsService.getRatingDescription(
      widget.product.rating,
    );

    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              ProductDetailsService.getRatingDisplayText(widget.product.rating),
              style: TextStyles.subtitle(color: AppColor.primaryColor),
            ),
            const SizedBox(height: 4),
            Text(
              ratingDescription,
              style: TextStyles.caption(color: Colors.grey),
            ),
          ],
        ),
        const SizedBox(width: 16),
        Row(
          children: List.generate(
            5,
            (index) => Icon(
              index < ratingStars ? Icons.star : Icons.star_border,
              color: AppColor.primaryColor,
              size: 16,
            ),
          ),
        ),
      ],
    );
  }

  /// Build specifications section
  Widget _buildSpecificationsSection() {
    final specs = ProductDetailsService.getSpecifications(widget.product);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Specifications', style: TextStyles.subtitle()),
        const SizedBox(height: 12),
        ...specs.map((spec) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _buildSpecRow(spec['label']!, spec['value']!),
          );
        }).toList(),
      ],
    );
  }

  /// Build single spec row
  Widget _buildSpecRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyles.caption(color: Colors.grey)),
        Text(value, style: TextStyles.body(color: Colors.black)),
      ],
    );
  }

  /// Build quantity selector
  Widget _buildQuantitySelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: _quantity > 1 ? () => setState(() => _quantity--) : null,
            child: Icon(
              Icons.remove,
              size: 20,
              color: _quantity > 1 ? Colors.black : Colors.grey,
            ),
          ),
          const SizedBox(width: 16),
          Text(_quantity.toString(), style: TextStyles.subtitle()),
          const SizedBox(width: 16),
          GestureDetector(
            onTap: () => setState(() => _quantity++),
            child: const Icon(Icons.add, size: 20, color: Colors.black),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isValidProduct = ProductDetailsService.isValidProduct(widget.product);

    if (!isValidProduct) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => context.pop(),
          ),
        ),
        body: const Center(child: Text('Invalid product data')),
      );
    }

    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 🟢 Product Image
              Center(
                child: Container(
                  width: double.infinity,
                  height: 250,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey.shade200,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      widget.product.image,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Icon(
                            Icons.image_not_supported,
                            size: 80,
                            color: Colors.grey,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// 🟢 Product Name
              Text(widget.product.name, style: TextStyles.titleSmall()),

              const SizedBox(height: 8),

              /// 🟢 Brand
              Text(
                'Brand: ${widget.product.brand}',
                style: TextStyles.caption(color: Colors.grey),
              ),

              const SizedBox(height: 8),

              /// 🟢 Rating Section
              _buildRatingSection(),

              const SizedBox(height: 16),

              /// 🟢 Category Badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColor.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  ProductDetailsService.getCategoryDisplayName(
                    widget.product.category,
                  ),
                  style: TextStyles.caption(color: AppColor.primaryColor),
                ),
              ),

              const SizedBox(height: 16),

              /// 🟢 Description Title
              Text('Description', style: TextStyles.subtitle()),
              const SizedBox(height: 8),

              /// 🟢 Description Text
              Text(
                widget.product.description,
                style: TextStyles.body(color: Colors.grey),
              ),

              const SizedBox(height: 24),

              /// 🟢 Specifications Section
              _buildSpecificationsSection(),

              const SizedBox(height: 30),

              /// 🟢 Quantity Selector
              Text('Quantity', style: TextStyles.subtitle()),
              const SizedBox(height: 12),
              _buildQuantitySelector(),

              const SizedBox(height: 30),

              /// 🟢 Bottom Section - Price and Add to Cart
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Total Price', style: TextStyles.caption()),
                        const SizedBox(height: 4),
                        Text(
                          ProductDetailsService.formatPrice(
                            ProductDetailsService.calculateTotalPrice(
                              widget.product.price,
                              quantity: _quantity,
                            ),
                          ),
                          style: TextStyles.subtitle(
                            color: AppColor.primaryColor,
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.primaryColor,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      onPressed: _handleAddToCart,
                      child: Text(
                        'Add to Cart',
                        style: TextStyles.button(color: AppColor.whiteColor),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
