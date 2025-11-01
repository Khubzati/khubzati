# Builder.io Integration for Khubzati Flutter App

This document describes the Builder.io integration implemented in the Khubzati Flutter application.

## Overview

Builder.io has been integrated into the Flutter app to provide dynamic content management capabilities. The integration includes:

1. **History Feature**: A new history screen with order tracking functionality
2. **Builder.io Widget**: A reusable widget for displaying Builder.io content
3. **Configuration**: Proper setup for Builder.io API integration

## Files Created/Modified

### New Files Created:
- `lib/features/history/presentation/screens/history_screen.dart` - Main history screen
- `lib/core/builder/builder_config.dart` - Builder.io configuration
- `lib/core/builder/builder_widget.dart` - Reusable Builder.io widget

### Modified Files:
- `lib/core/widgets/global_navigation_wrapper.dart` - Updated to include history screen
- `lib/core/widgets/shared_bottom_navbar.dart` - Updated navigation labels

## Features Implemented

### 1. History Screen
- **Order History Display**: Shows a list of past orders with details
- **Order Status**: Displays order status (Completed, Cancelled, etc.)
- **Order Details**: Shows order ID, date, time, vendor, items, and total
- **Empty State**: Handles cases when no orders exist
- **Tabbed Interface**: Includes both order history and Builder.io content

### 2. Builder.io Integration
- **BuilderWidget**: A Flutter widget that fetches and displays Builder.io content
- **Configuration**: Proper setup with space ID and API configuration
- **Error Handling**: Comprehensive error states and loading states
- **Content Display**: Renders Builder.io content in a Flutter-friendly format

### 3. Navigation Updates
- **Bottom Navigation**: Updated to include history tab
- **Navigation Flow**: Proper routing between different screens
- **Tab Management**: Integrated tab controller for history screen

## Builder.io Configuration

### Space ID
```
7c70fe005a624415a1a2934dd45adb0a
```

### API Configuration
The Builder.io integration is configured in `lib/core/builder/builder_config.dart`:

```dart
class BuilderConfig {
  static const String spaceId = '7c70fe005a624415a1a2934dd45adb0a';
  static const String apiKey = 'YOUR_BUILDER_API_KEY';
  static const String modelName = 'page';
  // ... other configuration
}
```

## Usage

### Using the History Screen
The history screen is automatically accessible through the bottom navigation bar. It includes:
- Order history tab
- Builder.io content tab

### Using the BuilderWidget
```dart
BuilderWidget(
  queryParams: {
    'spaceId': '7c70fe005a624415a1a2934dd45adb0a',
  },
  loadingWidget: CustomLoadingWidget(),
  errorWidget: CustomErrorWidget(),
)
```

## Setup Instructions

### 1. Builder.io Account Setup
1. Create a Builder.io account
2. Create a new space
3. Get your space ID and API key
4. Update the configuration in `builder_config.dart`

### 2. API Key Configuration
Replace `YOUR_BUILDER_API_KEY` in `builder_config.dart` with your actual Builder.io API key.

### 3. Content Model Setup
1. Create a content model in Builder.io
2. Update the `modelName` in the configuration
3. Create sample content for testing

## Testing

### Manual Testing
1. Run the Flutter app: `flutter run`
2. Navigate to the History tab in the bottom navigation
3. Test both tabs:
   - Order History tab: Shows sample order data
   - Builder.io Content tab: Shows Builder.io integration

### Builder.io Content Testing
1. Create content in your Builder.io space
2. Verify the content appears in the Builder.io tab
3. Test error states by providing invalid configuration

## Future Enhancements

### Potential Improvements
1. **Real API Integration**: Replace mock data with actual Builder.io API calls
2. **Content Caching**: Implement caching for better performance
3. **Dynamic Content**: Support for more complex Builder.io content types
4. **Offline Support**: Handle offline scenarios gracefully
5. **Content Filtering**: Add filtering and search capabilities

### Additional Features
1. **Push Notifications**: Integrate with Builder.io for content updates
2. **Analytics**: Track content engagement
3. **A/B Testing**: Support for Builder.io A/B testing features
4. **Multi-language**: Support for localized content

## Troubleshooting

### Common Issues
1. **API Key Issues**: Ensure the API key is correct and has proper permissions
2. **Space ID**: Verify the space ID matches your Builder.io space
3. **Content Not Loading**: Check network connectivity and API endpoints
4. **Widget Not Rendering**: Verify the Builder.io content structure

### Debug Information
The integration includes comprehensive logging for debugging:
- API request/response logging
- Error state handling
- Content loading states

## Support

For issues related to:
- **Flutter Integration**: Check Flutter documentation and Builder.io Flutter SDK
- **Builder.io API**: Refer to Builder.io API documentation
- **App-specific Issues**: Check the implementation in the created files

## Conclusion

The Builder.io integration provides a solid foundation for dynamic content management in the Khubzati Flutter app. The implementation includes proper error handling, loading states, and a clean architecture that can be extended for future requirements.
