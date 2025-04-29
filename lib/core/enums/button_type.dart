enum ButtonType {
  big(width: double.infinity, height: 60),
  medium(width: 243, height: 54),
  small(width: 174, height: 37);

  final double width;
  final double height;

  const ButtonType({required this.width, required this.height});
}