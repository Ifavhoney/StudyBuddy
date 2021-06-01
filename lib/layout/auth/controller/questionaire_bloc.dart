//Get contrroller to change the index?
import 'package:get/get.dart';

class QuestionaireBloc extends GetxController {
  Map<int, dynamic> ans = {};
  int selectedOption = (-1);

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
    ans[questionNum] = {
      "title": questionaire[questionNum]["title"],
      "question": questionaire[questionNum]["question"],
      "ans": questionaire[questionNum][selectedOption]
    };
    selectedOption = -1;

    update();
  }
}
