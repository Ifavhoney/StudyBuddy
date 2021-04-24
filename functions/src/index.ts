


import * as functions from 'firebase-functions';
import SearchRefs from './global/refs/search_refs'
import Keys from "./global/keys";
//import Global from './global/global';
import firebase from "firebase/app";

//matchTest("jason@defhacks.co", "-MWo_LwLHUXtldMEUdrw");

//_updateRef(database.ref(searchAwaitingCountRef));
//firecast jason$ firebase deploy --only functions
//ts-node index.ts

//find a way to enter firebase wizard (init emulators) and choose db & functions
//firebase emuulators:start
// npm build before releasing, and then deploy


//    console.log(num.toString());
firebase.initializeApp({
    apiKey: Keys.APIKEY,
    authDomain: Keys.AUTHDOMAIN,
    databaseURL: Keys.DATABASEURL,
    projectId: Keys.PROJECTID,
    storageBucket: Keys.STORAGEBUCKET,
    messagingSenderId: Keys.MESSAGINGSENDERID,
    appId: Keys.APPID
})






export const onCreateMatchUser = functions.database.ref(SearchRefs.awaitingRefStr + "{documentId}")
    .onCreate(async (snapshot, context) => {
        //   let num: number = await Global.updateRef(Global.awaitingCountRef)

        let matchUser = require("./function/match_user");
        matchUser.matchUser(firebase.database(), "hii");

        console.log("ugh")


    });


