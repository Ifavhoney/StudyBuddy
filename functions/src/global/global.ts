
import searchRefs from './refs/search_refs';
import firebase from "firebase/app";
require("firebase/auth");
require("firebase/storage");
require("firebase/database");


class Global {

    get awaitingRef(): firebase.database.Reference { return firebase.database().ref(searchRefs.awaitingRefStr); }
    get confirmdRef(): firebase.database.Reference { return firebase.database().ref(searchRefs.confirmedRefStr) }
    get friendReqRef(): firebase.database.Reference { return firebase.database().ref(searchRefs.friendReqRefStr) }
    get chatRef(): firebase.database.Reference { return firebase.database().ref(searchRefs.chatRefStr) }
    get channeCountRef(): firebase.database.Reference { return firebase.database().ref(searchRefs.channelCountRefStr); }
    get awaitingCountRef(): firebase.database.Reference { return firebase.database().ref(searchRefs.awaitingCountRefStr); }
    get matchCountRef(): firebase.database.Reference { return firebase.database().ref(searchRefs.matchCountRefStr); }

    public async add(ref: firebase.database.Reference, value: any, ownKey?: string): Promise<string | null> {
        let key: string | null = ownKey ?? await ref.push().key ?? "";

        await ref.child(key).set(value);
        console.log(key);
        return key;
    };
    public delete(ref: firebase.database.Reference, key: string) {
        ref.child(key).remove();
        return key;
    }


    public async updateRef(ref: firebase.database.Reference, increment = true): Promise<number> {
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

                return { "id": num }
            }

        })

        return num

    }


    public async findKeyByEmail(ref: firebase.database.Reference, user: string): Promise<string> {
        let key: string = "";
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
    public async findRandomUser(ref: firebase.database.Reference): Promise<Record<string, string>> {
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

    public async delay(r: Function, ms: number): Promise<void> {
        await setTimeout((() => { r() }), ms);
    }

}

export default new Global();

