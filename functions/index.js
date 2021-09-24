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
  .onUpdate(async (changes) => {
    const newData = changes.after.data();
    const objectID = changes.after.id;
    var token = [
      "eQ9h4LpZSgichpg-DNA_XG:APA91bErtIfSczDtpeIzhEwJVUNapESRzXhuh6B7UXJBM2MMCgx2n5z1fR_ZdDr4myjZ9RnFbiYGqCoePKT5cijKMXow1YudA7RXrJ4qgb6CrIQ-UmPHPUuO9pWwQnYkt9TwzDYLdUo9",
    ];
    var payLoad = {
      notification: {
        title: "Your request has been accepted 🤩",
        body: `${changes.after.data()["userName"]} has accepted your request!`,
        sound: "default",
      },
      data: {
        click_action: "FLUTTER_NOTIFICATION_CLICK",
        message: "Request has been accepted",
      },
    };

    try {
      const response = await admin.messaging().sendToDevice(token, payLoad);
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
