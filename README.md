# 🚀 Kiro — Modular App Generator Framework

<div align="center">

![Kiro Banner](https://via.placeholder.com/800x200/6366F1/FFFFFF?text=KIRO)

**Generate production-ready Flutter apps with themes, modules, permissions, and payments — in minutes.**

[![Dart Version](https://img.shields.io/badge/Dart-3.0+-0175C2?style=flat-square&logo=dart)](https://dart.dev)
[![Flutter Version](https://img.shields.io/badge/Flutter-3.16+-02569B?style=flat-square&logo=flutter)](https://flutter.dev)
[![License](https://img.shields.io/badge/License-Proprietary-red?style=flat-square)](LICENSE)
[![Status](https://img.shields.io/badge/Status-In%20Development-yellow?style=flat-square)]()

[Getting Started](#-quick-start) •
[Documentation](#-documentation) •
[Modules](#-available-modules) •
[Contributing](#-contributing)

</div>

---

## 🌟 What is Kiro?

Kiro is a **next-generation modular app generator** that enables developers (and non-devel opers) to create full-fledged Flutter applications through a guided interactive flow.

Think of Kiro as:

> **Flutter + Supabase CLI + Mason + Template Engine**  
> with unlimited app generation, configurable modules, and protected core logic.

### The Vision

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                                                                              │
│   👤 User                                                                    │
│    │                                                                         │
│    ├──▶ 🌐 Visits Kiro Website / Uses CLI                                   │
│    │                                                                         │
│    ├──▶ 📝 Answers Configuration Questions                                  │
│    │     • App Name         • Theme Colors                                  │
│    │     • Category         • Modules                                       │
│    │     • Permissions      • Payments                                      │
│    │                                                                         │
│    ├──▶ ⚙️  Kiro Generates Complete App                                     │
│    │     • Template Processing                                              │
│    │     • Module Injection                                                 │
│    │     • Permission Setup                                                 │
│    │                                                                         │
│    └──▶ 📱 Production-Ready Flutter App                                     │
│          • Clean Architecture                                               │
│          • Protected Core Logic                                             │
│          • Customizable UI                                                  │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## ✨ Key Features

| Feature | Description |
|---------|-------------|
| 🏗️ **Modular Architecture** | Plug-and-play modules for Auth, Wallet, Chat, Payments, and more |
| 🎨 **Dynamic Theming** | Configurable colors, typography, and dark mode support |
| 🌍 **Localization Ready** | Multi-language support out of the box |
| 🔐 **Protected Core** | Business logic in `kiro_core` — users can only customize UI |
| ⚡ **Fast Generation** | Create complete apps in minutes, not weeks |
| 🧪 **Production Ready** | Best practices, clean architecture, comprehensive testing |
| 🔌 **Extensible** | Add custom modules to the ecosystem |

---

## 🏛️ Architecture Overview

Kiro consists of three main components:

```
kiro/
├── kiro_core/          # 📦 Private core package (protected logic)
├── kiro_cli/           # 🛠️  CLI generator tool
├── templates/          # 📄 Flutter app template
├── modules/            # 🧩 Feature modules
└── docs/               # 📚 Documentation
```

### 1. `kiro_core` — The Foundation

A private Dart/Flutter package containing all protected business logic:

- **Network Layer** — Dio client, interceptors, API handling
- **Storage Layer** — SharedPreferences, SecureStorage, caching
- **Permission Layer** — Runtime permission management
- **Theme System** — Dynamic theming with persistence
- **Localization** — Multi-language support
- **Error Handling** — Comprehensive exception system
- **Utilities** — Validators, formatters, extensions

### 2. `kiro_cli` — The Generator

A Dart console application that:

- Asks configuration questions interactively
- Processes templates and replaces placeholders
- Injects selected modules
- Configures platform permissions
- Generates ready-to-run Flutter projects

### 3. Feature Modules

Self-contained, pluggable feature packages:

| Module | Description | Status |
|--------|-------------|--------|
| 🔐 Auth | Email, Phone, Social, Biometric login | 🔄 Planned |
| 💰 Wallet | Digital wallet, transactions | 🔄 Planned |
| 💳 Payments | Razorpay, Stripe, Cashfree | 🔄 Planned |
| 💬 Chat | Real-time messaging | 🔄 Planned |
| 📅 Booking | Scheduling, appointments | 🔄 Planned |
| 🔔 Notifications | Push & local notifications | 🔄 Planned |
| 📍 Tracking | GPS, live location | 🔄 Planned |

---

## 🚀 Quick Start

### Prerequisites

- **Dart SDK** 3.0+
- **Flutter SDK** 3.16+
- **Git**

### Installation

```bash
# Clone the repository
git clone https://github.com/Kizaru6255/kiro.git
cd kiro

# Install CLI dependencies
cd kiro_cli
dart pub get

# Install CLI globally (recommended)
dart pub global activate --source path .

# Add to PATH (add this to your ~/.bashrc or ~/.zshrc)
export PATH="$PATH:$HOME/.pub-cache/bin"

# Verify installation
kiro --version
```

**Note:** If `kiro` command doesn't work after installation, make sure `$HOME/.pub-cache/bin` is in your PATH. You can add it permanently by running:

```bash
echo 'export PATH="$PATH:$HOME/.pub-cache/bin"' >> ~/.bashrc
source ~/.bashrc
```

### Creating Your First App

```bash
# Interactive mode
kiro create app

# With config file
kiro create app --config config.json

# See available options
kiro help
```

### CLI Commands

```bash
kiro create app              # Create a new Kiro app
kiro add module <name>       # Add a module to existing project
kiro doctor                  # Check system requirements
kiro upgrade                 # Upgrade kiro_core in project
kiro help                    # Show help
kiro version                 # Show version
```

---

## 📦 Available Modules

### 🔐 Auth Module

Complete authentication system with multiple providers:

- Email/Password login
- Phone OTP verification
- Social login (Google, Apple, Facebook)
- Biometric authentication
- Token management
- Session handling

### 💰 Wallet Module

Digital wallet functionality:

- View balance
- Add money
- Transaction history
- P2P transfers

### 💳 Payments Module

Multiple payment gateway integrations:

- Razorpay
- Stripe
- Cashfree
- Paytm

### 💬 Chat Module

Real-time messaging:

- One-on-one chat
- Group conversations
- Media sharing
- Typing indicators
- Read receipts

### 📅 Booking Module

Scheduling system:

- Calendar integration
- Time slot selection
- Appointment management
- Reminders

### 🔔 Notifications Module

Push and local notifications:

- Firebase Cloud Messaging
- Local notifications
- Notification channels
- Deep linking

### 📍 Tracking Module

Location services:

- Google Maps integration
- Live location tracking
- Geofencing
- Route optimization

---

## 📚 Documentation

Comprehensive documentation is available in the `/docs` folder:

| Document | Description |
|----------|-------------|
| [01_architecture.md](docs/01_architecture.md) | System architecture overview |
| [02_kiro_core_spec.md](docs/02_kiro_core_spec.md) | Core package specification |
| [03_kiro_cli_spec.md](docs/03_kiro_cli_spec.md) | CLI tool specification |
| [04_module_system.md](docs/04_module_system.md) | Module system guide |
| [05_template_engine.md](docs/05_template_engine.md) | Template processing |
| [06_roadmap.md](docs/06_roadmap.md) | Development roadmap |
| [07_coding_standards.md](docs/07_coding_standards.md) | Coding conventions |

---

## 🗺️ Roadmap

### Phase 1: Foundation ✅
- Project structure
- Documentation
- Coding standards

### Phase 2: Core Package 🔄
- Network layer
- Storage layer
- Theme system
- Utilities

### Phase 3: CLI Engine 📋
- Command system
- Interactive prompts
- Project generator

### Phase 4: Templates 📋
- Base Flutter template
- Placeholder system
- Conditional content

### Phase 5: Modules 📋
- Auth, Wallet, Payments
- Chat, Booking
- Notifications, Tracking

### Phase 6: Distribution 📋
- pub.dev publishing
- Documentation site
- Example projects

---

## 🛠️ Tech Stack

| Category | Technology |
|----------|------------|
| **Runtime** | Flutter, Dart |
| **State Management** | Riverpod |
| **Navigation** | go_router |
| **Network** | Dio |
| **Storage** | SharedPreferences, flutter_secure_storage |
| **CLI** | args, dcli |
| **Code Generation** | freezed, json_serializable |

---

## 📁 Project Structure

```
kiro/
│
├── kiro_core/                    # Core package
│   ├── lib/
│   │   ├── core/
│   │   │   ├── network/          # HTTP client, interceptors
│   │   │   ├── storage/          # Local storage
│   │   │   ├── permissions/      # Permission handling
│   │   │   ├── theme/            # Theme management
│   │   │   ├── localization/     # i18n support
│   │   │   ├── errors/           # Exception handling
│   │   │   ├── logger/           # Logging system
│   │   │   ├── routing/          # Navigation
│   │   │   ├── platform/         # Platform services
│   │   │   └── utils/            # Utilities
│   │   └── kiro_core.dart        # Public API
│   └── pubspec.yaml
│
├── kiro_cli/                     # CLI generator
│   ├── bin/
│   │   └── kiro.dart             # Entry point
│   ├── lib/
│   │   └── cli/
│   │       ├── commands/         # CLI commands
│   │       ├── generator/        # Project generator
│   │       ├── prompts/          # Interactive prompts
│   │       ├── config/           # Configuration
│   │       ├── placeholders/     # Placeholder system
│   │       └── utils/            # CLI utilities
│   └── pubspec.yaml
│
├── templates/                    # App templates
│   └── flutter_app/
│       ├── lib/
│       ├── android/
│       ├── ios/
│       └── pubspec.yaml
│
├── modules/                      # Feature modules
│   ├── auth/
│   ├── wallet/
│   ├── chat/
│   ├── booking/
│   ├── payments/
│   ├── notifications/
│   └── tracking/
│
├── docs/                         # Documentation
│   ├── 01_architecture.md
│   ├── 02_kiro_core_spec.md
│   ├── 03_kiro_cli_spec.md
│   ├── 04_module_system.md
│   ├── 05_template_engine.md
│   ├── 06_roadmap.md
│   └── 07_coding_standards.md
│
└── README.md                     # This file
```

---

## 🤝 Contributing

Contributions are welcome! Here's how you can help:

1. **Bug Reports** — Found a bug? Open an issue
2. **Feature Requests** — Have an idea? Let's discuss
3. **Code Contributions** — Submit a pull request
4. **Documentation** — Help improve the docs
5. **Module Development** — Create new modules

### Development Setup

```bash
# Clone the repository
git clone https://github.com/Kizaru6255/kiro.git
cd kiro

# Set up kiro_core
cd kiro_core
flutter pub get

# Set up kiro_cli
cd ../kiro_cli
dart pub get

# Run tests
dart test
```

### Code Style

- Follow the [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- See [07_coding_standards.md](docs/07_coding_standards.md) for project-specific conventions
- Use `dart format` before committing
- Ensure all tests pass

---

## 📄 License

**Proprietary License**

Kiro is not open-source. The core framework and modules are proprietary.
Contact the author for licensing inquiries.

---

## 👨‍💻 Author

**Chaitanya Mhetre**

- GitHub: [@chaitanyamhetre](https://github.com/Kizaru6255)
- Email: [Contact via GitHub]

---

## 🙏 Acknowledgments

Kiro is inspired by:

- [Flutter](https://flutter.dev) — Beautiful native apps in record time
- [Mason](https://github.com/felangel/mason) — Template generation
- [Supabase CLI](https://supabase.com/docs/guides/cli) — Database CLI tool
- [Riverpod](https://riverpod.dev) — State management

---

<div align="center">

**Built with ❤️ for the Flutter community**

Generate apps faster. Ship products sooner. Scale with confidence.

[⬆ Back to top](#-kiro--modular-app-generator-framework)

</div>

