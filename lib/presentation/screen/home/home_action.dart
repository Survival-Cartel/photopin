sealed class HomeAction {
  factory HomeAction.cameraClick() = CameraClick;
  factory HomeAction.newJournalClick() = NewJournalClick;
  factory HomeAction.shareClick() = ShareClick;
  factory HomeAction.recentActivityClick() = RecentActivityClick;
  factory HomeAction.seeAllClick() = SeeAllClick;
  factory HomeAction.myJounalClick(String id) = MyJounalClick;
  factory HomeAction.findUser() = FindUser;
  factory HomeAction.findJounals() = FindJounals;
}

class CameraClick implements HomeAction {}

class NewJournalClick implements HomeAction {}

class ShareClick implements HomeAction {}

class RecentActivityClick implements HomeAction {}

class SeeAllClick implements HomeAction {}

class MyJounalClick implements HomeAction {
  final String id;

  const MyJounalClick(this.id);
}

class FindUser implements HomeAction {}

class FindJounals implements HomeAction {}
