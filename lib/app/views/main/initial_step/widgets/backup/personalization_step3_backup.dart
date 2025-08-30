// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../controllers/personalization_controller.dart';

// class PersonalizationStep3 extends StatelessWidget {
//   final Function()? onNext;
  
//   const PersonalizationStep3({
//     Key? key,
//     this.onNext,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Back button
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: InkWell(
//                 onTap: () => Navigator.pop(context),
//                 child: Container(
//                   padding: const EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     color: Colors.grey.shade200,
//                     shape: BoxShape.circle,
//                   ),
//                   child: const Icon(Icons.arrow_back, color: Colors.black87, size: 24),
//                 ),
//               ),
//             ),
            
//             // Title
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
//               child: Text(
//                 'Select your product type',
//                 style: TextStyle(
//                   fontSize: 32,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.black87,
//                   height: 1.1,
//                 ),
//               ),
//             ),
            
//             // Grid of product types
//             Expanded(
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                 child: GridView.builder(
//                   padding: const EdgeInsets.only(top: 8.0),
//                   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 2,
//                     childAspectRatio: 0.85,
//                     crossAxisSpacing: 16,
//                     mainAxisSpacing: 16,
//                   ),
//                   itemCount: productTypes.length,
//                   itemBuilder: (context, index) {
//                     final product = productTypes[index];
//                     final isSelected = selectedProductType == '${product['name']}_$index';
                    
//                     return GestureDetector(
//                       onTap: () {
//                         setState(() {
//                           selectedProductType = '${product['name']}_$index';
//                         });
//                       },
//                       child: Container(
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(8),
//                           border: Border.all(
//                             color: isSelected ? Colors.green : Colors.grey.shade300,
//                             width: isSelected ? 2 : 1,
//                           ),
//                         ),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.stretch,
//                           children: [
//                             // Product image - taking most of the space
//                             Expanded(
//                               child: Stack(
//                                 fit: StackFit.expand,
//                                 children: [
//                                   ClipRRect(
//                                     borderRadius: BorderRadius.vertical(top: Radius.circular(7)),
//                                     child: _buildProductImage(product),
//                                   ),
                                  
//                                   // Checkmark for selected item
//                                   if (isSelected)
//                                     Positioned(
//                                       top: 8,
//                                       right: 8,
//                                       child: Container(
//                                         padding: const EdgeInsets.all(4),
//                                         decoration: const BoxDecoration(
//                                           shape: BoxShape.circle,
//                                           color: Colors.green,
//                                         ),
//                                         child: const Icon(
//                                           Icons.check,
//                                           color: Colors.white,
//                                           size: 16,
//                                         ),
//                                       ),
//                                     ),
//                                 ],
//                               ),
//                             ),
                            
//                             // Product name
//                             Container(
//                               padding: const EdgeInsets.symmetric(vertical: 12),
//                               decoration: const BoxDecoration(
//                                 color: Colors.white,
//                                 borderRadius: BorderRadius.vertical(
//                                   bottom: Radius.circular(7),
//                                 ),
//                               ),
//                               child: Text(
//                                 product['name'],
//                                 textAlign: TextAlign.center,
//                                 style: const TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ),
            
//             // Continue button
//             Padding(
//               padding: const EdgeInsets.all(20.0),
//               child: SizedBox(
//                 width: double.infinity,
//                 height: 56,
//                 child: ElevatedButton(
//                   onPressed: selectedProductType != null ? widget.onNext : null,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFFFFF000), // Bright yellow color
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(28),
//                     ),
//                     elevation: 0,
//                     disabledBackgroundColor: const Color(0xFFFFF000).withOpacity(0.7),
//                   ),
//                   child: const Text(
//                     'Continue',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black87,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
  
//   // Helper method to build product images with error handling
//   Widget _buildProductImage(Map<String, dynamic> product) {
//     // First try to load from assets if specified
//     if (product.containsKey('image')) {
//       return Image.asset(
//         product['image'],
//         fit: BoxFit.cover,
//         errorBuilder: (context, error, stackTrace) {
//           // If asset fails, try network image
//           return _buildNetworkOrPlaceholderImage(product);
//         },
//       );
//     }
    
//     // Otherwise use network image
//     return _buildNetworkOrPlaceholderImage(product);
//   }
  
//   // Helper for network image with placeholder fallback
//   Widget _buildNetworkOrPlaceholderImage(Map<String, dynamic> product) {
//     if (product.containsKey('imageUrl')) {
//       return Image.network(
//         product['imageUrl'],
//         fit: BoxFit.cover,
//         loadingBuilder: (context, child, loadingProgress) {
//           if (loadingProgress == null) return child;
//           return Center(
//             child: CircularProgressIndicator(
//               value: loadingProgress.expectedTotalBytes != null
//                   ? loadingProgress.cumulativeBytesLoaded / 
//                     loadingProgress.expectedTotalBytes!
//                   : null,
//               color: Colors.grey,
//             ),
//           );
//         },
//         errorBuilder: (context, error, stackTrace) {
//           return _buildPlaceholderImage(product);
//         },
//       );
//     }
    
//     return _buildPlaceholderImage(product);
//   }
  
//   // Placeholder image
//   Widget _buildPlaceholderImage(Map<String, dynamic> product) {
//     return Container(
//       color: Colors.grey.shade200,
//       child: Center(
//         child: Text(
//           product['name'],
//           style: const TextStyle(fontWeight: FontWeight.bold),
//         ),
//       ),
//     );
//   }
// }
