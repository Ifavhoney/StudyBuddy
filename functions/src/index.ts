

import * as functions from 'firebase-functions';
import { matchUser } from './function/match_user'
//import global from './global/global';
import SearchRefs from './global/refs/search_refs'

require("firebase/auth");
require("firebase/storage");
require("firebase/database");
//matchTest("jason@defhacks.co", "-MWo_LwLHUXtldMEUdrw");

//_updateRef(database.ref(searchAwaitingCountRef));
//firecast jason$ firebase deploy --only functions
//ts-node index.ts

//find a way to enter firebase wizard (init emulators) and choose db & functions
//firebase emuulators:start
// npm build before releasing, and then deploy



export const onCreateMatchUser = functions.database.ref(SearchRefs.awaitingRefStr + "{documentId}")
    .onCreate(async (snapshot, context) => { matchUser });



