# QR Code Inventory Management System

A Flutter application built with GetX architecture for managing inventory using QR codes.

## 🚀 Features

- **User Authentication**: Secure login and registration system
- **QR Code Scanning**: Scan inventory items using device camera
- **Inventory Management**: Add, edit, delete, and search inventory items
- **Real-time Updates**: Reactive UI with GetX state management
- **Modern UI**: Clean, responsive design following Material Design principles
- **Offline Support**: Local data persistence with secure storage

## 🏗️ Architecture

This project follows the **GetX Architecture Pattern** with clean separation of concerns:

```
lib/
├── app/
│   ├── data/                 # Data Layer
│   │   ├── models/          # Data Models
│   │   └── services/        # API & Storage Services
│   ├── global/              # Global Constants & Config
│   ├── modules/             # Feature Modules
│   │   ├── auth/           # Authentication Module
│   │   ├── home/           # Home Dashboard Module
│   │   ├── inventory/      # Inventory Management Module
│   │   ├── qr_scanner/     # QR Code Scanner Module
│   │   └── splash/         # Splash Screen Module
│   ├── routes/              # App Routing
│   ├── theme/               # App Theme & Styling
│   ├── utils/               # Utility Functions
│   └── widgets/             # Reusable Widgets
└── main.dart                # App Entry Point
```

## 📱 Screenshots

The app features a modern design with:

- **Dark Blue** (#1E3A8A) as primary color
- **Bright Yellow** (#F59E0B) as secondary color
- **Clean white** backgrounds with subtle shadows
- **Rounded corners** and modern input fields
- **Responsive layout** for all screen sizes

## 🛠️ Setup Instructions

### Prerequisites

- Flutter SDK (^3.8.1)
- Dart SDK
- Android Studio / VS Code
- Android/iOS device or emulator

### Installation

1. **Clone the repository**

   ```bash
   git clone <repository-url>
   cd qr_code_inventory
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Run the app**

   ```bash
   flutter run
   ```

## 📦 Dependencies

### Core Dependencies

- **get**: ^4.6.6 - State management and routing
- **http**: ^1.1.0 - HTTP client for API calls
- **shared_preferences**: ^2.2.2 - Local data storage
- **flutter_secure_storage**: ^9.0.0 - Secure data storage

### QR Code & Camera

- **qr_code_scanner**: ^1.0.1 - QR code scanning
- **qr_flutter**: ^4.1.0 - QR code generation
- **image_picker**: ^1.0.4 - Image selection
- **permission_handler**: ^11.0.1 - Camera permissions

### UI & UX

- **fluttertoast**: ^8.2.4 - Toast notifications
- **loading_animation_widget**: ^1.2.0+4 - Loading animations

## 🔧 Configuration

### API Configuration

Update the API endpoints in `lib/app/global/constants.dart`:

```dart
static const String baseUrl = 'https://your-api-url.com';
```

### Theme Customization

Modify colors and styles in `lib/app/theme/app_theme.dart`:

```dart
static const Color primaryColor = Color(0xFF1E3A8A);
static const Color secondaryColor = Color(0xFFF59E0B);
```

## 📱 Module Structure

### Authentication Module (`/auth`)

- User registration with validation
- Login functionality
- Password requirements checking
- Terms & conditions acceptance

### Home Module (`/home`)

- Dashboard with quick actions
- Recent activity feed
- Navigation to other modules
- User profile information

### QR Scanner Module (`/qr_scanner`)

- Camera permission handling
- QR code scanning interface
- Real-time QR code detection
- Scan result processing

### Inventory Module (`/inventory`)

- Item listing with search
- Category and location filtering
- Add/edit/delete operations
- QR code generation for items

## 🔐 Security Features

- **Secure Storage**: Sensitive data stored using Flutter Secure Storage
- **Token-based Authentication**: JWT tokens for API requests
- **Permission Management**: Camera and storage permissions handled properly
- **Input Validation**: Comprehensive form validation on client side

## 🎨 UI Components

### Custom Widgets

- **CustomAppBar**: Consistent app bar across modules
- **Input Fields**: Styled text inputs with validation
- **Action Cards**: Interactive cards for quick actions
- **Info Chips**: Compact information display

### Theme System

- **Color Palette**: Consistent color scheme throughout the app
- **Typography**: Poppins font family with defined text styles
- **Spacing**: Standardized spacing and padding values
- **Shadows**: Subtle elevation effects for depth

## 📊 State Management

The app uses **GetX** for state management with:

- **Reactive Programming**: `Rx` variables for reactive UI updates
- **Dependency Injection**: Automatic service injection and management
- **Route Management**: Declarative routing with bindings
- **State Persistence**: Local storage for offline functionality

## 🚀 Getting Started

1. **Start with Splash Screen**: App initialization and auth check
2. **Authentication Flow**: Register or login to access the app
3. **Dashboard Navigation**: Use bottom navigation to switch between modules
4. **QR Code Operations**: Scan existing codes or generate new ones
5. **Inventory Management**: Manage your inventory items efficiently

## 🔍 Testing

Run tests using:

```bash
flutter test
```

## 📝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License.

## 🤝 Support

For support and questions:

- Create an issue in the repository
- Contact the development team
- Check the documentation

## 🔄 Updates

Stay updated with the latest features and improvements by:

- Following the repository
- Checking release notes
- Reading the changelog

---

**Built with ❤️ using Flutter & GetX**
