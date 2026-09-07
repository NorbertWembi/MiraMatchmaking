# MiraMatchmaking
This is a matchmaking app set to connect people all over the world. People can connect as friends, professionals, or even for dating.
=======


## Tech Stack

### **Frontend**

* Flutter (Dart)
* HTTP client
* Google Places API integration

### **Backend**

* Node.js + Express
* MongoDB Atlas
* JWT Authentication
* Bcrypt password hashing

---

## Prerequisites

Before running the app, install the following tools:

### **1. Install Flutter**

Follow installation instructions for your OS:
🔗 [https://docs.flutter.dev/get-started/install](https://docs.flutter.dev/get-started/install)

### **2. Install Node.js**

Download from:
🔗 [https://nodejs.org/en/download](https://nodejs.org/en/download)

### **3. Install MongoDB Community Edition**

Install the Community Edition for your OS.

You may also install **mongosh** (optional) for CLI database interactions:
🔗 [https://www.mongodb.com/docs/mongodb-shell/](https://www.mongodb.com/docs/mongodb-shell/)

---

## Project Setup

Clone the repository:

```sh
git clone <REPO_URL>
cd <project-folder>
```

---

## Backend Setup

### **1. Navigate to the backend folder**

```sh
cd backend
```

### **2. Install backend dependencies**

```sh
npm install
```

### **3. Add environment variables**

Create a `.env` file inside the `/backend` directory:

```
MONGODB_URI=<your_mongodb_connection_string>
JWT_SECRET=<your_jwt_secret_key>
GOOGLE_MAPS_API_KEY=<your_google_maps_api_key>
```

### **4. Run the backend**

```sh
npm run dev
```

The backend will start on:

```
http://localhost:5000
```

(or whichever port is configured in the server.)

---

## Frontend Setup (Flutter)

From the project root (or `/frontend` if separated):

### **1. Clean existing Flutter build cache**

```sh
flutter clean
```

### **2. Install Flutter dependencies**

```sh
flutter pub get
```

### **3. Run the application**

```sh
flutter run
```

This will compile and launch the app on either:

* A connected physical device
* An Android/iOS emulator

---

## APIs & Keys Required

The app requires the following keys:

### **Google Maps Places API**

Used during signup for location auto-complete.
Enable in Google Cloud Console under **APIs & Services**.

### **MongoDB Atlas Connection String**

Required by the backend to access the database.

Store all keys securely inside `.env`.
