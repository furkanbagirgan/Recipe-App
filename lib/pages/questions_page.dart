import 'package:flutter/material.dart';

import '../widgets/message_item.dart';

class QuestionsPage extends StatefulWidget {
  static const String routeName = "/questions";

  @override
  _QuestionsPageState createState() => _QuestionsPageState();
}

class _QuestionsPageState extends State<QuestionsPage> {
  List<Map<String, dynamic>> _messages = [];

  void _addMessage(String question, int index, String answer) {
    setState(() {
      _messages.add({"message": question, "isQuestion": true});
    });
    Future.delayed(const Duration(milliseconds: 2000), () {
      setState(() {
        _messages.add({"message": answer, "isQuestion": false});
      });
    });
  }

  Widget _buildRaisedButton(String question, int index, String answer) {
    return RaisedButton(
      padding: EdgeInsets.all(5),
      onPressed: () => _addMessage(question, index, answer),
      color: Theme.of(context).accentColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: Text(
        question,
        style: TextStyle(color: Colors.white, fontSize: 16),
        textAlign: TextAlign.center,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> meal =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    return Scaffold(
      appBar: AppBar(
        title: Text("Soru Sor"),
      ),
      body: Column(
        children: [
          Container(
            height: 504,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: ListView.builder(
                reverse: true,
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  return MessageItem(
                      _messages[_messages.length - index - 1]["message"],
                      _messages[_messages.length - index - 1]["isQuestion"]);
                }),
          ),
          Container(
            color: Colors.black12,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            height: 190,
            child: SingleChildScrollView(
              padding: EdgeInsets.only(bottom: 3),
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildRaisedButton(
                      "Kullanılan malzemeler yerine farklı malzemeler kullanabilirmiyim ?",
                      1,
                      meal["answers"][0]),
                  SizedBox(
                    height: 10,
                  ),
                  _buildRaisedButton(
                      "Ek olarak ekleyebileceğim malzemeler varmı ?",
                      2,
                      meal["answers"][1]),
                  SizedBox(
                    height: 10,
                  ),
                  _buildRaisedButton(
                      "Farklı sıcaklık seçeneklerini kullanabilirmiyim ?",
                      3,
                      meal["answers"][2]),
                  SizedBox(
                    height: 10,
                  ),
                  _buildRaisedButton(
                      "Kullanılan malzemelerin miktarları değişebilirmi ?",
                      4,
                      meal["answers"][3]),
                  SizedBox(
                    height: 10,
                  ),
                  _buildRaisedButton(
                      "Yemeği yaparken kullanılan mutfak aletleri nelerdir ?",
                      5,
                      meal["answers"][4]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
