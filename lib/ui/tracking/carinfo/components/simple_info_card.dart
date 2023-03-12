import 'package:flutter/material.dart';

class SimpleInfoCard extends StatelessWidget {
  String primaryText;
  String secondaryText;

  SimpleInfoCard({
    Key? key,
    required this.primaryText,
    required this.secondaryText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return Container(
        padding: const EdgeInsets.only(left: 12, top: 16),
        decoration: const BoxDecoration(color: Colors.white),
        width: double.infinity,
        child: Container(
          padding: const EdgeInsets.only(bottom: 16, right: 22),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                primaryText,
                style: TextStyle(
                    height: 1.2,
                    color: Colors.grey.shade700,
                    fontSize: 19,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Kanit'),
              ),
              SizedBox(
                width: mediaQuery.size.width / 2.5,
                child: Text(
                  secondaryText,
                  style: TextStyle(
                      height: 1.2,
                      color: Colors.grey.shade500,
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Kanit'),
                  textAlign: TextAlign.right,
                ),
              )
            ],
          ),
        ));
  }
}
