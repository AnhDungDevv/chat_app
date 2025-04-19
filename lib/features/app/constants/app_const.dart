import 'package:chat_application/features/app/theme/style.s.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:giphy_picker/giphy_picker.dart';

void toast(String message) {
  Fluttertoast.showToast(
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 2,
    backgroundColor: tabColor,
    textColor: whiteColor,
    fontSize: 16.0,
    msg: message,
  );
}

Future<GiphyGif?> pickGIF(BuildContext context) async {
  GiphyGif? gif;
  try {
    gif = await GiphyPicker.pickGif(
      context: context,
      apiKey: 'WFtzJBfLtFMg9yBwaIgjQyopgferEP9A',
    );
  } catch (e) {
    toast(e.toString());
  }
  return gif;
}
