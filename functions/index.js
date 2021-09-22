const functions = require("firebase-functions");
const algoliasearch = require("algoliasearch");
const APP_ID = functions.config().algolia.app;
const ADMIN_KEY = functions.config().algolia.key;

const client = algoliasearch(APP_ID, ADMIN_KEY);
const index = client.initIndex("posts");

exports.addToIndex = functions.firestore
  .document("Posts/{id}")
  .onCreate((snapshot) => {
    const data = snapshot.data();
    const objectID = snapshot.id;
    return index.addObject({ ...data, objectID });
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
