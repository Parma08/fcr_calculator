import 'package:flutter/material.dart';

double getFontSize(BuildContext context, double factor) {
  final mediaQuery = MediaQuery.of(context);
  final textScaleFactor = mediaQuery.textScaleFactor;
  final screenWidth = mediaQuery.size.width;
  final screenHeight = mediaQuery.size.height;
  final smallestDimension =
      screenWidth > screenHeight ? screenHeight : screenWidth;
  final fontSize = smallestDimension * 0.035 * textScaleFactor * factor;

  return fontSize;
}

void showErrorDialog(BuildContext context, String message) {
  showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          alignment: Alignment.center,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            height: 150,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: Icon(
                    Icons.error,
                    size: 50,
                    color: Colors.red,
                  ),
                ),
                Text(
                  message,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        );
      });
}

void showSuccessDialog(BuildContext context, String message) {
  showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          alignment: Alignment.center,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            height: 150,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: Icon(
                    Icons.thumb_up_alt,
                    size: 50,
                    color: Colors.greenAccent,
                  ),
                ),
                Text(
                  message,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        );
      });
}

Future showDeleteConfirmationModal(BuildContext context, String message) {
  return showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          alignment: Alignment.center,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: Icon(
                    Icons.delete_forever_outlined,
                    size: 50,
                    color: Colors.red,
                  ),
                ),
                Text(
                  message,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop('cancel');
                        },
                        child: Text('Cancel')),
                    TextButton(
                        onPressed: () async {
                          Navigator.of(context).pop('delete');
                        },
                        child: Text('Delete'))
                  ],
                )
              ],
            ),
          ),
        );
      });
}
