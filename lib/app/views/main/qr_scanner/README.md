# QR Code Scanner for Product Cart

## Overview

This QR scanner implementation allows users to scan physical product QR codes and automatically add matching products to their cart.

## Features

### QR Scanner Screen (`qr_scanner_screen.dart`)

- Real-time QR code scanning using camera
- Visual feedback with scanning status
- Modern UI with instructions and status indicators
- Error handling for detection failures
- Back button to exit scanner

### QR Scanner Controller (`qr_scanner_controller.dart`)

- Manages QR scanning state and product matching
- Prevents duplicate scans of the same product
- Searches for products by `qrId` or product `id`
- Automatically adds matched products to cart
- Navigates directly to cart view after successful scan
- Shows appropriate feedback messages

## How It Works

### 1. Scanning Flow

```
User opens QR Scanner
↓
Points camera at product QR code
↓
QR code is detected and parsed
↓
Controller searches for matching product in home products
↓
If found: Add to cart → Navigate to cart view
If not found: Show "Product Not Found" message
```

### 2. Product Matching

The scanner matches products by:

- **Primary**: `product.qrId` (QR ID field from database)
- **Secondary**: `product.id` (Product ID as fallback)

### 3. Cart Integration

When a product is found:

1. Product is added to cart with quantity 1
2. Success message is displayed
3. User is automatically navigated to the cart view
4. Product appears in the cart ready for checkout

## Usage

### For Users

1. Navigate to home screen
2. Tap the QR scanner icon in the header
3. Point camera at a product's QR code
4. Wait for automatic detection
5. Product will be added to cart and you'll be taken to cart view

### For Developers

#### Accessing QR Scanner

From anywhere in the app:

```dart
Get.to(() => QrScannerScreen());
```

From home header (already implemented):

```dart
IconButton(
  onPressed: () => Get.to(() => QrScannerScreen()),
  icon: Icon(Icons.qr_code_scanner),
)
```

#### QR Code Format

The scanner accepts:

- Plain text QR codes containing the product's `qrId`
- JSON formatted QR codes with a `displayValue` field
- Product ID as a fallback identifier

Example QR code content:

```
"67433f123a31b71e6b5c0123"  // Direct qrId
```

Or JSON format:

```json
{
  "displayValue": "67433f123a31b71e6b5c0123"
}
```

## Configuration

### Dependencies

- `ai_barcode_scanner` - For QR code scanning
- `get` - State management and navigation
- `cart_service` - Cart management
- `home_controller` - Access to product list

### Services Required

Ensure these services are initialized:

- `CartService` - For adding products to cart
- `HomeController` - For accessing product list

## Error Handling

### Product Not Found

If no product matches the scanned QR code:

- Orange warning message is shown
- Scanner remains active for another attempt
- No navigation occurs

### Scanning Errors

If QR code detection fails:

- Error is logged to console
- User can continue scanning
- No disruptive error messages

### Duplicate Scans

- Same QR code scanned within 3 seconds is ignored
- Prevents accidental duplicate cart additions
- Cooldown period allows re-scanning if needed

## UI Components

### Status Display

- **Green background**: Ready to scan
- **Blue background**: Processing QR code
- **Loading indicator**: During product lookup and cart addition

### Instructions

- Top banner: Clear scanning instructions
- Bottom panel: Current status and scanned data
- Back button: Easy exit from scanner

## State Management

### Observable Variables

- `scannedData`: Current QR code value
- `isProcessing`: Processing state (prevents duplicate scans)
- `lastScannedQrId`: Tracks last scanned code for cooldown

### Reactive UI

All UI elements react to state changes using `Obx()` widgets.

## Future Enhancements

- [ ] Add product preview before adding to cart
- [ ] Support batch scanning (multiple products)
- [ ] Show product image in success message
- [ ] Add sound/vibration feedback on successful scan
- [ ] Implement manual QR code entry option
- [ ] Add scanning history
- [ ] Support for promotion/discount QR codes

## Testing

### Test Scenarios

1. **Valid Product QR Code**
   - Scan a valid product QR code
   - Verify product is added to cart
   - Verify navigation to cart view

2. **Invalid QR Code**
   - Scan a QR code not matching any product
   - Verify "Product Not Found" message appears
   - Verify user stays on scanner screen

3. **Duplicate Scan**
   - Scan same QR code twice quickly
   - Verify second scan is ignored
   - Wait 3 seconds and scan again
   - Verify product is added again

4. **Multiple Products**
   - Scan multiple different product QR codes
   - Verify each is added to cart
   - Verify cart shows all scanned products

### Test QR Codes

To test, generate QR codes containing:

- Product `qrId` values from your database
- Product `id` values as fallback

## Notes

- Scanner requires camera permission
- Works with both front and back cameras
- Optimized for quick scanning and minimal UI delay
- Automatically handles JSON and plain text QR codes
- Cart service manages duplicate product logic (updates quantity instead of adding new items)
