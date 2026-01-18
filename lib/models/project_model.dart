class ProjectModel {
  final String id;
  final String title;
  final String? subtitle;
  final String? imageUrl;
  final List<String> tags;
  final String? version;
  final String? statusLabel;
  final bool isLive;
  final String? projectUrl;
  final DateTime? createdAt;
  final List<String> galleryImages;
  final String? objective;
  final Map<String, dynamic>? performanceMetrics;
  final List<dynamic>? challenges;
  final String? description;
  final Map<String, dynamic>? architecture;
  final List<dynamic>? features;

  ProjectModel({
    required this.id,
    required this.title,
    this.subtitle,
    this.imageUrl,
    required this.tags,
    this.version,
    this.statusLabel,
    required this.isLive,
    this.projectUrl,
    this.createdAt,
    this.galleryImages = const [],
    this.objective,
    this.performanceMetrics,
    this.challenges,
    this.description,
    this.architecture,
    this.features,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['id'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String?,
      imageUrl: json['image_url'] as String?,
      tags: List<String>.from(json['tags'] ?? []),
      version: json['version'] as String?,
      statusLabel: json['status_label'] as String?,
      isLive: json['is_live'] as bool? ?? false,
      projectUrl: json['project_url'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      galleryImages: List<String>.from(json['gallery_images'] ?? []),
      objective: json['objective'] as String?,
      performanceMetrics: json['performance_metrics'] as Map<String, dynamic>?,
      challenges: json['challenges'] as List<dynamic>?,
      description: json['description'] as String?,
      architecture: json['architecture'] as Map<String, dynamic>?,
      features: json['features'] as List<dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'image_url': imageUrl,
      'tags': tags,
      'version': version,
      'status_label': statusLabel,
      'is_live': isLive,
      'project_url': projectUrl,
      'created_at': createdAt?.toIso8601String(),
      'gallery_images': galleryImages,
      'objective': objective,
      'performance_metrics': performanceMetrics,
      'challenges': challenges,
      'description': description,
      'architecture': architecture,
      'features': features,
    };
  }
}
