# Sandwich Shop App

## Overview

A Flutter application enabling sandwich customization and ordering, featuring size selection, bread choices, and quantity management.

## Features 

* 🥪 Size options: six-inch or footlong
* 🍞 Multiple bread types
* ✏️ Custom order notes
* 🔢 Quantity management
* 📱 Material Design UI

## Installation

### Prerequisites

* Flutter SDK (>=2.17.0)
* Dart SDK
* Visual Studio Code or Android Studio
* Flutter development plugins

### Setup Steps

```bash
# Clone repository
git clone [https://github.com/Adefola-lab/sandwich_shop.git]
cd sandwich_shop

# Install dependencies
flutter pub get

# Run application
flutter run
```

## Usage

### Launch
1. Open the app to "Sandwich Counter" screen

### Customize Order

1. **Size Selection**
   * Toggle switch between six-inch and footlong

2. **Bread Selection**
   * Choose from dropdown menu:
     * White
     * Wheat
     * Wholemeal

3. **Order Details**
   * Add special instructions in notes field
   * Manage quantity:
     * Click "Add" to increase
     * Click "Remove" to decrease
     * Maximum limit: 10 sandwiches

## Project Structure

```
sandwich_shop/
├── lib/
│   ├── main.dart           # App entry point
│   ├── views/
│   │   └── app_styles.dart # UI styling
│   └── repositories/
│       └── order_repository.dart
├── test/
│   └── widget_test.dart
└── pubspec.yaml
```

## Technical Stack

### Framework & Languages
* Flutter SDK
* Dart Programming Language

### Design
* Material Design Components
* Custom styling implementation

### Testing
* Flutter Testing Framework
* Widget tests included

## Limitations

* Maximum order quantity fixed at 10
* Limited bread selections available
* Basic styling implementation
* No persistent storage
* Single screen implementation

## Development

### Running Tests

```bash
flutter test
```

## Contact

[Adefola Adeoye]  
[folaoluwaaa@gmail.com]  


## License

[License Type] - See LICENSE file for details

---

**Note:** Replace all bracketed content `[like this]` with your specific information.