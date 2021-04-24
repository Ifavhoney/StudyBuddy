import Global from "../global/global";
import firebase from "firebase/app";


export const onCreate = async function () {

    let num: number = await Global.updateRef(Global.awaitingCountRef);

    if (num % 2 == 0) {

        let r: Record<string, string> = await Global.findRandomUser(Global.awaitingRef);

        await _matchBothUsers(r["email"], r["key"]);

    }

}

const _matchBothUsers = async function (randUser: string, randKey: string) {
    //check everyonee is true or is the only person there
    //find user's id
    let array: any = []
    await Global.awaitingRef.get().then((async function (snapshot) {
        if (snapshot.exists()) {
            snapshot.forEach((child) => { array.push(child) });

            for (const _ of array) {
                snapshot = _ as firebase.database.DataSnapshot;

                let childData = snapshot.val()
                let hasMatched = childData["hasMatched"]
                let snapshotUser = childData["user"];

                if (hasMatched == false && snapshotUser != randUser) {

                    _match(randUser, randKey, childData["user"], (snapshot.key as string), childData["timer"])

                    break;
                }
            }
        }
        else {

            console.log("snapshot does not exist")
        }

    }))
}


const _match = async function (randUser: string, randKey: string, snapshotUser: string, snapshotKey: string, timer: number) {


    if (snapshotUser != randUser) {
        Global.delete(Global.awaitingRef, randKey);
        Global.delete(Global.awaitingRef, snapshotKey);

        let channelNum: number = await Global.updateRef(Global.channeCountRef);

        Global.updateRef(Global.awaitingCountRef, false); Global.updateRef(Global.awaitingCountRef, false);
        Global.add(Global.confirmdRef, {
            users: [randUser, snapshotUser],
            timer: timer,
            channel: channelNum,
        }).then(async (key) => {
            console.log(key?.toString());
            if (key == null)
                return;

            Global.delay(function () {

                Global.delete(Global.confirmdRef, key);
                Global.updateRef(Global.channeCountRef, false);
                Global.updateRef(Global.matchCountRef, true);

            }, timer);

        })

    }

}



