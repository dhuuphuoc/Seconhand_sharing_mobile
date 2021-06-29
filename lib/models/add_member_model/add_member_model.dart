import 'package:secondhand_sharing/models/enums/add_member_response_type/add_member_response_type.dart';
import 'package:secondhand_sharing/models/member/member.dart';

class AddMemberModel {
  AddMemberResponseType type;
  Member member;

  AddMemberModel({this.type, this.member});
}
