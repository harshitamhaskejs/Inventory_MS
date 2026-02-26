importScripts("https://www.gstatic.com/firebasejs/10.12.2/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/10.12.2/firebase-messaging-compat.js");

firebase.initializeApp({
  apiKey: "AIzaSyAVEEyXIgAgseGFEPt4i6nezAS_6TXXuKs",
  authDomain: "imsapp-619b6.firebaseapp.com",
  projectId: "imsapp-619b6",
  messagingSenderId: "547704030976",
  appId: "1:547704030976:web:d5c5ad3545b213fd77d5e5",
});

const messaging = firebase.messaging();

messaging.onBackgroundMessage(function(payload) {
  self.registration.showNotification(payload.notification.title, {
    body: payload.notification.body,
    icon: "./assets/logo.png"
  });
});


const CACHE_NAME = "ims-cache-v4"; // bump this every time you change SW
const ASSETS = [
  "./",
  "./index.html",
  "./app.js",
  "./manifest.json",
  "./assets/logo.png"
];

// Install: pre-cache core assets
self.addEventListener("install", (e) => {
  e.waitUntil(caches.open(CACHE_NAME).then((cache) => cache.addAll(ASSETS)));
  self.skipWaiting();
});

// Activate: delete old caches
self.addEventListener("activate", (e) => {
  e.waitUntil(
    caches.keys().then((keys) =>
      Promise.all(keys.filter((k) => k !== CACHE_NAME).map((k) => caches.delete(k)))
    )
  );
  self.clients.claim();
});

// Fetch:
// - For navigations, always serve index.html (app shell)
// - For others, cache-first
self.addEventListener("fetch", (e) => {
  const req = e.request;

  if (req.mode === "navigate") {
    e.respondWith(
      fetch(req)
        .then((res) => {
          const copy = res.clone();
          caches.open(CACHE_NAME).then((cache) => cache.put("./index.html", copy));
          return res;
        })
        .catch(() => caches.match("./index.html"))
    );
    return;
  }

  e.respondWith(
    fetch(req)
      .then((res) => {
        const copy = res.clone();
        caches.open(CACHE_NAME).then((cache) => cache.put(req, copy));
        return res;
      })
      .catch(() => caches.match(req))
  );
});

self.addEventListener("notificationclick", function(event) {
  event.notification.close();

  event.waitUntil(
    clients.matchAll({ type: "window", includeUncontrolled: true })
      .then(function(clientList) {

        for (const client of clientList) {
          if (client.url.includes("index.html") && "focus" in client) {
            return client.focus();
          }
        }

        if (clients.openWindow) {
          return clients.openWindow("./");
        }
      })
  );
});