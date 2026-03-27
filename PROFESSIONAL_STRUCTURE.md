# Lost & Found Management App - Professional Folder Structure

## 📁 Directory Structure

```
lib/
├── main.dart                          # App entry point
│
├── config/                            # App configuration
│   └── (routing configs, environment settings)
│
├── core/                              # Shared core functionality
│   ├── constants/                     # App constants
│   ├── themes/                        # App themes and styling
│   ├── widgets/                       # Shared/reusable widgets
│   │   └── app_logo.dart
│   └── utils/                         # Utility functions and helpers
│
├── data/                              # Data layer (Models, Repositories)
│   ├── models/                        # Data models
│   │   ├── item_model.dart           # Item model with serialization
│   │   └── claim_model.dart          # Claim model with serialization
│   ├── repositories/                  # Data access layer
│   │   ├── item_repository.dart
│   │   └── claim_repository.dart
│   └── services/                      # API/Database services
│       └── (api_service.dart, local_storage_service.dart)
│
├── presentation/                      # UI layer (Screens & Widgets)
│   ├── screens/
│   │   ├── home/                      # Home feature screens
│   │   │   ├── splash_screen.dart
│   │   │   ├── onboarding_screen.dart
│   │   │   ├── home_screen.dart
│   │   │   └── dashboard_screen.dart
│   │   ├── items/                     # Items feature screens
│   │   │   ├── report_item_screen.dart
│   │   │   ├── item_list_screen.dart
│   │   │   ├── item_detail_screen.dart
│   │   │   └── my_items_screen.dart
│   │   └── claims/                    # Claims feature screens
│   │       ├── claim_request_screen.dart
│   │       ├── claim_form.dart
│   │       └── my_claims_screen.dart
│   └── widgets/
│       ├── common/                    # Shared widgets
│       │   ├── item_card.dart
│       │   └── filter_widget.dart
│       └── item/                      # Item-specific widgets
│           ├── item_form.dart
│           ├── item_tile.dart
│           └── status_badge.dart
│
├── users/                             # User authentication & profile
│   ├── models/
│   │   └── user_model.dart           # User data model
│   ├── repositories/
│   │   └── user_repository.dart      # User data access
│   ├── services/
│   │   └── auth_service.dart         # Authentication logic
│   └── screens/
│       ├── login_screen.dart
│       ├── register_screen.dart
│       └── forgot_password_screen.dart
└── assets/                            # (at project root)
    └── images/
```

## 🏗️ Architecture Overview

This project follows a **clean, professional layered architecture**:

### **1. Core Layer**

- Shared utilities, constants, themes, and reusable widgets
- No dependencies on other layers
- Accessible from all layers

### **2. Data Layer**

- **Models**: Data structures with JSON serialization
- **Repositories**: Abstract data access patterns
- **Services**: API/database communication (placeholder)
- Independent of the presentation layer

### **3. Presentation Layer**

- Organized by feature/screen
- **Screens**: Full-page widgets
- **Widgets**: Reusable UI components
- Depends on data layer only

### **4. Users Layer** (Dedicated)

- **Screens**: Authentication screens (Login, Register, Forgot Password)
- **Models**: User data model
- **Services**: AuthService for authentication logic
- **Repositories**: User data operations
- Isolated for maintainability

## 📦 Key Features

### **Separation of Concerns**

- Each layer has specific responsibilities
- Easy to test, maintain, and scale

### **Reusability**

- Common widgets in `core/widgets`
- Shared across features without duplication

### **Scalability**

- Easy to add new features
- Clear directory organization
- No circular dependencies

### **Professional Best Practices**

- Clean code architecture
- SOLID principles
- Repository pattern for data access
- Service layer for business logic
- Model serialization (toJson/fromJson)

## 🔄 Data Flow

```
UI (Presentation Screens)
    ↓
Data Models
    ↓
Repositories (Data Access)
    ↓
Services (API/Database)
    ↓
Local Storage / Remote API
```

## 📝 File Organization Guide

- **screens**: Full pages/routes (always in `presentation/screens/feature/`)
- **widgets**: Reusable components (in `presentation/widgets/` or `core/widgets/`)
- **models**: Data structures (in `data/models/` for general, `users/models/` for user)
- **repositories**: CRUD operations (in `data/repositories/` or `users/repositories/`)
- **services**: Business logic (in `data/services/` or `users/services/`)

## ✨ Benefits

1. **Clear Structure**: Everyone knows where things go
2. **Maintainability**: Easy to find and update code
3. **Testability**: Layers can be tested independently
4. **Scalability**: Simple to add new features
5. **Professional**: Industry-standard architecture
6. **Dedicated Users Folder**: All auth/user logic in one place

## 🚀 Next Steps

1. Update `config/` with routing configuration
2. Add API service in `data/services/`
3. Implement state management (Provider, BLoC, etc.)
4. Add tests for models and repositories
5. Connect repositories to real API endpoints

---

**Created**: March 27, 2026  
**Architecture**: Clean Layered Architecture  
**Status**: Ready for development
