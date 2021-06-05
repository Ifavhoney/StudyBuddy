import 'package:buddy/global/config/user_config.dart';
import 'package:buddy/global/global.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class QuestionaireBloc extends GetxController {
  Map<String, dynamic> ans = {};
  int selectedOption = (-1);
  String email = "";
  Map<int, dynamic> questionaire = {
    0: {
      "title": "Intentions",
      "question": "I am mostly looking to ...",
      "options": [
        'Make new Friends',
        'Connect with Current Friends',
        'Talk to random people',
        "N/A"
      ]
    },
    1: {
      "title": "My Mood",
      "question": "Right now I feel ...",
      "options": ['Bored', 'Meh', 'Super happy', 'N/A']
    },
    2: {
      "title": "Political Interests",
      "question": "My party of choice ...",
      "options": ['Democrat', 'Republican', 'Libertarian', "N/A"]
    },
    3: {
      "title": "Hobbies",
      "question": "On a friday night, I would be ... ",
      "options": ['Alone', 'Gaming', 'Entertained', "N/A"]
    },
  };

  updateSelection(int option) {
    selectedOption = option;
    update();
  }

  void appendAns(int questionNum) {
    print("email is " + email);
    print("selectedOption is " + selectedOption.toString());
    ans[questionNum.toString()] = {
      "title": questionaire[questionNum]["title"],
      "question": questionaire[questionNum]["question"],
      "ans": questionaire[questionNum]["options"][selectedOption]
    };
    if (questionNum >= 3) {
      FirebaseFirestore.instance
          .collection("Users")
          .doc(email)
          .update({"questionaire": ans, "completedProfile": true});

      Get.find<UserConfig>().init();
      print("inited");
      print(Global.email.toString());
    }

    selectedOption = -1;

    update();
  }
}
