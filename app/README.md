# Zephyr Protocol Borrower App

<p align="center">
  <img src="app/assets/zephyr.jpg" alt="Zephyr Protocol Logo" width="200"/>
</p>

## Overview

The Zephyr Protocol Borrower App is a Flutter-based mobile application that allows users to borrow funds against their cryptocurrency collateral. Built on the Zephyr Protocol, this app provides a seamless experience for borrowers to manage their loans, track collateral, and monitor market conditions all in one place.

## Features

- **Secure Authentication**: Powered by Appwrite for easy and secure user management
- **Collateral Management**: Deposit and monitor various cryptocurrencies as collateral
- **Loan Creation**: Borrow stablecoins against your crypto holdings with customizable terms
- **Real-time Monitoring**: Track collateral ratios, interest rates, and liquidation thresholds
- **Repayment Interface**: Make full or partial loan repayments directly from the app
- **Market Analytics**: View market conditions and historical data to make informed decisions
- **Push Notifications**: Receive alerts for important events such as margin calls or rate changes
- **Transaction History**: Access complete records of all borrowing activity
- **Biometric Security**: Protect your assets with fingerprint or face recognition

## Screenshots

<p align="center">
  <img src="web/public/mob1.jpeg" alt="Home Screen" width="200"/>
  <img src="web/public/mob2.jpeg" alt="Collateral Management" width="200"/>
  <img src="web/public/mob3.jpeg" alt="Loan Creation" width="200"/>
  <img src="web/public/mob4.jpeg" alt="Analytics Dashboard" width="200"/>
  <img src="web/public/mob5.jpeg" alt="Analytics Dashboard" width="200"/>
  <img src="web/public/mob6.jpeg" alt="Analytics Dashboard" width="200"/>
</p>

## Technology Stack

- **Frontend**: Flutter, Dart
- **Authentication**: Appwrite
- **Blockchain Integration**: Web3Dart
- **State Management**: Provider/Riverpod
- **Local Storage**: Hive
- **API Integration**: Zephyr Protocol API
- **Analytics**: Firebase Analytics
- **UI Components**: Flutter Material Design, Custom Widgets

## Getting Started

### Prerequisites

- Flutter (2.10.0 or higher)
- Dart (2.16.0 or higher)
- Android Studio / XCode
- Appwrite Account
- Web3 Wallet (MetaMask or similar)

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/your-organization/zephyr-borrower-app.git
   cd zephyr-borrower-app
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Create an `.env` file in the root directory with your configuration:
   ```
   APPWRITE_ENDPOINT=https://your-appwrite-endpoint.com/v1
   APPWRITE_PROJECT_ID=your-appwrite-project-id
   ZEPHYR_API_URL=https://api.zephyrprotocol.com
   INFURA_API_KEY=your-infura-api-key
   ```

4. Run the app:
   ```bash
   flutter run
   ```

## Project Structure

```
zephyr-borrower-app/
├── android/                 # Android-specific code
├── ios/                     # iOS-specific code
├── lib/
│   ├── api/                 # API service classes
│   ├── config/              # Configuration files
│   ├── models/              # Data models
│   ├── providers/           # State management
│   ├── screens/             # App screens
│   ├── services/            # Business logic services
│   ├── utils/               # Utility functions
│   ├── widgets/             # Reusable UI components
│   ├── main.dart            # Entry point
│   └── app.dart             # App configuration
├── assets/                  # Images, fonts, etc.
├── test/                    # Unit and widget tests
└── pubspec.yaml             # Dependencies
```

## Building for Production

### Android

```bash
flutter build apk --release
# OR
flutter build appbundle --release
```

### iOS

```bash
flutter build ios --release
```

Then, finalize the build using Xcode.

## Appwrite Configuration

This app uses Appwrite for authentication and user management. To set up Appwrite:

1. Create an Appwrite account and project
2. Set up an Appwrite platform for Flutter:
   - Register a new platform in the Appwrite console
   - Add your app's bundle ID (iOS) and package name (Android)
3. Create the following collections in Appwrite:
   - Users (default)
   - Wallet Connections
   - Loan History
   - Notification Settings

## Web3 Integration

The app connects to the Ethereum blockchain using Web3Dart:

1. Users can connect their existing wallets
2. Support for multiple networks (Ethereum Mainnet, Testnet)
3. Secure transaction signing
4. Gas estimation for loan operations

## Security Features

- Secure local storage of credentials
- Biometric authentication
- Transaction signing confirmation
- Network-level encryption
- Session timeouts
- PIN code protection

## Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature-name`
3. Commit your changes: `git commit -m 'Add some feature'`
4. Push to the branch: `git push origin feature-name`
5. Open a pull request

## Testing

Run the test suite with:

```bash
flutter test
```

For coverage reports:

```bash
flutter test --coverage
flutter pub run test_coverage
```

## Troubleshooting

Common issues and their solutions:

- **Wallet Connection Errors**: Ensure you have the correct network selected
- **Authentication Issues**: Verify Appwrite credentials in .env file
- **Build Failures**: Make sure Flutter and dependencies are up to date

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support, please reach out to:
- Email: support@zephyrprotocol.com
- Discord: [Join our community](https://discord.gg/zephyrprotocol)
- Twitter: [@ZephyrProtocol](https://twitter.com/zephyrprotocol)

## Acknowledgements

- The Zephyr Protocol team for their API and protocol development
- Appwrite for their authentication and backend services
- The Flutter community for their excellent framework and libraries
- All contributors who have helped shape this application