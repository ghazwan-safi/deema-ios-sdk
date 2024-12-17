# Deema SDK for iOS

## Introduction

The **Deema SDK** for iOS enables you to integrate our Buy Now, Pay Later (BNPL) payment solution into your iOS applications seamlessly. This SDK allows you to launch a payment interface and handle payment statuses with a clean and declarative API.

---

## Prerequisites

- **iOS Deployment Target**: 13.0 or later.
- **Swift Package Manager (SPM)**: Required to integrate the SDK.

---

## Installation

### Using Swift Package Manager (SPM)

1. In your Xcode project, go to **File > Add Packages**.
2. Enter the repository URL for the Deema SDK:
   ```
   https://github.com/Deema/DeemaSDK-Package.git
   ```
3. Select the `main` branch and add it to your project.

---

## Quick Start

### Step 1: Import the SDK

```swift
import DeemaSDK
```

### Step 2: Use the `DeemaSDK` View

The SDK provides a SwiftUI view, `DeemaSDK`, which you can include in your application. Here's how to use it:

```swift
DeemaSDK(
    SDK_Key: SDK_Key, 
    amount: "100.0", 
    merchant_id: "123", 
    currency: "KWD", 
    environment: Environment.sandbox
    ) { message, status in
        switch status {
        case .success:
            print("Payment successful: \(message ?? "No message")")
        case .failure:
            print("Payment failed: \(message ?? "No message")")
        case .canceled:
            print("Payment canceled")
        case .unknown:
            print("Unknown payment result")
        }
    }
} 
```

---

## API Reference

### Environment

An enum specifying the environment for the SDK:
- **`sandbox`**: Use for development and testing.
- **`production`**: Use for live transactions.

### DeemaSDK View

The primary view for integrating the SDK into your application.

#### Parameters:
- **`SDK_Key`**: `String` (required) - The SDK key provided by Deema for authentication.
- **`amount`**: `String` (required) - The transaction amount.
- **`merchant_id`**: `String` (required) - The unique identifier for the merchant.
- **`currency`**: `String` (required) - The currency code ("KWD" or "BHD").
- **`environment`**: `Environment` (required) - The environment for the transaction (`sandbox` or `production`).
- **`completion`**: `(String?, PaymentStatus) -> Void` (required) - A callback to handle the payment result.

### PaymentStatus

An enum that represents the result of the payment process:
- **`success`**: Payment was successful.
- **`failure`**: Payment failed.
- **`canceled`**: Payment was canceled by the user.
- **`unknown`**: An unknown error occurred.

---

## Example Integration

Here’s an example demonstrating the integration of the **Deema SDK** in a SwiftUI app:

```swift
import SwiftUI
import DeemaSDK

struct ContentView: View {
    @State private var merchant_id = "1726"
    @State private var amount = "150"
    @State private var currency = "USD"
    @State private var SDK_Key = "sk_test_your_sdk_key_here"
    var environment = Environment.production
    
    @State private var isDeemaSdkOpen = false
    
    var body: some View {
        VStack {
            if isDeemaSdkOpen {
                DeemaSDK(SDK_Key: SDK_Key, 
                         amount: amount, 
                         merchant_id: merchant_id, 
                         currency: currency, 
                         environment: environment) { message, status in
                    isDeemaSdkOpen.toggle()
                    
                    switch status {
                    case .success:
                        print("Payment Success")
                    case .Faulure:
                        print("Payment Failed: \(message ?? "No message")")
                    case .canceled:
                        print("Payment Canceled")
                    case .unknown:
                        print("Unknown Payment Status")
                    }
                }
            } else {
                Button(action: {
                    isDeemaSdkOpen.toggle()
                }) {
                    Text("Open Deema SDK")
                        .font(.headline)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
        }
        .padding()
    }
}
```
---

## Error Handling

When the `completion` handler is called, the payment result is provided as a `PaymentStatus` enum. Here's how you can handle the different states:

- **`success`**: The payment was completed successfully. Optionally, you can display a confirmation message or update your app's UI.
- **`failure`**: The payment failed due to an error. You can access an optional error message to display to the user.
- **`canceled`**: The user canceled the payment process. You can handle this gracefully, such as allowing the user to retry.
- **`unknown`**: An unexpected result occurred. Log the error and optionally notify your support team for investigation.

