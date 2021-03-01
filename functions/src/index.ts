
import * as functions from 'firebase-functions';

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
let searchRef: string = "Home/Search/";
let searchAwaitingRef: string = searchRef + "Awaiting/" + "2020-08-14/";
//__searchChannelsRef = _awaitingRef.child("Channel").child("2020-08-14");

let searchChannelCountRef: string = searchRef + "Count/Channel/" + "2020-08-14/";
let searchAwaitingCountRef: string = searchRef + "Count/Awaiting/" + "2020-08-14/";


let searchConfirmedRef: string = searchRef + "Confirmed/" + "2020-08-14/";


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


export const matchTest = async function (randUser: string, randKey: string) {
    //check everyonee is true or is the only person there
    //find user's id
    console.log("enters here")
    let awaitingRef = database.ref(searchAwaitingRef)
    let confirmdRef = database.ref(searchConfirmedRef)
    let channeCountRef = database.ref(searchChannelCountRef)

    let awaitingCountRef = database.ref(searchAwaitingCountRef)

    let array: any = []

    await awaitingRef.get().then((async function (snapshot) {
        if (snapshot.exists()) {

            snapshot.forEach((child: any) => array.push(child))
            console.log(array.length());

            for (const _ of array) {
                snapshot = _ as firebase.database.DataSnapshot;

                let childData = snapshot.val()

                let hasMatched = childData["hasMatched"]
                let currUser = childData["user"]
                console.log(currUser);
                console.log("rana user is " + randUser.toString())
                console.log(hasMatched.toString())




                if (hasMatched == false && currUser != randUser) {
                    console.log("comes in hasmatched")
                    await _delete(awaitingRef, randKey)
                    await _delete(awaitingRef, (snapshot.key) as string);
                    let channelNum: number = await _updateRef(channeCountRef)
                    await _updateRef(awaitingCountRef, false);
                    await _updateRef(awaitingCountRef, false);

                    await _add(confirmdRef, {
                        users: [randUser, currUser],
                        timer: childData["timer"],
                        channel: channelNum
                    })


                }
            }
        }
        else {
            console.log("snapshot does not exist")
        }

    }))
}


export const _updateRef = async function (ref: firebase.database.Reference, increment = true): Promise<number> {
    let num: number = 1
    await ref.transaction((post) => {
        if (post == null) {
            return { "id": num }
        }
        else {
            if (increment)
                num = (post.id as number) + 1
            else
                num = (post.id as number) - 1
            console.log("stops here?? " + num.toString());
            return { "id": num }
        }

    })
    console.log("comes here?? and is " + num.toString())


    return num

}



export const _add = function (ref: firebase.database.Reference, value: any): void {
    ref.set(value)
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

//matchTest("jason@defhacks.co", "-MUfCEytViFua68CH7dY");
export const _findRandomUser = async function (ref: firebase.database.Reference): Promise<Record<string, string>> {
    let user: Record<string, string> = {}
    await ref.limitToFirst(1).get().then((async function (snapshot) {

        snapshot.forEach(function (snapshot) {
            user = {
                email: snapshot.val()["user"],
                key: (snapshot.key) as string
            }

        });


    }))
    return user;
}



//_updateRef(database.ref(searchAwaitingCountRef));
//firecast jason$ firebase deploy --only functions
//ts-node index.ts
export const match = functions.database.ref(searchAwaitingRef + "{documentId}")
    .onCreate(async (snapshot, context) => {
        let awaitingCountRef = database.ref(searchAwaitingCountRef)
        let num: number = await _updateRef(awaitingCountRef)
        console.log(num)
        if (num % 2 == 0) {
            console.log("is here " + num.toString())
            let r: Record<string, string> = await _findRandomUser(database.ref(searchAwaitingRef))
            console.log(r)
            await matchTest(r["email"], r["key"]);

        }



        //increment count
        /*  
        console.log(context.params.date)
        snapshot.child(context.params.date).forEach((snapshot: DataSnapshot) => {
            console.log(snapshot.key)

        })
        */

        /*
        // Grab the current value of what was written to the Realtime Database.
        const original = snapshot.val();

        console.log('Uppercasing', context.params.pushId, original);
        const uppercase = original.toUpperCase();
        // You must return a Promise when performing asynchronous tasks inside a Functions such as
        // writing to the Firebase Realtime Database.
        // Setting an "uppercase" sibling in the Realtime Database returns a Promise.
        return snapshot.ref.parent.child('uppercase').set(uppercase);
        */

    });


//on write -> check change both to true if all good
//