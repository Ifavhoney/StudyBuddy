


import * as functions from 'firebase-functions';
import SearchRefs from './global/refs/search_refs'
import Keys from "./global/keys";
import firebase from "firebase/app";



//tsc - w
//find a way to enter firebase init emulators and choose db & functions
//firebase emulators:start

//Deploy: firecast jason$ firebase deploy --only functions


firebase.initializeApp({
    apiKey: Keys.APIKEY,
    authDomain: Keys.AUTHDOMAIN,
    databaseURL: Keys.DATABASEURL,
    projectId: Keys.PROJECTID,
    storageBucket: Keys.STORAGEBUCKET,
    messagingSenderId: Keys.MESSAGINGSENDERID,
    appId: Keys.APPID
})


let matchUser = require("./function/match_user");


export const onCreateMatchUser = functions.database.ref(SearchRefs.awaitingRefStr + "{documentId}")
    .onCreate(async (snapshot, context) => { matchUser.onCreate(); });


