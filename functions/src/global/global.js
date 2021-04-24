"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
var __generator = (this && this.__generator) || function (thisArg, body) {
    var _ = { label: 0, sent: function() { if (t[0] & 1) throw t[1]; return t[1]; }, trys: [], ops: [] }, f, y, t, g;
    return g = { next: verb(0), "throw": verb(1), "return": verb(2) }, typeof Symbol === "function" && (g[Symbol.iterator] = function() { return this; }), g;
    function verb(n) { return function (v) { return step([n, v]); }; }
    function step(op) {
        if (f) throw new TypeError("Generator is already executing.");
        while (_) try {
            if (f = 1, y && (t = op[0] & 2 ? y["return"] : op[0] ? y["throw"] || ((t = y["return"]) && t.call(y), 0) : y.next) && !(t = t.call(y, op[1])).done) return t;
            if (y = 0, t) op = [op[0] & 2, t.value];
            switch (op[0]) {
                case 0: case 1: t = op; break;
                case 4: _.label++; return { value: op[1], done: false };
                case 5: _.label++; y = op[1]; op = [0]; continue;
                case 7: op = _.ops.pop(); _.trys.pop(); continue;
                default:
                    if (!(t = _.trys, t = t.length > 0 && t[t.length - 1]) && (op[0] === 6 || op[0] === 2)) { _ = 0; continue; }
                    if (op[0] === 3 && (!t || (op[1] > t[0] && op[1] < t[3]))) { _.label = op[1]; break; }
                    if (op[0] === 6 && _.label < t[1]) { _.label = t[1]; t = op; break; }
                    if (t && _.label < t[2]) { _.label = t[2]; _.ops.push(op); break; }
                    if (t[2]) _.ops.pop();
                    _.trys.pop(); continue;
            }
            op = body.call(thisArg, _);
        } catch (e) { op = [6, e]; y = 0; } finally { f = t = 0; }
        if (op[0] & 5) throw op[1]; return { value: op[0] ? op[1] : void 0, done: true };
    }
};
exports.__esModule = true;
var keys_1 = require("./keys");
var search_refs_1 = require("./refs/search_refs");
var app_1 = require("firebase/app");
require("firebase/auth");
require("firebase/storage");
require("firebase/database");
var Global = /** @class */ (function () {
    //Constructor that initializes Config, and default refs
    function Global() {
        this._config = {
            apiKey: keys_1["default"].APIKEY,
            authDomain: keys_1["default"].AUTHDOMAIN,
            databaseURL: keys_1["default"].DATABASEURL,
            projectId: keys_1["default"].PROJECTID,
            storageBucket: keys_1["default"].STORAGEBUCKET,
            messagingSenderId: keys_1["default"].MESSAGINGSENDERID,
            appId: keys_1["default"].APPID
        };
        var database = app_1["default"].initializeApp(this._config).database();
        this._awaitingRef = database.ref(search_refs_1["default"].awaitingRefStr);
        this._confirmdRef = database.ref(search_refs_1["default"].confirmedRefStr);
        this._channeCountRef = database.ref(search_refs_1["default"].channelCountRefStr);
        this._awaitingCountRef = database.ref(search_refs_1["default"].awaitingCountRefStr);
        this._matchCountRef = database.ref(search_refs_1["default"].matchCountRefStr);
    }
    Object.defineProperty(Global.prototype, "config", {
        get: function () { return this._config; },
        enumerable: false,
        configurable: true
    });
    Object.defineProperty(Global.prototype, "awaitingRef", {
        get: function () { return this._awaitingRef; },
        enumerable: false,
        configurable: true
    });
    Object.defineProperty(Global.prototype, "confirmdRef", {
        get: function () { return this._confirmdRef; },
        enumerable: false,
        configurable: true
    });
    Object.defineProperty(Global.prototype, "channeCountRef", {
        get: function () { return this._channeCountRef; },
        enumerable: false,
        configurable: true
    });
    Object.defineProperty(Global.prototype, "awaitingCountRef", {
        get: function () { return this._awaitingCountRef; },
        enumerable: false,
        configurable: true
    });
    Object.defineProperty(Global.prototype, "matchCountRef", {
        get: function () { return this._matchCountRef; },
        enumerable: false,
        configurable: true
    });
    Object.defineProperty(Global, "Instance", {
        get: function () {
            // Do you need arguments? Make it a regular static method instead.
            return this._instance || (this._instance = new this());
        },
        enumerable: false,
        configurable: true
    });
    Global.prototype.add = function (ref, value) {
        var _a;
        return __awaiter(this, void 0, void 0, function () {
            var key;
            return __generator(this, function (_b) {
                switch (_b.label) {
                    case 0: return [4 /*yield*/, ref.push().key];
                    case 1:
                        key = (_a = _b.sent()) !== null && _a !== void 0 ? _a : "";
                        return [4 /*yield*/, ref.child(key).set(value)];
                    case 2:
                        _b.sent();
                        console.log(key);
                        return [2 /*return*/, key];
                }
            });
        });
    };
    ;
    Global.prototype["delete"] = function (ref, key) {
        ref.child(key).remove();
        return key;
    };
    Global.prototype.updateRef = function (ref, increment) {
        if (increment === void 0) { increment = true; }
        return __awaiter(this, void 0, void 0, function () {
            var num;
            return __generator(this, function (_a) {
                switch (_a.label) {
                    case 0:
                        num = 1;
                        return [4 /*yield*/, ref.transaction(function (post) {
                                if (post == null) {
                                    return { "id": num };
                                }
                                else {
                                    if (increment)
                                        num = post.id + 1;
                                    else
                                        num = post.id - 1;
                                    return { "id": num };
                                }
                            })];
                    case 1:
                        _a.sent();
                        return [2 /*return*/, num];
                }
            });
        });
    };
    Global.prototype.findKeyByEmail = function (ref, user) {
        return __awaiter(this, void 0, void 0, function () {
            var key;
            return __generator(this, function (_a) {
                switch (_a.label) {
                    case 0:
                        key = "";
                        return [4 /*yield*/, ref.get().then((function (snapshot) {
                                if (snapshot.exists()) {
                                    snapshot.forEach(function (snapshot) {
                                        var childData = snapshot.val();
                                        if (user == childData["user"]) {
                                            key = (snapshot.key);
                                        }
                                    });
                                }
                            }))];
                    case 1:
                        _a.sent();
                        if (key == "")
                            console.log("user: " + user + " does not exist");
                        return [2 /*return*/, key];
                }
            });
        });
    };
    Global.prototype.findRandomUser = function (ref) {
        return __awaiter(this, void 0, void 0, function () {
            var user;
            return __generator(this, function (_a) {
                switch (_a.label) {
                    case 0:
                        user = {};
                        return [4 /*yield*/, ref.limitToFirst(1).get().then((function (snapshot) {
                                return __awaiter(this, void 0, void 0, function () {
                                    return __generator(this, function (_a) {
                                        snapshot.forEach(function (snapshot) {
                                            user = {
                                                email: snapshot.val()["user"],
                                                key: (snapshot.key)
                                            };
                                        });
                                        return [2 /*return*/];
                                    });
                                });
                            }))];
                    case 1:
                        _a.sent();
                        return [2 /*return*/, user];
                }
            });
        });
    };
    Global.prototype.delay = function (r, m) {
        return __awaiter(this, void 0, void 0, function () {
            return __generator(this, function (_a) {
                switch (_a.label) {
                    case 0: return [4 /*yield*/, setTimeout(r(), 60000 * m)];
                    case 1:
                        _a.sent();
                        return [2 /*return*/];
                }
            });
        });
    };
    return Global;
}());
exports["default"] = Global.Instance;
