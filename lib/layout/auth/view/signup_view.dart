import 'package:animations/animations.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:buddy/V2/other/sizeConfig.dart';
import 'package:buddy/global/config/device_config.dart';
import 'package:buddy/global/global.dart';
import 'package:buddy/global/helper/upload_helper.dart';
import 'package:buddy/global/widgets/animation/spinner/global_spinner.dart';
import 'package:buddy/global/widgets/static/global_app_bar.dart';
import 'package:buddy/global/widgets/static/global_box_container.dart';
import 'package:buddy/global/widgets/static/global_snack_bar.dart';
import 'package:buddy/layout/auth/controller/auth_controller.dart';
import 'package:buddy/layout/auth/widget/copywriting_popup.dart';
import 'package:buddy/layout/nav_page/spner_chld_nav.dart';
import 'package:country_pickers/country.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:country_pickers/country_pickers.dart';

class SignupView extends StatefulWidget {
  static const String routeName = "/signup_view";

  @override
  _SignupViewState createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final _formKey = GlobalKey<FormState>();
  final databaseReference = FirebaseFirestore.instance;
  final TextStyle headline6 = Global.appTheme.fonts.segoeUi.headline6;
  List<String> list = new List();
  TextEditingController fullName = TextEditingController();
  TextEditingController email = TextEditingController();

  bool _isChecked = false;
  String image =
      "https://firebasestorage.googleapis.com/v0/b/studybuddy-a39ca.appspot.com/o/mascot.png?alt=media&token=a5f866a4-7a46-46b4-8044-a8e558fe08f5";
  String country = CountryPickerUtils.getCountryByIsoCode('US').name;
  bool isReady = false;
  void createUser() async {
    databaseReference.collection("Users").doc(email.text).set({
      'fullName': fullName.text,
      "country": country,
      "avatar": image,
      "questionaire": {},
      "patform": Get.find<DeviceConfig>().isIos ? "IOS" : "Android",
      "AuthType": Get.parameters["authType"],
      "completedProfile": false
    });
  }

  @override
  void initState() {
    super.initState();
    asyncInitState();
  }

  asyncInitState() async {
    User user = await AuthController().getCurrentUser();
    email.text = user?.email;
    if (user?.photoURL != null) image = user.photoURL;
    isReady = true;

    GlobalSnackBar("I applied Auto-fill, feel free to modify!", seconds: 6);
    setState(() {});
  }

  void nextPage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('userInfo', list);
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return !isReady
        ? GlobalSpinner()
        : Scaffold(
            key: _scaffoldKey,
            resizeToAvoidBottomInset: false,
            appBar: GlobalAppBar(implyLeading: false, toolbarHeight: 0.03.sh),
            body: Container(
              height: SizeConfig.screenHeight,
              width: SizeConfig.screenWidth,
              padding: EdgeInsets.fromLTRB(0, 0.0.sh, 0, 0.07.sh),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _avatar(),

                  SizedBox(height: SizeConfig.safeBlockVertical * 9),
                  //FORM SECTION
                  Form(
                    key: _formKey,
                    child: Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          _formFields(),
                          SizedBox(height: SizeConfig.safeBlockVertical * 10),
                          _checked(),
                          Expanded(child: Container()),
                          _signUpBtn(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  Widget _signUpBtn() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(side: BorderSide(color: Colors.grey)),
      child: Container(
          width: 0.5.sw,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: <Color>[
                Color(0xFFDDC3EC),
                Color(0xFFB9D1FF),
              ],
            ),
            borderRadius: BorderRadius.circular(40.sp),
          ),
          child: Center(
            child: AutoSizeText("Sign up",
                style: Global.appTheme.fonts.segoeUi.headline5),
          ),
          padding: EdgeInsets.all(15.sp)),
      onPressed: () {
        _formKey.currentState.save();

        if (fullName.text.length > 0 &&
            email.text.length > 0 &&
            isValidEmail(email.text)) {
          if (_isChecked)
            createUser();
          else
            GlobalSnackBar("Please accept the terms & Conditions");
        }
      },
    );
  }

  Widget _checked() {
    return Container(
        padding: EdgeInsets.only(left: 0.06.sw),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            !_isChecked
                ? AutoSizeText(
                    '*  ',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize:
                          Global.appTheme.fonts.segoeUi.subtitle2.fontSize,
                    ),
                  )
                : Container(),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    child: AutoSizeText('I accept all the terms & conditions',
                        maxLines: 1,
                        style: TextStyle(
                          fontSize:
                              Global.appTheme.fonts.segoeUi.subtitle1.fontSize,
                          decoration: TextDecoration.underline,
                          color: Color(0xFF79A2FB),
                        )),
                    onTap: () async {
                      showModal(
                          context: (context),
                          configuration: FadeScaleTransitionConfiguration(
                              barrierDismissible: true,
                              reverseTransitionDuration:
                                  Duration(milliseconds: 10),
                              transitionDuration:
                                  Duration(microseconds: 100000)),
                          builder: (context) {
                            return CopyWritingPopup();
                          });
                    },
                  ),
                ],
              ),
            ),
            Transform.scale(
              scale: 0.8,
              child: Checkbox(
                value: _isChecked,
                onChanged: (val) {
                  setState(() {
                    _isChecked = val;
                  });
                },
              ),
            )
          ],
        ));
  }

  Widget _avatar() {
    return Stack(
      children: [
        GlobalBoxContainer(
          boxShape: BoxShape.circle,
          boxShadow: BoxShadow(
              color: Color(0xFF707070), blurRadius: 10, spreadRadius: -3),
          child: CircularProfileAvatar(image,
              errorWidget: (context, url, error) =>
                  Container(child: Icon(Icons.error)),
              placeHolder: (context, url) => Container(
                  width: 50, height: 50, child: CircularProgressIndicator()),
              radius: 0.09.sh,
              backgroundColor: Colors.transparent,
              elevation: 0,
              onTap: () async {
                UploadHelper helper = await UploadHelper.getImageUrl();
                image = helper.downloadLink;
                setState(() {});
                Logger().e(image);
              },
              cacheImage: true,
              showInitialTextAbovePicture: false),
        ),
        Positioned.fill(
          bottom: 0.01.sh,
          child: Align(
            alignment: Alignment.bottomRight,
            child: Icon(
              FontAwesomeIcons.fileUpload,
              size: 0.03.sh,
              color: Global.appTheme.iconColors.signupView["upload"],
            ),
          ),
        )
      ],
    );
  }

  Widget _formFields() {
    return Column(
      children: [
        _container(
            child: TextFormField(
          style: Global.appTheme.fonts.segoeUi.headline6,
          controller: email,
          readOnly: true,
          keyboardType: TextInputType.emailAddress,
          decoration: mainInputDec("Email Address", readOnly: true),
          onSaved: (String value) {
            print("submit");
            if (value.isEmpty) {
              GlobalSnackBar("Email Cannot be empty");
            } else if (!isValidEmail(value.trim())) {
              GlobalSnackBar("Invalid Email");
            } else {}
            return null;
          },
        )),

        SizedBox(height: SizeConfig.safeBlockVertical * 5),
        _container(
          child: TextFormField(
            controller: fullName,
            style: Global.appTheme.fonts.segoeUi.headline6,
            keyboardType: TextInputType.text,
            decoration: mainInputDec("Full Name"),
            onSaved: (String value) {
              if (value.isEmpty) {
                GlobalSnackBar("Full Name Cannot be empty");
              }
              return null;
            },
          ),
        ),
        SizedBox(height: SizeConfig.safeBlockVertical * 5),

        //Language
        //Age range
        //Gender

        _container(
            child: TextFormField(
          style: Global.appTheme.fonts.segoeUi.headline6,
          onTap: () {
            _openCupertinoCountryPicker();
          },
          keyboardType: TextInputType.text,
          readOnly: true,
          decoration: mainInputDec("Country: " + country),
        )),
      ],
    );
  }

/*


*/
  void _openCupertinoCountryPicker() => showDialog(
        context: context,
        builder: (context) => Theme(
          data: Theme.of(context).copyWith(primaryColor: Colors.pink),
          child: CountryPickerDialog(
            titlePadding: EdgeInsets.all(8.0),
            searchCursorColor: Colors.pinkAccent,
            searchInputDecoration: InputDecoration(hintText: 'Search...'),
            isSearchable: true,
            onValuePicked: (Country country) =>
                setState(() => this.country = country.name),
            itemBuilder: _buildDialogItem,
            priorityList: [
              CountryPickerUtils.getCountryByIsoCode('US'),
              CountryPickerUtils.getCountryByIsoCode('CA'),
            ],
          ),
        ),
      );

  Widget _buildDialogItem(Country country) => Row(
        children: <Widget>[
          CountryPickerUtils.getDefaultFlagImage(country),
          SizedBox(width: 8.0),
          SizedBox(width: 8.0),
          Flexible(
              child: AutoSizeText(country.name,
                  style: Global.appTheme.fonts.segoeUi.subtitle1))
        ],
      );

  InputDecoration mainInputDec(String text, {bool readOnly = false}) {
    return InputDecoration(
        errorStyle: TextStyle(color: Colors.transparent, fontSize: 0),
        focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 0, color: Colors.transparent)),
        errorBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 0, color: Colors.transparent)),
        fillColor: !readOnly ? Colors.white : Color(0xFFDDC3EC),
        filled: true,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(
              Radius.circular(SizeConfig.blockSizeVertical * 5.5)),
          borderSide: BorderSide(
            width: 0.6,
            color: Color(0xFF707070),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(
              Radius.circular(SizeConfig.blockSizeVertical * 5.5)),
          borderSide: BorderSide(
            width: 0.6,
            color: Colors.white,
          ),
        ),
        contentPadding:
            EdgeInsets.only(top: 0, left: SizeConfig.safeBlockHorizontal * 6),
        hintText: text);
  }

  Widget _container({Widget child, double width}) {
    return GlobalBoxContainer(
        containerHeight: SizeConfig.blockSizeVertical * 5,
        containerWidth: width ?? SizeConfig.blockSizeHorizontal * 75,
        borderRadius: BorderRadius.all(
          Radius.circular(SizeConfig.blockSizeVertical * 3.5),
        ), //858585
        boxShadow: BoxShadow(
            color: Color(0xFF858585), blurRadius: 10, spreadRadius: -6),
        child: child);
  }

  bool isValidEmail(String input) {
    final RegExp regex = new RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
    return regex.hasMatch(input);
  }
}
