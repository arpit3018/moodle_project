const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp(functions.config().firebase);

var msgData;

exports.offerTrigger = functions.database.ref('/subjects').onUpdate(
    (snapshot,context) => {
        token = ["eAAv2nO1fpI:APA91bEHv4MFy2y6z0JVTJS4y4KdI3pZzqWwaI0hWBnCmYOgUDqBCmJY3Zz715BhBF6RG0Bqw2C4Dcy_dhtm4t6P6dlwg8j3MDpkd5tslPp71ib-UzhZNaASgiCSkWT8gtW7I6qJAWUV"];

        var payload = {
            "notification" : {
                "title" : "From Arpit",
                "body" : "Offer",
                "sound" : "default"
            },
            "data" : {
                "sendername": "Arpit Agrawal",
                "message":"Messsage"
            }
        }

        return admin.messaging().sendToDevice(token,payload).then((res) => {console.log("Pushed")}).catch((err) => console.log(err));

    }
);