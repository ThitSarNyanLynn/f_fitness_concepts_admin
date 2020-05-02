class AdminCommentModel {
  final String commentDate;
  final String memberName;
  final String trainerName;
  final String comment;

  AdminCommentModel({
    this.commentDate,
    this.memberName,
    this.trainerName,
    this.comment,
  });

  Map<String, dynamic> toMap() {
    return {
      'CommentDate':commentDate,
      'MemberName':memberName,
      'TrainerName':trainerName,
      'Comment':comment,
    };
  }

  // Implement toString to make it easier to see information about each AdminCommentModel when
  // using the print statement.
  @override
  String toString() {
    return '''AdminCommentModel:{$commentDate,$memberName,$trainerName,$comment,}''';
  }
}
