# DeliHood iOS App

A SwiftUI-based iOS application that serves as the client for **DeliHood**, a platform enabling users to order meals directly from neighbors rather than restaurants.

The app is built with **SwiftUI** and follows the **MVVM** architecture pattern, integrating with a backend API for authentication, payments, and real-time updates.

---

## ⚙️ Features

- **User Authentication** – Secure login and signup using JWT tokens.
- **Browse Meals** – Explore meals offered by local neighbors.
- **Order Management** – Place, track, and manage food orders.
- **Stripe Integration** – Handles secure payments and transactions.
- **Live Updates** – Real-time order state changes with Live Activities (iOS 16+).
- **Modern UI** – Built with iOS26 Liquid Glass, following Apple’s design principles.

---

## 🛠️ Tech Stack

- **SwiftUI** – UI layer, declarative interface.
- **MVVM** – Clear separation of logic and UI state.
- **Combine** – Data binding and reactive state updates.
- **WidgetKit + ActivityKit** – Live Activity updates on lock screen.
- **Backend API** – Express.js server with PostgreSQL database.
- **Stripe SDK** – Payment handling.

---

## 🖥️ Project Structure

```
DeliHood/
├── Models/         # Data models
├── Screens/        # Main screens
├── Views/          # SwiftUI Views
├── Utils/          # Networking & Help classes
└── DeliHoodApp.swift
```

---

## 🚀 Running the project

1. Clone the repository:

   ```bash
   git clone https://github.com/VFluger/delihood_ios.git
   ```

2. Open the project in **Xcode** (15+ recommended).

3. Install dependencies (Stripe SDK, etc.):  
   This project uses SPM

4. Configure environment variables:

   - NetworkManager.baseUrl
   - in Root Stripe publishable key

5. Run the app on simulator or device.

---

## 📲 Related Repositories

[📘 SOČ Work (Documentation PDF)](TODO_LINK)
[📱 Delihood Node.js Backend (Express.js)](https://github.com/VFluger/delihood_backend)

## License

This project is licensed under the MIT License. See the [LICENSE](/LICENSE.txt) file for details.
