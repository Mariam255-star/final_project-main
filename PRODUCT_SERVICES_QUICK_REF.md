# Quick Reference - Product Services

## 📂 New Folder Structure

```
lib/services/product/
├── product_services.dart          (Existing - API calls)
├── product_details_service.dart   (New - Formatting & logic)
└── product_cart_service.dart      (New - Cart operations)
```

---

## 🎯 ProductDetailsService

### **Format & Display Logic**

```dart
// Format price to SAR
String price = ProductDetailsService.formatPrice(350.0);
// → "SAR 350.00"

// Get rating stars count
int stars = ProductDetailsService.getRatingStarsCount(4.6);
// → 4

// Get rating description
String desc = ProductDetailsService.getRatingDescription(4.6);
// → "Excellent"

// Validate product
bool valid = ProductDetailsService.isValidProduct(product);
// → true/false

// Get formatted category
String category = ProductDetailsService.getCategoryDisplayName("skincare");
// → "SKINCARE"

// Get all specifications
List<Map> specs = ProductDetailsService.getSpecifications(product);
// → [{"label": "Price", "value": "SAR 350.00"}, ...]

// Calculate total with quantity
double total = ProductDetailsService.calculateTotalPrice(350.0, quantity: 2);
// → 700.0
```

---

## 🛒 ProductCartService

### **Cart Management**

```dart
// Add to cart
ProductCartService.addToCart(product, quantity: 2);
// Adds product with quantity, or updates if exists

// Remove from cart
ProductCartService.removeFromCart(productId);
// Removes product from cart

// Update quantity
ProductCartService.updateQuantity(productId, 5);
// Changes quantity to 5

// Get all cart items
List<CartItem> items = ProductCartService.getCartItems();
// Returns list of CartItem objects

// Get cart total price
double total = ProductCartService.getCartTotal();
// Returns sum of all items * quantities

// Get item count
int count = ProductCartService.getCartItemCount();
// Returns number of different products

// Get total quantity
int qty = ProductCartService.getTotalQuantity();
// Returns sum of all quantities

// Check if product in cart
bool inCart = ProductCartService.isProductInCart(productId);
// Returns true/false

// Get product quantity
int qty = ProductCartService.getProductQuantity(productId);
// Returns quantity of specific product (0 if not in cart)

// Clear cart
ProductCartService.clearCart();
// Removes all items from cart

// Get summary
String summary = ProductCartService.getCartSummary();
// Returns formatted cart information
```

---

## 📱 ProductDetailsScreen Updates

### **New Features**

✅ **Quantity Selector**
- Increment/decrement buttons
- Shows current quantity
- Updates total price dynamically

✅ **Better Rating Display**
- Shows rating number and stars
- Includes rating description (Excellent, Good, etc.)
- Visual star rating (filled/outline)

✅ **Enhanced Add to Cart**
- Adds with selected quantity
- Shows success message
- Error handling

✅ **Service Integration**
- Uses ProductDetailsService for all formatting
- Uses ProductCartService for cart operations
- Clean separation of concerns

### **Code Example**

```dart
// Inside _ProductDetailsScreenState
void _handleAddToCart() {
  ProductCartService.addToCart(
    widget.product,
    quantity: _quantity,
  );
  
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('${widget.product.name} x$_quantity added to cart!'),
    ),
  );
}
```

---

## 🔄 Usage Flow

### **Displaying Product Details**
```
1. User presses product card
2. Router sends Product object to ProductDetailsScreen
3. Screen uses ProductDetailsService to format data
4. Display: formatted price, rating with stars, specs
```

### **Adding to Cart**
```
1. User changes quantity
2. User taps "Add to Cart"
3. _handleAddToCart() is called
4. ProductCartService.addToCart() is called
5. Service adds/updates product in cart
6. Success message shown
```

### **Accessing Cart**
```
// From any screen
List<CartItem> cartItems = ProductCartService.getCartItems();
double total = ProductCartService.getCartTotal();
int itemCount = ProductCartService.getCartItemCount();
```

---

## 🧪 Testing

### **Test Product Details**
1. Open app
2. Navigate to Skincare
3. Press any product
4. Verify all fields display (name, brand, rating, price, description)
5. Change quantity and verify total updates
6. Press "Add to Cart" and verify success message

### **Test Cart Service**
```dart
// In debug console or test file
ProductCartService.addToCart(product1, quantity: 2);
ProductCartService.addToCart(product2, quantity: 1);

print(ProductCartService.getCartTotal()); // Shows total
print(ProductCartService.getCartItemCount()); // Shows 2
print(ProductCartService.getTotalQuantity()); // Shows 3

ProductCartService.updateQuantity(product1.id, 5);
print(ProductCartService.getCartSummary()); // Shows updated info
```

---

## 📋 Service Methods Quick Lookup

### **ProductDetailsService Methods**
| Method | Returns | Purpose |
|--------|---------|---------|
| formatPrice | String | Convert price to "SAR X.XX" |
| getRatingStarsCount | int | Get number of filled stars |
| getRatingDescription | String | Get rating label (Excellent, Good, etc.) |
| isValidProduct | bool | Check if product data is valid |
| getCategoryDisplayName | String | Format category to uppercase |
| getSpecifications | List | Get all specifications as list |
| calculateTotalPrice | double | Calculate price × quantity |
| generateProductSummary | String | Create product summary text |

### **ProductCartService Methods**
| Method | Returns | Purpose |
|--------|---------|---------|
| addToCart | void | Add/update product in cart |
| removeFromCart | void | Remove product from cart |
| updateQuantity | void | Change quantity of product |
| getCartItems | List | Get all items in cart |
| getCartTotal | double | Get total price |
| getCartItemCount | int | Get number of products |
| getTotalQuantity | int | Get sum of quantities |
| isProductInCart | bool | Check if product exists |
| getProductQuantity | int | Get quantity of specific product |
| clearCart | void | Remove all items |
| getCartSummary | String | Get formatted summary |

---

## 🎯 Next Steps

### **To Use in Other Screens**
```dart
import 'package:final_project/services/product/product_details_service.dart';
import 'package:final_project/services/product/product_cart_service.dart';

// In cart screen
final items = ProductCartService.getCartItems();
final total = ProductCartService.getCartTotal();

// In checkout
for (var item in items) {
  print('${item.product.name}: ${item.getSubtotal()}');
}
```

### **To Add More Features**
- Create new service methods in ProductDetailsService
- Add discount logic
- Add reviews functionality
- Add wishlist support
- Add product recommendations

---

## ✨ Architecture Benefits

✅ Cleaner code organization
✅ Easier testing with services
✅ Reusable across screens
✅ Simple to extend
✅ Clear responsibility boundaries
