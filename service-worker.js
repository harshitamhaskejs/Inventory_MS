const CACHE_NAME = "ims-cache-v3"; // bump this every time you change SW
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

  // App shell routing for standalone PWA navigations
  if (req.mode === "navigate") {
    e.respondWith(
      caches.match("./index.html").then((cached) => cached || fetch("./index.html"))
    );
    return;
  }

  e.respondWith(
    caches.match(req).then((cached) => cached || fetch(req))
  );
});