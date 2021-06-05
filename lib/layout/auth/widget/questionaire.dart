import 'package:auto_size_text/auto_size_text.dart';
import 'package:buddy/V2/other/sizeConfig.dart';
import 'package:buddy/global/global.dart';
import 'package:buddy/global/widgets/static/global_box_container.dart';
import 'package:buddy/global/widgets/static/global_snack_bar.dart';
import 'package:buddy/layout/auth/controller/questionaire_bloc.dart';
import 'package:buddy/layout/auth/view/preferences_view.dart';
import 'package:buddy/layout/nav_page/view_spner_chld_nav.dart';
import 'package:buddy/layout/nav_page/wait_searc_cht_nav.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class Questionaire extends StatefulWidget {
  final int pageNum;
  Questionaire(this.pageNum, {key}) : super(key: ValueKey<int>(pageNum));

  @override
  _QuestionaireState createState() => _QuestionaireState();
}

class _QuestionaireState extends State<Questionaire>
    with TickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;
  QuestionaireBloc bloc = Get.find<QuestionaireBloc>();
  // List<String> list = new List();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return GetBuilder<QuestionaireBloc>(initState: (_) {
      controller = AnimationController(
          duration: const Duration(milliseconds: 1000), vsync: this);
      animation = CurvedAnimation(parent: controller, curve: Curves.easeIn);
      controller.forward();
      Get.find<QuestionaireBloc>().selectedOption = -1;
    }, builder: (QuestionaireBloc bloc) {
      return _questionare(bloc, widget.pageNum);
    });
  }

  Widget _questionare(QuestionaireBloc bloc, int index) {
    return Container(
      padding: EdgeInsets.only(bottom: 0.05.sh),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: ScreenUtil.defaultSize.width,
            padding: EdgeInsets.only(left: 0.03.sw),
            child: AutoSizeText(
              bloc.questionaire[index]["title"],
              maxLines: 1,
              style: Global.appTheme.fonts.segoeUi.headline3,
            ),
          ),
          SizedBox(height: 0.03.sh),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(4, (i) {
                if (i == 0) {
                  return _progressSides(
                    color: widget.pageNum > i ? Colors.blue[200] : Colors.white,
                    child: widget.pageNum != i
                        ? Container()
                        : FadeTransition(
                            opacity: animation,
                            child: _progressSides(color: Colors.blue[200])),
                  );
                } else if (i == 3) {
                  return _progressSides(
                    color: widget.pageNum > i ? Colors.blue[200] : Colors.white,
                    end: true,
                    child: widget.pageNum != i
                        ? Container()
                        : FadeTransition(
                            opacity: animation,
                            child: _progressSides(color: Colors.blue[200])),
                  );
                } else {
                  return _progressMiddle(
                    color: widget.pageNum > i ? Colors.blue[200] : Colors.white,
                    child: widget.pageNum != i
                        ? Container()
                        : FadeTransition(
                            opacity: animation,
                            child: _progressMiddle(color: Colors.blue[200])),
                  );
                }
              })),
          SizedBox(height: 0.09.sh),
          Padding(
              padding: EdgeInsets.only(left: 0.04.sw),
              child: Column(
                children: [
                  Text(bloc.questionaire[index]["question"],
                      style: Global.appTheme.fonts.nexa.headline6),
                ],
              )),
          SizedBox(height: 0.02.sh),
          new Expanded(
            child: ListView.builder(
              itemCount: bloc.questionaire[index]["options"].length,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext _, int i) {
                return userCard(
                    bloc, bloc.questionaire[index]["options"][i], i, context);
              },
            ),
          ),
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  side: BorderSide(color: Colors.grey)),
              child: GlobalBoxContainer(
                  containerWidth: 0.65.sw,
                  borderRadius: BorderRadius.circular(40.sp),
                  boxShadow: BoxShadow(color: Colors.transparent),
                  containerColor: widget.pageNum < 3 ? Color(0xFF8CB2FC) : null,
                  gradient: widget.pageNum < 3
                      ? null
                      : LinearGradient(
                          colors: <Color>[Color(0xFFDDC3EC), Color(0xFFB9D1FF)],
                        ),
                  child: Center(
                    child: AutoSizeText(
                        widget.pageNum < 3 ? "Next" : "Complete",
                        style: Global.appTheme.fonts.segoeUi.headline5),
                  ),
                  padding: EdgeInsets.all(15.sp)),
              onPressed: () {
                if (bloc.selectedOption == -1) {
                  GlobalSnackBar("Please select an answer");
                  return;
                }
                bloc.appendAns(widget.pageNum);
                if (widget.pageNum >= 3) {
                  Get.offAll(
                    ViewSpnerChldNav(
                      isReady: true,
                      unRelatedView: true,
                      child: WaitSearChtNav(),
                    ),
                  );
                } else {
                  Get.find<PrevNav>().nextPage();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

Widget _progressMiddle({Color color = Colors.white, Widget child}) {
  return Container(
    width: SizeConfig.blockSizeHorizontal * 20,
    height: SizeConfig.blockSizeVertical * 1,
    decoration: BoxDecoration(
      border: Border.all(
          color: Colors.grey, width: SizeConfig.blockSizeHorizontal * .25),
      color: color,
    ),
    child: child ?? Container(),
  );
}

Widget _progressSides(
    {Color color = Colors.white, bool end = false, Widget child}) {
  return Container(
    width: SizeConfig.blockSizeHorizontal * 20,
    height: SizeConfig.blockSizeVertical * 1,
    decoration: BoxDecoration(
      border: Border.all(
          color: Colors.grey, width: SizeConfig.blockSizeHorizontal * .25),
      borderRadius: end
          ? BorderRadius.only(
              topRight: Radius.circular(SizeConfig.blockSizeHorizontal * 2),
              bottomRight: Radius.circular(SizeConfig.blockSizeHorizontal * 2))
          : new BorderRadius.only(
              topLeft: Radius.circular(SizeConfig.blockSizeHorizontal * 2),
              bottomLeft: Radius.circular(SizeConfig.blockSizeHorizontal * 2)),
      color: color,
    ),
    child: child ?? Container(),
  );
}

Color _selectedIndexColor(QuestionaireBloc bloc, int index) {
  return bloc.selectedOption != -1 && bloc.selectedOption == index
      ? Color(0xFFB9D1FF)
      : Color(0xFFF8FAFF);
}

Widget userCard(
    QuestionaireBloc bloc, var obj, int index, BuildContext context) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 0.008.sh, horizontal: 0.05.sw),
    child: InkWell(
      child: Card(
        color: _selectedIndexColor(bloc, index),
        shadowColor: _selectedIndexColor(bloc, index),
        elevation: 1.5,
        child: GlobalBoxContainer(
          containerHeight: 0.08.sh,
          containerColor: _selectedIndexColor(bloc, index),
          borderRadius: BorderRadius.circular(10.sp),
          boxShadow: BoxShadow(
              color: Color(0xFFB9D1FF), blurRadius: 0.01.sh, spreadRadius: -3),
          child: Center(
              child: Row(
            children: [
              SizedBox(width: 0.05.sw),
              Expanded(
                child: new AutoSizeText(obj,
                    maxLines: 2,
                    style: Global.appTheme.fonts.segoeUi.headline6.copyWith(
                        color: Colors.black, fontWeight: FontWeight.w600)),
              ),
            ],
          )),
        ),
      ),
      onTap: () {
        bloc.updateSelection(index);
        //  setState(() => _onSelected(index));
        print(obj);
        // getAnswer01(obj);
      },
    ),
  );
}
