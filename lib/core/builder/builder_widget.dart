import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/styles/app_colors.dart';
import 'builder_config.dart';

/// A Flutter widget that renders Builder.io content
class BuilderWidget extends StatefulWidget {
  final String? url;
  final Map<String, String>? queryParams;
  final Widget? loadingWidget;
  final Widget? errorWidget;
  final Widget? emptyWidget;

  const BuilderWidget({
    super.key,
    this.url,
    this.queryParams,
    this.loadingWidget,
    this.errorWidget,
    this.emptyWidget,
  });

  @override
  State<BuilderWidget> createState() => _BuilderWidgetState();
}

class _BuilderWidgetState extends State<BuilderWidget> {
  List<BuilderContent> _content = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadContent();
  }

  Future<void> _loadContent() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final content = await BuilderService.fetchContent(
        url: widget.url,
        queryParams: widget.queryParams,
      );

      setState(() {
        _content = content;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return widget.loadingWidget ?? _buildDefaultLoadingWidget();
    }

    if (_error != null) {
      return widget.errorWidget ?? _buildDefaultErrorWidget();
    }

    if (_content.isEmpty) {
      return widget.emptyWidget ?? _buildDefaultEmptyWidget();
    }

    return _buildContent();
  }

  Widget _buildDefaultLoadingWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            color: AppColors.primaryBurntOrange,
          ),
          SizedBox(height: 16.h),
          Text(
            'Loading content...',
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.textDarkBrown,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 48.sp,
            color: Colors.red,
          ),
          SizedBox(height: 16.h),
          Text(
            'Error loading content',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.textDarkBrown,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            _error ?? 'Unknown error',
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.textDarkBrown.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16.h),
          ElevatedButton(
            onPressed: _loadContent,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBurntOrange,
              foregroundColor: Colors.white,
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultEmptyWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.content_copy,
            size: 48.sp,
            color: AppColors.primaryBurntOrange.withOpacity(0.5),
          ),
          SizedBox(height: 16.h),
          Text(
            'No content available',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.textDarkBrown,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return ListView.builder(
      itemCount: _content.length,
      itemBuilder: (context, index) {
        final content = _content[index];
        return _buildContentItem(content);
      },
    );
  }

  Widget _buildContentItem(BuilderContent content) {
    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            content.data['title'] ?? 'Untitled',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textDarkBrown,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            content.data['description'] ?? '',
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.textDarkBrown.withOpacity(0.8),
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'ID: ${content.id}',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.textDarkBrown.withOpacity(0.6),
                ),
              ),
              Text(
                'Updated: ${content.lastUpdated.day}/${content.lastUpdated.month}/${content.lastUpdated.year}',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.textDarkBrown.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
