import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_inventory/app/core/models/product_model.dart'
    hide ReviewUser;
import 'package:qr_code_inventory/app/core/models/review_model.dart';
import 'package:qr_code_inventory/app/core/services/product_service.dart';
import 'package:qr_code_inventory/app/core/services/wishlist_service.dart';
import 'package:qr_code_inventory/app/core/services/token_storage.dart';
import 'package:qr_code_inventory/app/core/services/cart_service.dart';
import 'package:qr_code_inventory/app/core/services/review_service.dart';
import 'package:qr_code_inventory/app/views/main/cart/cart_view.dart';
import 'package:qr_code_inventory/app/utils/navigation_utils.dart';

class ProductDetailsController extends GetxController {
  final Rxn<Product> _product = Rxn<Product>();
  Product? get product => _product.value;
  set product(Product? value) => _product.value = value;

  late final ProductService _productService;
  late final WishlistService _wishlistService;
  late final TokenStorage _tokenStorage;
  late final CartService _cartService;
  late final ReviewService _reviewService;

  final isFavorite = false.obs;
  final quantity = 1.obs;
  final selectedImageIndex = 0.obs;
  final isLoading = false.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;
  final isWishlistLoading = false.obs;
  final isAddingToCart = false.obs;
  final isSubmittingReview = false.obs;
  final isLoadingReviews = false.obs;

  // Reviews list
  final RxList<Review> reviews = <Review>[].obs;
  final reviewsPage = 1.obs;
  final reviewsLimit = 10.obs;
  final totalReviews = 0.obs;
  final hasMoreReviews = true.obs;

  String? productId;

  @override
  void onClose() {
    debugPrint('🧹 Disposing ProductDetailsController');
    super.onClose();
  }

  @override
  void onInit() {
    super.onInit();

    // Initialize services safely
    try {
      _productService = Get.find<ProductService>();
      _wishlistService = Get.find<WishlistService>();
      _tokenStorage = Get.find<TokenStorage>();
      _cartService = Get.find<CartService>();
      _reviewService = ReviewService();
    } catch (e) {
      debugPrint(
        '⚠️ Error initializing services in ProductDetailsController: $e',
      );
      hasError.value = true;
      errorMessage.value = 'Failed to initialize services';
      return;
    }

    // Check if we received a product or just an ID
    final arguments = Get.arguments;

    if (arguments is Product) {
      // If we have a product object, use it immediately to show content
      product = arguments;
      productId = product!.id;
      // Check wishlist status immediately
      _checkWishlistStatus();
      // Fetch updated details in background (which will load reviews from ratingStats)
      _fetchProductDetails();
    } else if (arguments is String) {
      // If we only have a product ID, fetch the details (which will load reviews)
      productId = arguments;
      _fetchProductDetails();
    } else {
      // Handle error case
      hasError.value = true;
      errorMessage.value = 'No product information provided';
      debugPrint('Error: No product information provided in arguments');
      return;
    }

    // Initialize favorite status
    isFavorite.value =
        false; // Default to false, will be updated by _checkWishlistStatus
  }

  Future<void> _fetchProductDetails() async {
    if (productId == null) return;

    try {
      // Only show loading if we don't have product data already
      if (product == null) {
        isLoading.value = true;
      }
      hasError.value = false;

      final token = _tokenStorage.getAccessToken();
      if (token == null) {
        throw Exception('No authentication token found');
      }

      final response = await _productService.getProductDetails(
        productId: productId!,
        token: token,
      );

      if (response.success) {
        product = response.data;
        debugPrint('📦 Product loaded: ${product?.name}');

        if (product != null) {
          debugPrint('🔢 Product ID: ${product!.id}');
          debugPrint('⭐ Product rating: ${product!.rating}');
          debugPrint('📝 Product count field: ${product!.count}');
          debugPrint('🎯 Has ratingStats: ${product!.ratingStats != null}');

          // Check if ratingStats exists in the product
          if (product!.ratingStats != null) {
            final ratingStats = product!.ratingStats!;
            debugPrint(
              '⭐ Total reviews in ratingStats: ${ratingStats.totalReviews}',
            );
            debugPrint('📊 Rating counts: ${ratingStats.counts}');
            debugPrint('📈 Rating percentages: ${ratingStats.percentages}');
            debugPrint(
              '📝 Number of review details: ${ratingStats.getReviewDetails.length}',
            );

            // Set totalReviews from ratingStats
            totalReviews.value = ratingStats.totalReviews;
            debugPrint(
              '✅ Set totalReviews.value = ${totalReviews.value} from ratingStats',
            );

            // Extract reviews from ratingStats.getReviewDetails
            reviews.value = ratingStats.getReviewDetails.map((reviewDetail) {
              // Convert ReviewDetail.user to Review.user
              ReviewUser? reviewUser;
              if (reviewDetail.user != null) {
                reviewUser = ReviewUser(
                  id: reviewDetail.user!.id,
                  name: reviewDetail.user!.name,
                  email: reviewDetail.user!.email,
                  image: reviewDetail.user!.image, // Include image from API
                );
              }

              return Review(
                id: reviewDetail.id,
                rating: reviewDetail.rating,
                review: reviewDetail.review,
                product: productId!, // Use the current product ID
                user: reviewUser,
                createdAt: reviewDetail.createdAt,
              );
            }).toList();
            debugPrint(
              '✅ Converted ${reviews.length} reviews from ratingStats',
            );

            hasMoreReviews.value = false; // All reviews are in ratingStats
          } else {
            // Fallback to count field if ratingStats not present
            debugPrint('⚠️ No ratingStats, using count field');
            totalReviews.value = product!.count;
            debugPrint(
              '✅ Set totalReviews.value = ${totalReviews.value} from count field',
            );

            // Fetch reviews separately from the review API
            if (product!.count > 0) {
              await fetchReviews();
            } else {
              reviews.clear();
              hasMoreReviews.value = false;
            }
          }
        }

        // Check if product is in wishlist after loading
        await _checkWishlistStatus();
        update(); // Notify widgets to rebuild
      } else {
        throw Exception(response.message);
      }
    } catch (e) {
      debugPrint('Error fetching product details: $e');

      // Only show error if we don't have any product data
      if (product == null) {
        hasError.value = true;
        errorMessage.value = e.toString();

        // Show error snackbar
        Get.snackbar(
          'Error',
          'Failed to load product details: ${e.toString()}',
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade800,
          duration: const Duration(seconds: 3),
        );
      } else {
        // We have existing product data, just log the error
        debugPrint('Failed to refresh product details, using existing data');
      }
    } finally {
      isLoading.value = false;
    }
  }

  // Check if product is in wishlist
  Future<void> _checkWishlistStatus() async {
    if (productId == null) return;

    try {
      final token = _tokenStorage.getAccessToken();
      if (token == null) return;

      final isInWishlist = await _wishlistService.isProductInWishlist(
        productId: productId!,
        token: token,
      );

      isFavorite.value = isInWishlist;
    } catch (e) {
      debugPrint('Error checking wishlist status: $e');
    }
  }

  // Method to refresh product details
  Future<void> refreshProductDetails() async {
    await _fetchProductDetails();
  }

  // Fetch reviews for the product
  Future<void> fetchReviews({bool loadMore = false}) async {
    if (productId == null) return;

    // Prevent loading if already loading or no more reviews
    if (isLoadingReviews.value || (!loadMore && !hasMoreReviews.value)) {
      return;
    }

    try {
      isLoadingReviews.value = true;

      // Reset page if not loading more
      if (!loadMore) {
        reviewsPage.value = 1;
        reviews.clear();
        hasMoreReviews.value = true;
      }

      final response = await _reviewService.getProductReviews(
        productId: productId!,
        page: reviewsPage.value,
        limit: reviewsLimit.value,
      );

      if (response != null && response.success) {
        totalReviews.value = response.meta.total;

        if (loadMore) {
          reviews.addAll(response.reviews);
        } else {
          reviews.value = response.reviews;
        }

        // Check if there are more reviews to load
        hasMoreReviews.value = reviews.length < totalReviews.value;

        // Increment page for next load
        if (hasMoreReviews.value) {
          reviewsPage.value++;
        }

        debugPrint(
          'Loaded ${response.reviews.length} reviews. Total: ${reviews.length}/${totalReviews.value}',
        );
      } else {
        debugPrint('Failed to fetch reviews');
        hasMoreReviews.value = false;
      }
    } catch (e) {
      debugPrint('Error fetching reviews: $e');
      hasMoreReviews.value = false;
    } finally {
      isLoadingReviews.value = false;
    }
  }

  // Load more reviews (pagination)
  Future<void> loadMoreReviews() async {
    await fetchReviews(loadMore: true);
  }

  // Toggle wishlist status
  Future<void> toggleFavorite() async {
    if (productId == null) return;

    try {
      isWishlistLoading.value = true;

      final token = _tokenStorage.getAccessToken();
      if (token == null) {
        Get.snackbar(
          'Error',
          'Please login to add items to wishlist',
          backgroundColor: Colors.red.shade100,
          colorText: Colors.red.shade800,
        );
        return;
      }

      if (isFavorite.value) {
        // Remove from wishlist
        final response = await _wishlistService.removeFromWishlist(
          productId: productId!,
          token: token,
        );

        if (response.success) {
          isFavorite.value = false;
          Get.snackbar(
            'Removed',
            'Product removed from wishlist',
            backgroundColor: Colors.orange.shade100,
            colorText: Colors.orange.shade800,
            duration: const Duration(seconds: 2),
          );
        } else {
          throw Exception(response.message);
        }
      } else {
        // Add to wishlist
        final response = await _wishlistService.addToWishlist(
          productId: productId!,
          token: token,
        );

        if (response.success) {
          isFavorite.value = true;
          Get.snackbar(
            'Added',
            'Product added to wishlist',
            backgroundColor: Colors.green.shade100,
            colorText: Colors.green.shade800,
            duration: const Duration(seconds: 2),
          );
        } else {
          throw Exception(response.message);
        }
      }
    } catch (e) {
      debugPrint('Error toggling wishlist: $e');
      Get.snackbar(
        'Error',
        'Failed to update wishlist: ${e.toString()}',
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade800,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isWishlistLoading.value = false;
    }
  }

  void incrementQuantity() {
    quantity.value++;
  }

  void decrementQuantity() {
    if (quantity.value > 1) {
      quantity.value--;
    }
  }

  void addToCart() {
    if (product == null) {
      Get.snackbar(
        'Error',
        'Product information not available',
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
      return;
    }

    isAddingToCart.value = true;

    try {
      // Add product to cart with selected quantity
      final success = _cartService.addToCart(
        product!,
        quantity: quantity.value,
        selectedSize: null, // You can add size selection logic here
        selectedColor: null, // You can add color selection logic here
      );

      if (success) {
        // Show success message and option to go to cart
        try {
          Get.snackbar(
            'Added to Cart',
            '${product!.name} has been added to your cart',
            backgroundColor: Colors.green.withOpacity(0.1),
            colorText: Colors.green,
            duration: const Duration(seconds: 3),
            mainButton: TextButton(
              onPressed: () {
                Get.back(); // Close snackbar
                Get.to(() => const CartView());
              },
              child: const Text(
                'View Cart',
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        } catch (e) {
          debugPrint('⚠️ Could not show snackbar: $e');
        }
      } else {
        try {
          Get.snackbar(
            'Error',
            'Failed to add product to cart',
            backgroundColor: Colors.red.withOpacity(0.1),
            colorText: Colors.red,
          );
        } catch (e) {
          debugPrint('⚠️ Could not show error snackbar: $e');
        }
      }
    } catch (e) {
      debugPrint('Error adding to cart: $e');
      try {
        Get.snackbar(
          'Error',
          'Failed to add product to cart: ${e.toString()}',
          backgroundColor: Colors.red.withOpacity(0.1),
          colorText: Colors.red,
        );
      } catch (snackbarError) {
        debugPrint('⚠️ Could not show error snackbar: $snackbarError');
      }
    } finally {
      isAddingToCart.value = false;
    }
  }

  // Navigate to cart view
  void navigateToCart() {
    Get.to(
      () => const CartView(),
      transition: Transition.rightToLeft,
      duration: const Duration(milliseconds: 300),
    );
  }

  void onBackPressed() {
    NavigationUtils.safeBack();
  }

  void shareProduct() {
    if (product != null) {
      Get.snackbar(
        'Share',
        'Sharing ${product!.name}',
        duration: const Duration(seconds: 1),
      );
    }
  }

  // Check if current product is in cart
  bool get isProductInCart {
    try {
      if (product == null) return false;
      return _cartService.isProductInCart(product!.id);
    } catch (e) {
      debugPrint('⚠️ Error checking cart status: $e');
      return false;
    }
  }

  // Get cart items count for badge
  int get cartItemsCount {
    try {
      return _cartService.totalItems;
    } catch (e) {
      debugPrint('⚠️ Error getting cart items count: $e');
      return 0;
    }
  }

  // Submit a review for the current product
  Future<bool> submitReview({
    required int rating,
    required String reviewText,
  }) async {
    if (productId == null) {
      Get.snackbar(
        'Error',
        'Product information not available',
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
      return false;
    }

    if (reviewText.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please write a review',
        backgroundColor: Colors.orange.withOpacity(0.1),
        colorText: Colors.orange,
      );
      return false;
    }

    try {
      isSubmittingReview.value = true;

      final token = _tokenStorage.getAccessToken();
      if (token == null) {
        Get.snackbar(
          'Error',
          'Please login to submit a review',
          backgroundColor: Colors.red.withOpacity(0.1),
          colorText: Colors.red,
        );
        return false;
      }

      final response = await _reviewService.createReview(
        rating: rating,
        review: reviewText,
        productId: productId!,
        token: token,
      );

      if (response.success) {
        Get.snackbar(
          'Success',
          'Your review has been submitted successfully',
          backgroundColor: Colors.green.withOpacity(0.1),
          colorText: Colors.green,
          duration: const Duration(seconds: 2),
        );

        // Refresh product details to get updated ratings
        await refreshProductDetails();

        // Reviews will be automatically updated from product details

        return true;
      } else {
        throw Exception(response.message);
      }
    } catch (e) {
      debugPrint('Error submitting review: $e');
      Get.snackbar(
        'Error',
        'Failed to submit review: ${e.toString()}',
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
        duration: const Duration(seconds: 3),
      );
      return false;
    } finally {
      isSubmittingReview.value = false;
    }
  }
}
