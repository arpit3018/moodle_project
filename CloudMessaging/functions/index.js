const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp(functions.config().firebase);

var msgData;

exports.offerTrigger = functions.database.ref('/subjects').onUpdate(


    (snapshot,context) => {

        var siteListref = admin.database().ref().child('tokens')
        siteListref.on('value', function(snapshot){
        tokens =[]
        snapshot.forEach(function(trialSnapshot) {
        var userName = trialSnapshot.val();

        tokens.push(userName.token);
        
    });
}
        )

        var payload = {
            "notification" : {
                "title" : "Assigment Alert",
                "body" : "Kindly check! Assignment has been uploaded.",
                "sound" : "default"
            },
            "data" : {
                "sendername": "Arpit Agrawal",
                "message":"Messsage"
            }
        }

        return admin.messaging().sendToDevice(tokens,payload).then((res) => {console.log("Pushed")}).catch((err) => console.log(err));

    }
);
