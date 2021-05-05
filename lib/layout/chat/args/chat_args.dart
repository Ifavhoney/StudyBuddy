class ChatArgs {
  final int channel;
  final String fromView;
  final int timerInMs;
  final List<String> users;
  final String fbKey;

  ChatArgs(
      {this.channel, this.fromView, this.timerInMs, this.users, this.fbKey});
}
