import 'package:flutter/material.dart';
import 'package:khubzati/core/extensions/context.dart';
import 'package:khubzati/gen/translations/locale_keys.g.dart';

// TODO: Implement VendorListingBloc for state management and API calls
// TODO: Implement Filter and Sort options
// TODO: Implement VendorCard widget and ListView.builder to display vendors

class VendorListingScreen extends StatelessWidget {
  static const String routeName = '/vendor-listing';
  // TODO: Add parameters if needed (e.g., categoryId, search_query)

  const VendorListingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            LocaleKeys.vendor_listing_title.tr()), // Assuming this key exists
        // TODO: Add filter/sort icons or other actions as per Figma
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // TODO: Implement Filter and Sort options UI
              Text("Filter/Sort Options Placeholder",
                  style: context.theme.textTheme.titleMedium),
              const SizedBox(height: 16),

              // TODO: Implement Vendor List using ListView.builder and VendorCard widgets
              Expanded(
                child: ListView.builder(
                  itemCount: 5, // Placeholder count
                  itemBuilder: (context, index) {
                    // Replace with actual VendorCard widget and data
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        leading: Icon(Icons.store,
                            size: 40, color: context.colorScheme.primary),
                        title: Text(
                            "${LocaleKeys.vendor_listing_vendor_name_placeholder.tr()} ${index + 1}"),
                        subtitle: Text(LocaleKeys
                            .vendor_listing_vendor_details_placeholder
                            .tr()),
                        onTap: () {
                          // TODO: Navigate to VendorDetailScreen
                          print("Tapped on Vendor ${index + 1}");
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
