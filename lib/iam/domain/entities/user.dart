/// Represents a user in the system with authentication and authorization information.
/// 
/// This entity contains the core user data needed for identity and access management,
/// including username for identification and roles for authorization decisions.
/// 
/// The User entity is used throughout the application to:
/// - Identify the current authenticated user
/// - Determine access permissions based on roles
/// - Display user information in the UI
/// - Manage user sessions and authentication state
class User {
  /// The unique identifier for the user in the system.
  /// 
  /// This field is used for:
  /// - User identification during authentication
  /// - Displaying user information in the UI
  /// - Logging and audit trails
  /// - API requests that require user context
  final String username;

  /// List of roles assigned to the user that determine their permissions.
  /// 
  /// Roles are used to:
  /// - Control access to different features and screens
  /// - Determine what actions the user can perform
  /// - Customize the UI based on user permissions
  /// - Enforce business rules and security policies
  /// 
  /// Common roles might include: 'admin', 'resident', 'manager', etc.
  final List<String> roles;

  /// Creates a new User instance with the required username and roles.
  /// 
  /// [username] - The unique identifier for the user
  /// [roles] - List of roles that determine user permissions
  User({required this.username, required this.roles});

  /// Creates a User instance from a JSON object.
  /// 
  /// This factory constructor is used when deserializing user data from:
  /// - API responses
  /// - Local storage
  /// - Session management
  /// 
  /// [json] - Map containing user data with 'username' and 'roles' keys
  /// 
  /// Returns a new User instance with data from the JSON object
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'],
      roles: List<String>.from(json['roles']),
    );
  }

  /// Converts the User instance to a JSON object.
  /// 
  /// This method is used when serializing user data for:
  /// - API requests
  /// - Local storage
  /// - Session persistence
  /// 
  /// Returns a Map containing the user's username and roles
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'roles': roles,
    };
  }
}