class UserService {
  // Singleton pattern for global access
  static final UserService _instance = UserService._internal();
  factory UserService() => _instance;
  UserService._internal();

  // Current user data
  String _userName = 'Oudom';
  String _userImageUrl =
      'https://media.licdn.com/dms/image/v2/D5603AQHxFxKw8WhlUw/profile-displayphoto-scale_400_400/B56ZkLUDjUHAAg-/0/1756831440998?e=1759968000&v=beta&t=TeU3svKkw0WuYgvFapaMrGzzeSgvNp_Jj-FVeg9Hdww';

  // Getters
  String get userName => _userName;
  String get userImageUrl => _userImageUrl;

  // Methods to update user data
  void updateUserName(String name) {
    _userName = name;
  }

  void updateUserImageUrl(String imageUrl) {
    _userImageUrl = imageUrl;
  }

  void updateUserData({String? name, String? imageUrl}) {
    if (name != null) _userName = name;
    if (imageUrl != null) _userImageUrl = imageUrl;
  }
}
