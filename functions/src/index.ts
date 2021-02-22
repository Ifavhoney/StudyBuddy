import firebase from "firebase/app";
require("firebase/auth");
require("firebase/storage");
require("firebase/database");
// // Start writing Firebase Functions
// // https://firebase.google.com/docs/functions/typescript
//
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
//let date = new Date().toISOString().slice(0, 10)
let searchRef = "Home/Search/Awaiting/" + "2020-08-14" + "/";
//__searchChannelsRef = _searchRef.child("Channel").child("2020-08-14");

let channelRef = "Home/Search/Channel/" + "2020-08-14" + "/";



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





//finds one user


export const matchTest = function (user: string) {
    //check everyonee is true or is the only person there
    //find user's id
    let ref = database.ref(searchRef)
    let array: any = []
    ref.get().then((async function (snapshot) {
        if (snapshot.exists()) {

            snapshot.forEach((child: any) => array.push(child))

            for (const _ of array) {
                snapshot = _ as firebase.database.DataSnapshot;
                // key will be "ada" the first time and "alan" the second time
                //let key: string = (snapshot.key) as string;
                // childData will be the actual contents of the child
                let childData = snapshot.val()


                let hasMatched = childData["hasMatched"]
                let currUser = childData["user"]

                if (hasMatched == false && currUser != user) {
                    console.log("???")
                    await _incrementChannel()
                    // await _delete(ref, await _findKeyByEmail(ref, user))
                    // await _delete(ref, key);




                }
            }



        }
        else {
        }
    }))

}

export const _incrementChannel = function (): number {
    let channelNum: number = 0

    database.ref(channelRef).transaction((post) => {
        if (post == null) {
            return { "id": channelNum }
        }
        else {
            channelNum = (post.id as number) + 1
            return { "id": channelNum }
        }

    })
    return channelNum

}
export const _delete = function (ref: firebase.database.Reference, key: string): string {
    ref.child(key).remove();
    return key;
}

export const _findKeyByEmail = async function (ref: firebase.database.Reference, user: string): Promise<string> {
    let key: string = "";
    console.log(user)
    await ref.get().then((function (snapshot) {

        if (snapshot.exists()) {
            snapshot.forEach(function (snapshot) {

                let childData = snapshot.val()
                if (user == childData["user"]) {
                    key = (snapshot.key) as string
                }
            });
        }

    }))
    if (key == "")
        console.log("user: " + user + " does not exist")
    return key;

}
matchTest("nuthsaid5@gmail.com");


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