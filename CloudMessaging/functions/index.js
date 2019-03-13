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
//        token = ["extmZkpiL9M:APA91bGAV5nt9AVIWRD3wvpTwAtN-QqYKFhoEHRQcalif11hWu-KYdG-dKnHq3PP5Fo9c4DmJ6R2Qch6OngyCXlZ9csO0jJM82MDcR7S9OwbXwUox38VWfmYDcC3ipI0zEnTqXiuxrU6"];

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