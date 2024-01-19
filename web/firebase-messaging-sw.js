// Give the service worker access to Firebase Messaging.
// Note that you can only use Firebase Messaging here. Other Firebase libraries
// are not available in the service worker.
importScripts('https://www.gstatic.com/firebasejs/8.10.1/firebase-app.js');
importScripts('https://www.gstatic.com/firebasejs/8.10.1/firebase-messaging.js');

// Initialize the Firebase app in the service worker by passing in
// your app's Firebase config object.
// https://firebase.google.com/docs/web/setup#config-object
firebase.initializeApp({
  apiKey: "AIzaSyDhjRDDpFXB_cBSNxuPjRoN_frrYRZE334",
  authDomain: "drawing-on-demand.firebaseapp.com",
  databaseURL: "https://drawing-on-demand-default-rtdb.asia-southeast1.firebasedatabase.app",
  projectId: "drawing-on-demand",
  storageBucket: "drawing-on-demand.appspot.com",
  messagingSenderId: "680472686977",
  appId: "1:680472686977:web:af632211e99dcc9046b880",
  measurementId: "G-EESB90S8T4"
});

// Retrieve an instance of Firebase Messaging so that it can handle background
// messages.
const messaging = firebase.messaging();