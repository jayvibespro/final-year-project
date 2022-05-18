class MembersSelected {
  String memberId;
  String memberImage;

  MembersSelected({
    required this.memberId,
    required this.memberImage,
  });
}

class LoadedMembers {
  String memberId;
  String memberImage;
  bool memberValue;
  String memberName;
  String memberEmail;

  LoadedMembers({
    required this.memberId,
    required this.memberImage,
    required this.memberName,
    required this.memberEmail,
    required this.memberValue,
  });
}
