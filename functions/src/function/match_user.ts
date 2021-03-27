
import Global from "../global/global";
import firebase from "firebase/app";
require("firebase/auth");
require("firebase/storage");
require("firebase/database");


export const matchTest = async function (randUser: string, randKey: string) {
    //check everyonee is true or is the only person there
    //find user's id
    console.log("enters here")
    let awaitingRef = database.ref(searchAwaitingRef)
    let confirmdRef = database.ref(searchConfirmedRef)
    let channeCountRef = database.ref(searchChannelCountRef)

    let awaitingCountRef = database.ref(searchAwaitingCountRef)


    let array: any = []
    await Global.awaitingRef.get().then((async function (snapshot) {
        if (snapshot.exists()) {
            console.log(snapshot.toJSON())
            snapshot.forEach((child) => { array.push(child) });

            console.log(array.length)
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
