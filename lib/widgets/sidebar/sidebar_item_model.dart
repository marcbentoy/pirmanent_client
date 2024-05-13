class SidebarModel {
  final String title;
  final String svgIconAssetPath;
  final int? notifications;
  final void Function() clickCallback;

  SidebarModel({
    required this.title,
    required this.svgIconAssetPath,
    required this.clickCallback,
    this.notifications,
  });
}
