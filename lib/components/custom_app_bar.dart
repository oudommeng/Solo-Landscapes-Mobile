import 'package:flutter/material.dart';
import 'package:sololandscapes_moblie/unit/colors.dart';
import 'package:sololandscapes_moblie/services/user_service.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? userName;
  final String? userImageUrl;
  final VoidCallback? onNotificationPressed;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final bool useUserService;

  const CustomAppBar({
    super.key,
    this.userName,
    this.userImageUrl,
    this.onNotificationPressed,
    this.showBackButton = false,
    this.onBackPressed,
    this.useUserService = true, // Default to using UserService
  });

  @override
  Widget build(BuildContext context) {
    final userService = UserService();
    final displayName =
        userName ?? (useUserService ? userService.userName : 'User');
    final displayImageUrl =
        userImageUrl ?? (useUserService ? userService.userImageUrl : '');

    return AppBar(
      // Transparent background to blend with the body
      backgroundColor: Colors.transparent,
      elevation: 0,
      leadingWidth: showBackButton ? 56 : 200, // Adjust width based on content
      leading: showBackButton
          ? IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.grey[800]),
              onPressed: onBackPressed ?? () => Navigator.pop(context),
            )
          : Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.grey[300],
                    child: ClipOval(
                      child: Image.network(
                        displayImageUrl,
                        fit: BoxFit.cover,
                        width: 40,
                        height: 40,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.person,
                            color: Colors.grey[600],
                            size: 24,
                          );
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                  : null,
                              strokeWidth: 2,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Hello, $displayName',
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 20.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: getColorFromHex("EBEBEB"),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              icon: Icon(Icons.notifications_none, color: Colors.grey[700]),
              onPressed:
                  onNotificationPressed ??
                  () {
                  },
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
