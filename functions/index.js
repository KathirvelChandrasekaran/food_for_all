const functions = require("firebase-functions");
const algoliasearch = require("algoliasearch");
const APP_ID = functions.config().algolia.app;
const ADMIN_KEY = functions.config().algolia.key;
const admin = require("firebase-admin");
admin.initializeApp();

const db = admin.firestore();

const client = algoliasearch(APP_ID, ADMIN_KEY);
const index = client.initIndex("posts");

// exports.updateAutomatic = functions.firestore
//   .document("Posts/{id}")
//   .onCreate((snapshot) => {
//     setTimeout(function () {
//       db.collection("Posts").doc(snapshot.id).delete();
//     }, 2000);
//   });

exports.addToIndex = functions.firestore
  .document("Posts/{id}")
  .onCreate((snapshot) => {
    const data = snapshot.data();
    const objectID = snapshot.id;
    return index.saveObject({ ...data, objectID });
  });

exports.updateIndex = functions.firestore
  .document("Posts/{id}")
  .onUpdate((changes) => {
    const newData = changes.after.data();
    const objectID = changes.after.id;
    return index.saveObject({ ...newData, objectID });
  });

exports.deleteFromIndex = functions.firestore
  .document("Posts/{id}")
  .onDelete((snapshot) => {
    index.deleteObject(snapshot.id);
  });
