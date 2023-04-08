import 'package:fcr_calculator/utils/gettersetter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
            height: 320,
            child: LayoutBuilder(
              builder: (_, constraints) => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      margin: EdgeInsets.only(bottom: 20),
                      height: constraints.maxHeight * 0.5,
                      child: SvgPicture.asset('assets/images/error.svg')),
                  Column(
                    children: [
                      Text('ERROR!',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.red)),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        message,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ],
              ),
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
            height: 320,
            child: LayoutBuilder(
              builder: (_, constraints) => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 20),
                    height: constraints.maxHeight * 0.5,
                    child: Image.asset('assets/images/success.png'),
                  ),
                  Column(
                    children: [
                      Text(
                        'SUCCESS!',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.green),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(message,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                          textAlign: TextAlign.center),
                    ],
                  ),
                ],
              ),
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
            height: 320,
            child: LayoutBuilder(
              builder: (_, constraints) => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 20),
                    height: constraints.maxHeight * 0.5,
                    child: SvgPicture.asset(
                        'assets/images/delete_confirmation.svg'),
                  ),
                  Column(
                    children: [
                      Text('CONFIRMATION!',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.red)),
                      SizedBox(
                        height: 5,
                      ),
                      Text(message,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                          textAlign: TextAlign.center),
                    ],
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
          ),
        );
      });
}

void showLoader(BuildContext context) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) => Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            alignment: Alignment.center,
            child: Container(
                width: 50,
                height: 100,
                child: Center(child: CircularProgressIndicator())),
          ));
}
