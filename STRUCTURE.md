# FindIt Ethiopia - Project Structure

## Folder Structure

```
findit_ethiopia/
├── assets/
│   └── images/          # Place your images here (logo.png, icons, etc.)
├── lib/
│   ├── main.dart        # App entry point
│   ├── models/          # Data models
│   │   ├── category_item.dart
│   │   ├── inventory_item.dart
│   │   └── product_item.dart
│   ├── screens/         # All screen widgets
│   │   ├── splash_screen.dart
│   │   ├── login_screen.dart
│   │   ├── main_home_screen.dart
│   │   ├── product_detail_screen.dart
│   │   └── vendor_home_screen.dart
│   ├── services/        # Business logic services
│   │   └── auth_service.dart
│   └── widgets/        # Reusable widgets
│       └── product_card.dart
└── pubspec.yaml         # Dependencies and assets configuration
```

## How to Add Images

1. Place your image files in `assets/images/` folder
2. Example: `assets/images/logo.png`
3. Use in code: `Image.asset('assets/images/logo.png')`

## File Organization

- **models/**: Data classes (ProductItem, CategoryItem, InventoryItem)
- **screens/**: Full page widgets (Login, Home, Detail, etc.)
- **widgets/**: Reusable UI components (ProductCard, etc.)
- **services/**: Business logic and state management (AuthService, etc.)





