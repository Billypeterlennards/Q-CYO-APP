
# 🌱 Q-CYO Flutter App

**Quantum Crop Yield Optimizer (Q-CYO)**

The **Q-CYO Flutter App** is the frontend client of the Quantum Crop Yield Optimizer system.
It provides a simple, farmer-friendly interface for collecting farm data and displaying **AI-powered crop yield predictions, fertilizer recommendations, and weather risk assessments** from a Python backend.

---

## 📌 Application Overview

| Item          | Description                          |
| ------------- | ------------------------------------ |
| App Name      | Quantum Crop Yield Optimizer (Q-CYO) |
| Platform      | Flutter                              |
| Supported OS  | Windows, Android, Web, iOS           |
| Backend       | Python Flask REST API                |
| Communication | HTTP (JSON)                          |

---

## 🧠 System Role

```text
Flutter App (UI)
      ↓ HTTP (JSON)
Python Flask API
      ↓
Predictions & Recommendations
```

---

## 🚀 Key Features

| Feature                   | Description                       |
| ------------------------- | --------------------------------- |
| Farmer-Friendly UI        | Simple data input forms           |
| Crop Yield Prediction     | Yield per hectare and total yield |
| Fertilizer Recommendation | Optimized fertilizer amount       |
| Weather Risk Assessment   | Low / Medium / High risk          |
| Real-Time API Calls       | Live backend communication        |
| Cross-Platform            | Single codebase for all platforms |

---

## 📁 Project Structure

```text
Q_CYO_FLUTTER_APP/
│
├── lib/
│   ├── main.dart                 # Application entry point
│   │
│   ├── screens/
│   │   └── home_screen.dart      # Farmer input form & results display
│   │
│   └── services/
│       └── api_service.dart      # HTTP API communication
│
├── pubspec.yaml                  # Flutter dependencies
└── README.md                     # Application documentation
```

---

## 📄 Folder Description

| Path                        | Purpose                    |
| --------------------------- | -------------------------- |
| `lib/main.dart`             | App initialization         |
| `screens/home_screen.dart`  | UI for farm data & results |
| `services/api_service.dart` | Backend API communication  |
| `pubspec.yaml`              | Dependency management      |

---

## 🔗 Backend Integration

The Flutter app communicates with the **Q-CYO Python Backend** using RESTful HTTP requests.

---

## 📡 API Communication Details

| Item         | Value              |
| ------------ | ------------------ |
| Method       | POST               |
| Endpoint     | `/recommend`       |
| Content-Type | `application/json` |

### Example Request

```json
{
  "area": 5,
  "crop_type": "maize",
  "rainfall": 120,
  "soil_type": "sandy",
  "temperature": 26
}
```

### Example Response

```json
{
  "yield_per_hectare": 12.46,
  "total_yield": 62.3,
  "fertilizer_kg_per_ha": 292,
  "weather_risk": "LOW"
}
```

---

## ⚙️ Setup Instructions

### 1️⃣ Install Flutter Dependencies

```bash
flutter pub get
```

---

### 2️⃣ Configure API Base URL

📄 `lib/services/api_service.dart`

```dart
static const String baseUrl = "http://127.0.0.1:5000";
```

⚠️ **Important for Windows**

| Platform        | URL                     |
| --------------- | ----------------------- |
| Flutter Windows | `http://127.0.0.1:5000` |
| Not Recommended | `localhost`             |

---

### 3️⃣ Run the Application

| Platform      | Command                  |
| ------------- | ------------------------ |
| Windows       | `flutter run -d windows` |
| Android / Web | `flutter run`            |

---

## 🌍 Production Configuration

After deploying the backend, update the base URL:

```dart
static const String baseUrl = "https://your-backend-url";
```

✔ Use **HTTPS** for production environments.

---

## 🧪 Error Handling

| Scenario        | Behavior                      |
| --------------- | ----------------------------- |
| Network failure | Displays error message        |
| Invalid input   | Handled by backend validation |
| API failure     | Graceful UI feedback          |

---

## ✅ App Summary

| Aspect              | Status |
| ------------------- | ------ |
| UI-Only Frontend    | ✅      |
| Backend Independent | ✅      |
| Cross-Platform      | ✅      |
| Real-Time Data      | ✅      |
| Production-Ready    | ✅      |

---

## 🌾 Application Name

**Quantum Crop Yield Optimizer (Q-CYO)**
*AI-Driven Agriculture for Smarter Farming*




