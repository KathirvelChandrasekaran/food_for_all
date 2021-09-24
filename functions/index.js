const functions = require("firebase-functions");
const algoliasearch = require("algoliasearch");
const APP_ID = functions.config().algolia.app;
const ADMIN_KEY = functions.config().algolia.key;
const admin = require("firebase-admin");
admin.initializeApp();

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
  .onUpdate(async (changes) => {
    const newData = changes.after.data();
    const objectID = changes.after.id;

    var payLoad = {
      notification: {
        title: "Your request has been accepted 🤩",
        body: `${newData["userName"]} has accepted your request!`,
        sound: "default",
      },
      data: {
        click_action: "FLUTTER_NOTIFICATION_CLICK",
        message: "Request has been accepted",
      },
    };
    if (newData["accepted"])
      try {
        await admin.messaging().sendToDevice(newData["deviceToken"], payLoad);
        console.log("Notification sent");
      } catch (err) {
        console.log(err);
      }

    return index.saveObject({ ...newData, objectID });
  });

exports.deleteFromIndex = functions.firestore
  .document("Posts/{id}")
  .onDelete((snapshot) => {
    index.deleteObject(snapshot.id);
  });
