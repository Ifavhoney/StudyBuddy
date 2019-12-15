import 'package:flutter/material.dart';

/*Full Screen SnackBar  W/ Mixture of Icon + FlatBtutton + Plain Text*/
class FullScreenSnackBar extends StatelessWidget {
  final IconData icon;
  final String flatButtonText;
  final String genericText;
  final Function function;

  FullScreenSnackBar(
      {this.icon, this.flatButtonText, this.genericText, this.function});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          /*Consider making it clickable to mail */
          Icon(
            icon,
            size: 100,
            color: Colors.white,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                genericText,
                style: Theme.of(context).textTheme.display1,
              ),
              FlatButton(
                  child: Text(
                    flatButtonText != null ? flatButtonText : "",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onPressed: function)
            ],
          )
        ],
      ),
    );
  }
}
