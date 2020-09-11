const functions = require('firebase-functions');
const admin = require("firebase-admin");
const serviceAccount = require("./cloudlyapp-firebase-adminsdk-6atvy-97063f7493.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: "https://cloudlyapp.firebaseio.com"
});

exports.helloWorld = functions.https.onRequest(async(request, response) => {
  functions.logger.info("Hello logs!", {structuredData: true});
  var current = Date.now()
  const db = await admin.database()
  db.ref('items').once('value').then(function(snapshot) {
    
    snapshot.forEach((child) => {
      var subObj = child.val()
      var childKey = child.key
      Object.keys(subObj).forEach((key) => {
        var itemDate = new Date(subObj[key].date).getTime()
        var item = subObj[key]
        var diff = (itemDate - current)/(1000 * 60)
        if(diff <= -300 && item.pushed !== true) {
          enviar(item.item, item.date, item.token,"/items/"+childKey+"/"+key)
        }
      })
    })
    return 
  }).catch((err)=>{
      console.log(err)
      throw new Error();
  })
});

exports.scheduledFunction = functions.pubsub.schedule('every 1 minutes').onRun(async (context) => {
  functions.logger.info("Hello logs!", {structuredData: true});
  var current = Date.now()
  const db = await admin.database()
  db.ref('items').once('value').then(function(snapshot) {
    
    snapshot.forEach((child) => {
      var subObj = child.val()
      var childKey = child.key
      Object.keys(subObj).forEach((key) => {
        var itemDate = new Date(subObj[key].date).getTime()
        var item = subObj[key]
        var diff = (itemDate - current)/(1000 * 60)
        if(diff <= -300 && item.pushed !== true) {
          enviar(item.item, item.date, item.token,"/items/"+childKey+"/"+key)
        }
      })
    })
    return 
  }).catch((err)=>{
      console.log(err)
      throw new Error();
  })
});


async function enviar(title,body,token,path) {
    const db = await admin.database()
    var registrationToken = token;
    var message = {
        notification: {
          title: title,
          body: body
        },
      token: registrationToken
    };
  await admin.messaging().send(message)
        .then((response) => {
            db.ref(path).update({"pushed":true}) 
            return ('Successfully sent message:', response)
        })
    .catch((error) => {
      throw new Error()
            //console.log('Error sending message:', error);
        });
}