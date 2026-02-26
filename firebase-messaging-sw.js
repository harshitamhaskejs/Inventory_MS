importScripts("https://www.gstatic.com/firebasejs/10.12.2/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/10.12.2/firebase-messaging-compat.js");

firebase.initializeApp({
  apiKey: "AIzaSyAVEEyXIgAgseGFEPt4i6nezAS_6TXXuKs",
  authDomain: "imsapp-619b6.firebaseapp.com",
  projectId: "imsapp-619b6",
  messagingSenderId: "547704030976",
  appId: "1:547704030976:web:d5c5ad3545b213fd77d5e5"
});

const messaging = firebase.messaging();

messaging.onBackgroundMessage(function(payload) {
  self.registration.showNotification(payload.notification.title, {
    body: payload.notification.body,
  });
});