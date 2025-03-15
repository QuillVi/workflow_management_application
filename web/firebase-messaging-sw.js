// Please see this file for the latest firebase-js-sdk version:
// https://github.com/firebase/flutterfire/blob/master/packages/firebase_core/firebase_core_web/lib/src/firebase_sdk_version.dart
importScripts("https://www.gstatic.com/firebasejs/10.7.0/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/10.7.0/firebase-messaging-compat.js");

firebase.initializeApp({
    apiKey: "AIzaSyDGF9AG-ovWQ5ydVaO1tVD24-c666JRGvQ",
    authDomain: "wordflow-4b5d5.firebaseapp.com",
    projectId: "wordflow-4b5d5",
    storageBucket: "wordflow-4b5d5.firebasestorage.app",
    messagingSenderId: "1073782415745",
    appId: "1:1073782415745:web:b5694c3339a7eddbedc880"
});

const messaging = firebase.messaging();

// Optional:
messaging.onBackgroundMessage((message) => {
  console.log("onBackgroundMessage", message);
});