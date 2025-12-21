# 🌱 Quantum Crop Yield Optimizer (Q-CYO) – Flutter App

The **Quantum Crop Yield Optimizer (Q-CYO)** Flutter application is the frontend interface for farmers.  
It allows users to input farm data and receive AI-powered recommendations from a Python backend that uses machine learning and optimization techniques.

The application is cross-platform and runs on **Android, Web, Windows, and iOS** (iOS requires macOS).

---

## 🚀 Features

- Simple farmer-friendly interface
- Crop yield prediction
- Fertilizer recommendation
- Weather risk assessment
- Real-time communication with Python backend
- Cross-platform support

---

## 🧠 System Architecture

```text
Flutter App (UI)
      ↓ HTTP (JSON)
Python Flask API (ML + Optimization)
      ↓
Predictions & Recommendations
Q_CYO_FLUTTER_APP/
│
├── lib/
│   ├── main.dart                 # Application entry point
│   │
│   ├── screens/
│   │   └── home_screen.dart      # Farmer input form and results display
│   │
│   └── services/
│       └── api_service.dart      # HTTP API communication
│
├── pubspec.yaml                  # Flutter dependencies
└── README.md                     # Project documentation
