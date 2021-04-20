
import Keys from './keys';
import searchRefs from './refs/search_refs';
import firebase from "firebase/app";
require("firebase/auth");
require("firebase/storage");
require("firebase/database");



class Global {

    private _config: Record<string, string>;
    private static _instance: Global;

    //Search Refs
    private _awaitingRef: firebase.database.Reference;
    private _confirmdRef: firebase.database.Reference;
    private _channeCountRef: firebase.database.Reference;
    private _awaitingCountRef: firebase.database.Reference;


    get config(): Record<string, string> { return this._config }
    get awaitingRef(): firebase.database.Reference { return this._awaitingRef }
    get confirmdRef(): firebase.database.Reference { return this._confirmdRef }
    get channeCountRef(): firebase.database.Reference { return this._channeCountRef }
    get awaitingCountRef(): firebase.database.Reference { return this._awaitingCountRef }


    //Constructor that initializes Config, and default refs
    constructor() {
        this._config = {
            apiKey: Keys.APIKEY,
            authDomain: Keys.AUTHDOMAIN,
            databaseURL: Keys.DATABASEURL,
            projectId: Keys.PROJECTID,
            storageBucket: Keys.STORAGEBUCKET,
            messagingSenderId: Keys.MESSAGINGSENDERID,
            appId: Keys.APPID
        };
        let database = firebase.initializeApp(this._config).database()

        this._awaitingRef = database.ref(searchRefs.awaitingRefStr);
        this._confirmdRef = database.ref(searchRefs.confirmedRefStr);
        this._channeCountRef = database.ref(searchRefs.channelCountRefStr);
        this._awaitingCountRef = database.ref(searchRefs.awaitingCountRefStr);

    }

    public static get Instance() {
        // Do you need arguments? Make it a regular static method instead.
        return this._instance || (this._instance = new this());
    }

    public async add(ref: firebase.database.Reference, value: any): Promise<string | null> {
        let key: string | null = await ref.push().key ?? "";

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


    public async delay(r: Function, m: number): Promise<void> {
        await setTimeout(r(), 60000 * m);
    }


}


export default Global.Instance

