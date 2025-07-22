# Tripple Prime Mobile App

A comprehensive mobile-first food savings application built with Flutter. Tripple Prime helps users save money for their food needs through flexible savings plans and a user-friendly interface.

## Features

- **User Authentication**: Secure login and registration system
- **Food Pack Browsing**: Browse through various food packs with detailed information
- **Savings Plans**: Create and manage savings plans for food packs
- **Payment Integration**: Secure payment processing with multiple payment methods
- **Profile Management**: User profile management and settings
- **Progress Tracking**: Track savings progress and payment schedules

## Getting Started

### Prerequisites

- Flutter SDK (3.0.0 or higher)
- Dart SDK (3.0.0 or higher)
- Android Studio / VS Code with Flutter extensions

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/triple_prime_mobile.git
   ```

2. Navigate to the project directory:
   ```bash
   cd triple_prime_mobile
   ```

3. Install dependencies:
   ```bash
   flutter pub get
   ```

4. Run the app:
   ```bash
   flutter run
   ```

## Project Structure

```
lib/
├── core/
│   ├── constants/
│   ├── theme/
│   └── utils/
├── features/
│   ├── auth/
│   ├── browse/
│   ├── dashboard/
│   ├── profile/
│   └── savings/
├── shared/
│   ├── models/
│   └── widgets/
└── main.dart
```

## Architecture

The app follows a feature-first architecture with BLoC pattern for state management. Each feature is organized into its own directory with the following structure:

```
feature/
├── data/
│   ├── models/
│   └── repositories/
├── domain/
│   ├── entities/
│   └── repositories/
└── presentation/
    ├── bloc/
    ├── pages/
    └── widgets/
```

## Dependencies

- `flutter_bloc`: State management
- `dio`: HTTP client
- `flutter_secure_storage`: Secure storage
- `google_fonts`: Custom fonts
- `flutter_svg`: SVG rendering
- `intl`: Internationalization and formatting
- `flutter_animate`: Animations
- `flutter_staggered_grid_view`: Grid layouts
- `cached_network_image`: Image caching

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Design inspiration from modern food delivery and fintech apps
- Flutter team for the amazing framework
- All contributors who help improve the app
