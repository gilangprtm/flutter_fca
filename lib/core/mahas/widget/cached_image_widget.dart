import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../env/app_environment.dart';

/// Widget untuk menampilkan gambar dari jaringan dengan caching
/// untuk optimasi performa dan UX
class OptimizedNetworkImage extends StatelessWidget {
  /// URL gambar yang akan ditampilkan
  final String imageUrl;

  /// Placeholder widget yang ditampilkan saat gambar sedang dimuat
  final Widget? placeholder;

  /// Widget yang ditampilkan jika terjadi error saat memuat gambar
  final Widget? errorWidget;

  /// Width dari gambar
  final double? width;

  /// Height dari gambar
  final double? height;

  /// Fit mode dari gambar
  final BoxFit fit;

  /// Durasi cache gambar
  final Duration cacheDuration;

  /// Default constructor
  const OptimizedNetworkImage({
    Key? key,
    required this.imageUrl,
    this.placeholder,
    this.errorWidget,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.cacheDuration = const Duration(days: 7),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Di production, prioritaskan performa
    final isProduction = AppEnvironment.instance.isProduction;

    return CachedNetworkImage(
      imageUrl: imageUrl,
      placeholder: (context, url) =>
          placeholder ??
          Container(
            width: width,
            height: height,
            color: Colors.grey.shade200,
            child: const Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.0,
                ),
              ),
            ),
          ),
      errorWidget: (context, url, error) =>
          errorWidget ??
          Container(
            width: width,
            height: height,
            color: Colors.grey.shade200,
            child: const Center(
              child: Icon(
                Icons.broken_image_outlined,
                color: Colors.grey,
              ),
            ),
          ),
      width: width,
      height: height,
      fit: fit,
      fadeOutDuration: isProduction
          ? const Duration(milliseconds: 200)
          : const Duration(milliseconds: 500),
      fadeInDuration: isProduction
          ? const Duration(milliseconds: 200)
          : const Duration(milliseconds: 500),
      memCacheWidth: isProduction ? _calculateMemCacheSize(width) : null,
      memCacheHeight: isProduction ? _calculateMemCacheSize(height) : null,
      maxWidthDiskCache: isProduction ? 800 : null,
      maxHeightDiskCache: isProduction ? 800 : null,
    );
  }

  /// Menghitung ukuran optimal untuk memory cache
  /// untuk mencegah gambar terlalu besar di memory
  int? _calculateMemCacheSize(double? size) {
    if (size == null || size == double.infinity) return null;

    // Gunakan ukuran asli untuk gambar kecil, dan batasi ukuran untuk gambar besar
    if (size <= 300) return size.toInt();

    // Untuk gambar besar, batasi ukuran maksimal ke 1000px
    return (size * 1.5).clamp(300, 1000).toInt();
  }
}
