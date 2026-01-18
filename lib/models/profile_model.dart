class ProfileModel {
  final String id;
  final String fullName;
  final String title;
  final String? bio;
  final String? profileImageUrl;
  final String status;
  final String? location;
  final String? tagLine;

  ProfileModel({
    required this.id,
    required this.fullName,
    required this.title,
    this.bio,
    this.profileImageUrl,
    required this.status,
    this.location,
    this.tagLine,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] as String,
      fullName: json['full_name'] as String,
      title: json['title'] as String,
      bio: json['bio'] as String?,
      profileImageUrl: json['profile_image_url'] as String?,
      status: json['status'] as String? ?? 'ONLINE_',
      location: json['location'] as String?,
      tagLine: json['tag_line'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'title': title,
      'bio': bio,
      'profile_image_url': profileImageUrl,
      'status': status,
      'location': location,
      'tag_line': tagLine,
    };
  }
}
