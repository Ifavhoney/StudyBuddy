
class SearchRefs {
    readonly ref: string = "Home/Search/";
    readonly awaitingRefStr: string = this.ref + "Awaiting/" + "2020-08-14/";
    readonly confirmedRefStr: string = this.ref + "Confirmed/" + "2020-08-14/";


    readonly friendReqRefStr: string = this.ref + "friendRequest/" + "2020-08-14/";
    readonly chatRefStr: string = "Chat/Search/" + "2020-08-14/";


    readonly channelCountRefStr: string = this.ref + "Count/Channel/" + "2020-08-14/";
    readonly awaitingCountRefStr: string = this.ref + "Count/Awaiting/" + "2020-08-14/";
    readonly matchCountRefStr: string = this.ref + "Count/Match/" + "2020-08-14/";



}

export default new SearchRefs();