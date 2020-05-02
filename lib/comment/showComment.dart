
import 'package:f_fitness_concepts_admin/globals.dart';
import 'package:f_fitness_concepts_admin/model/adminComment.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ShowComment extends StatefulWidget {
  final AdminCommentModel adminCommentModel;

  ShowComment({Key key, @required this.adminCommentModel}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ShowCommentState();
}

class ShowCommentState extends State<ShowComment> {
  Container dividingSpace = Container(margin: EdgeInsets.only(top: 16.0));
  Padding smallDividingSpace=Padding(padding: EdgeInsets.only(top: 4.0));
  @override
  Widget build(BuildContext context) {
    print("i get this ${widget.adminCommentModel}");
    return Scaffold(
      appBar: AppBar(
        title: Text("Comment List"),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              BoldLargeText("Member"),
              smallDividingSpace,
              LargeText(widget.adminCommentModel.memberName),
              dividingSpace,
              BoldLargeText("Sent On"),smallDividingSpace,
              //LargeText(widget.adminCommentModel.commentDate),
              LargeText(DateFormat("EEEEE','  MMMM d',' y 'at' h:mm a").format(DateTime.parse(widget.adminCommentModel.commentDate))),
              dividingSpace,
              BoldLargeText("Trainer"),smallDividingSpace,
              LargeText(widget.adminCommentModel.trainerName),
              dividingSpace,
              //smallDividingSpace,
              BoldLargeText("Comment"),smallDividingSpace,
              LargeText(widget.adminCommentModel.comment),
            ],
          ),
        ),
      ),
    );
  }
}

class BoldLargeText extends StatelessWidget {
  final String text;

  BoldLargeText(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text,
      style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16.0,color: Colors.teal),
    );
  }
}
class LargeText extends StatelessWidget {
  final String text;

  LargeText(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text,
      style: TextStyle(fontSize: 16.0),
    );
  }
}