importScripts("https://www.gstatic.com/firebasejs/9.22.0/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/9.22.0/firebase-messaging-compat.js");

const firebaseConfig = {
  apiKey: "AIzaSyAZBR0tS6UMXqVpSdoJ4eQhrbB1V_X0IU8",
  authDomain: "findit-ethiopia.firebaseapp.com",
  projectId: "findit-ethiopia",
  storageBucket: "findit-ethiopia.firebasestorage.app",
  messagingSenderId: "1066462249856",
  appId: "1:1066462249856:web:eb66168d096dab6737b765",
  measurementId: "G-WHJQVRTXJ5"
};

firebase.initializeApp(firebaseConfig);

const messaging = firebase.messaging();

messaging.onBackgroundMessage(function(payload) {
  console.log('[firebase-messaging-sw.js] Received background message ', payload);
  // Customize notification here
  const notificationTitle = payload.notification.title;
  const notificationOptions = {
    body: payload.notification.body,
    icon: '/icons/Icon-192.png'
  };

  return self.registration.showNotification(notificationTitle,
    notificationOptions);
});
