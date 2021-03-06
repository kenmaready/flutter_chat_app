const functions = require("firebase-functions");
const admin = require('firebase-admin');

admin.initializeApp();

exports.myFunction = functions.firestore
    .document("chat/{message}")
    .onCreate((snap, context) => {
      console.log(snap.data());
      return admin.messaging().sendToTopic("chat", {
        notification: {
          title: `Mesage from ${snap.data().username}`,
          body: snap.data().text,
          clickAction: "FLUTTTER_NOTIFICATION_CLICK"}});
    });
