import 'package:flutter/material.dart';

class MessageItem extends StatelessWidget {
  final String message;
  final bool isQuestion;

  MessageItem(this.message, this.isQuestion);

  @override
  Widget build(BuildContext context) {
    return Row(
      textDirection: isQuestion ? TextDirection.rtl : TextDirection.ltr,
      children: [
        Container(
          decoration: BoxDecoration(
            color: isQuestion ? Theme.of(context).primaryColor : Colors.grey,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
                bottomRight:
                    isQuestion ? Radius.circular(0) : Radius.circular(12),
                bottomLeft:
                    isQuestion ? Radius.circular(12) : Radius.circular(0)),
          ),
          width: 150,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Text(
            message,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
