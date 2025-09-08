# CustomAppBar Usage Guide

The `CustomAppBar` component provides a reusable app bar that can be used across multiple screens in your Flutter application.

## Features

- **Consistent Design**: Maintains the same look and feel across all screens
- **User Profile Display**: Shows user avatar and greeting message
- **Notification Button**: Customizable notification handler
- **Back Button Support**: Automatically shows back button for non-home screens
- **UserService Integration**: Automatically pulls user data from UserService
- **Flexible Configuration**: Can override default values when needed

## Basic Usage

### For Home Screen (No Back Button)

```dart
appBar: const CustomAppBar(),
```

### For Other Screens (With Back Button)

```dart
appBar: const CustomAppBar(
  showBackButton: true,
),
```

### With Custom Notification Handler

```dart
appBar: CustomAppBar(
  showBackButton: true,
  onNotificationPressed: () {
    // Your custom notification logic
    showDialog(context: context, ...);
  },
),
```

### With Custom User Data (Override UserService)

```dart
appBar: const CustomAppBar(
  userName: 'Custom Name',
  userImageUrl: 'https://example.com/avatar.jpg',
  useUserService: false, // Disable UserService
),
```

## Parameters

| Parameter               | Type          | Default | Description                                          |
| ----------------------- | ------------- | ------- | ---------------------------------------------------- |
| `userName`              | String?       | null    | Override the display name (uses UserService if null) |
| `userImageUrl`          | String?       | null    | Override the avatar image (uses UserService if null) |
| `onNotificationPressed` | VoidCallback? | null    | Custom notification tap handler                      |
| `showBackButton`        | bool          | false   | Show back button instead of user profile             |
| `onBackPressed`         | VoidCallback? | null    | Custom back button handler                           |
| `useUserService`        | bool          | true    | Whether to use UserService for user data             |

## UserService

The `UserService` is a singleton that manages user data globally:

```dart
// Get user service instance
final userService = UserService();

// Update user data
userService.updateUserName('New Name');
userService.updateUserImageUrl('https://new-avatar.jpg');

// Or update both at once
userService.updateUserData(
  name: 'New Name',
  imageUrl: 'https://new-avatar.jpg',
);
```

## File Structure

```
lib/
├── components/
│   └── custom_app_bar.dart       # Reusable AppBar component
├── services/
│   └── user_service.dart         # User data management
└── screens/
    ├── home/
    │   └── home_screen.dart      # Example: Home screen usage
    ├── profile/
    │   └── profile_screen.dart   # Example: Screen with back button
    └── settings/
        └── settings_screen.dart  # Example: Custom notification handler
```

## Benefits

1. **DRY Principle**: Write once, use everywhere
2. **Consistent UX**: Same app bar behavior across all screens
3. **Easy Maintenance**: Update styling in one place
4. **Flexible**: Can be customized per screen when needed
5. **Centralized User Data**: UserService manages user info globally
