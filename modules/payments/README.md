# Payments Module

Payment gateway integration module for Kiro-powered Flutter applications.

## Features

- ✅ Multiple payment gateways (Razorpay, Stripe, Cashfree)
- ✅ Payment method selection
- ✅ Payment verification
- ✅ Payment history
- ✅ Wallet integration
- ✅ Riverpod state management

## Usage

### 1. Add to your app

```bash
kiro add module payments
```

### 2. Import in your app

```dart
import 'package:payments/payments.dart';
```

## API Endpoints

The module expects these endpoints:

- `POST /payments/create` - Create payment order
- `POST /payments/verify` - Verify payment
- `GET /payments/:id` - Get payment status

## Configuration

Edit `module.yaml` to configure:

- Default payment gateway
- Enable/disable wallet payments

## Dependencies

- `kiro_core` - Core infrastructure
- `flutter_riverpod` - State management
- `razorpay_flutter` (optional) - Razorpay integration

