import firebase from "firebase/app";
require("firebase/auth");
require("firebase/storage");
require("firebase/database");
// // Start writing Firebase Functions
// // https://firebase.google.com/docs/functions/typescript
//


/*
export const helloWorld = functions.https.onRequest((request, response) => {
    functions.logger.info("Hello logs!", { structuredData: true });
    console.log(2)
    response.send("Hello from Firebase! {}");


});

//takes a request object e.g body, and response to srver
export const randomNumber = functions.https.onRequest((request, response) => {
    const number = Math.round(Math.random() * 100)
    console.log(number)
    response.send(number.toString())

})
*/

// Get a reference to the database service


const config = {
    apiKey: "AIzaSyDAVQKetyGYOocSnqL-5UomtfltVtQrbq0",
    authDomain: "studybuddy-a39ca.firebaseapp.com",
    databaseURL: "https://studybuddy-a39ca.firebaseio.com",
    projectId: "studybuddy-a39ca",
    storageBucket: "studybuddy-a39ca.appspot.com",
    messagingSenderId: "610079262652",
    appId: "1:610079262652:web:20b1c7e7d4fda3da0e0db9"
};



let database = firebase.initializeApp(config).database()
let searchRef = "Home/Search/Awaiting";



//finds one user

export const matchTest = function (user: string) {
    //check everyonee is true or is the only person there
    database.ref(searchRef).get().then((function (snapshot) {
        if (snapshot.exists()) {
            console.log("i exist")

        }
        else {
            console.log("no data")
        }
    }))

}

matchTest("usr");

// export const match = functions.database.ref(searchRef + '/{date}/{id}')
//     .onCreate((snapshot, context) => {
//         console.log("i am here")
//         functions.database.ref("sss").
//         /*  
//         console.log(context.params.date)
//         snapshot.child(context.params.date).forEach((snapshot: DataSnapshot) => {
//             console.log(snapshot.key)

//         })
//         */

//         /*
//         // Grab the current value of what was written to the Realtime Database.
//         const original = snapshot.val();

//         console.log('Uppercasing', context.params.pushId, original);
//         const uppercase = original.toUpperCase();
//         // You must return a Promise when performing asynchronous tasks inside a Functions such as
//         // writing to the Firebase Realtime Database.
//         // Setting an "uppercase" sibling in the Realtime Database returns a Promise.
//         return snapshot.ref.parent.child('uppercase').set(uppercase);
//         */
//     });


//on write -> check change both to true if all good
//