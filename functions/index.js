const functions = require("firebase-functions");
const algoliasearch = require("algoliasearch");
const APP_ID = functions.config().algolia.app;
const ADMIN_KEY = functions.config().algolia.key;
const admin = require("firebase-admin");
const messagebird = require("messagebird")("LmmHoPyrSv5TM8WR0UktxvXJL");
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

    var params = {
      originator: "TestMessage",
      recipients: ["+919942648418"],
      body: "This is a test message",
    };

    messagebird.messages.create(params, function (err, response) {
      if (err) {
        return console.log(err);
      }
      console.log(response);
    });

    var payLoad = {
      notification: {
        title: "Your request has been accepted 🤩",
        body: `${newData["acceptedBy"]} has accepted your request!`,
        sound: "default",
      },
      data: {
        click_action: "FLUTTER_NOTIFICATION_CLICK",
        message: "Request has been accepted",
      },
    };

    var payLoad1 = {
      notification: {
        title: "Your request has been delivered 🤩",
        body: `${newData["deliveredBy"]} has delivered your request!`,
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

    if (newData["delivered"])
      try {
        await admin.messaging().sendToDevice(newData["deviceToken"], payLoad1);
        console.log("Notification sent");
      } catch (err) {
        console.log(err);
      }

    return index.saveObject({ ...newData, objectID });
  });

exports.deleteFromIndex = functions.firestore
  .document("Posts/{id}")
  .onDelete((snapshot) => {
    admin.firestore().collection("Archives").add(snapshot.data());
    index.deleteObject(snapshot.id);
  });
