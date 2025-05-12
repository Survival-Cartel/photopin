import 'package:photopin/journal/domain/model/journal_model.dart';

sealed class HomeAction {
  factory HomeAction.cameraClick() = CameraClick;
  factory HomeAction.newJournalClick() = NewJournalClick;
  factory HomeAction.shareClick() = ShareClick;
  factory HomeAction.recentActivityClick() = RecentActivityClick;
  factory HomeAction.seeAllClick() = SeeAllClick;
  factory HomeAction.myJounalClick(String id) = MyJournalClick;
  factory HomeAction.findUser() = FindUser;
  factory HomeAction.findJounals() = FindJounals;
  factory HomeAction.newJournalSave({required JournalModel journal}) =
      NewJournalSave;
}

class CameraClick implements HomeAction {}

class NewJournalClick implements HomeAction {}

class ShareClick implements HomeAction {}

class RecentActivityClick implements HomeAction {}

class SeeAllClick implements HomeAction {}

class MyJournalClick implements HomeAction {
  final String id;

  const MyJournalClick(this.id);
}

class FindUser implements HomeAction {}

class FindJounals implements HomeAction {}

class NewJournalSave implements HomeAction {
  final JournalModel journal;

  const NewJournalSave({required this.journal});
}
