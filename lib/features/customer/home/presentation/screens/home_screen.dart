import 'package:flutter/material.dart';
import 'package:khubzati/core/extensions/context.dart';
import 'package:khubzati/gen/translations/locale_keys.g.dart';

// TODO: Implement HomeBloc for state management and API calls
// TODO: Implement BottomNavigationBar
// TODO: Implement SearchBar, Banners, Categories, Vendor Listings widgets

class HomeScreen extends StatelessWidget {
  static const String routeName = '/home';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.home_title
            .tr()), // Assuming this key exists or will be added
        // TODO: Add search icon or other actions as per Figma
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // TODO: Implement Search Bar Widget
              Text("Search Bar Placeholder",
                  style: context.theme.textTheme.titleMedium),
              const SizedBox(height: 24),

              // TODO: Implement Banners/Promotions Widget (e.g., using CarouselSlider)
              Text("Banners/Promotions Placeholder",
                  style: context.theme.textTheme.titleMedium),
              const SizedBox(height: 24),

              // TODO: Implement Categories Section (Bakery/Restaurant)
              Text(LocaleKeys.home_categories_title.tr(),
                  style: context
                      .theme.textTheme.titleLarge), // Assuming this key exists
              const SizedBox(height: 16),
              // Placeholder for category items
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Example Category Item
                  Column(
                    children: [
                      Icon(Icons.bakery_dining,
                          size: 40, color: context.colorScheme.primary),
                      const SizedBox(height: 8),
                      Text(LocaleKeys.roles_bakery
                          .tr()) // Assuming this key exists
                    ],
                  ),
                  Column(
                    children: [
                      Icon(Icons.restaurant,
                          size: 40, color: context.colorScheme.primary),
                      const SizedBox(height: 8),
                      Text(LocaleKeys.roles_restaurant
                          .tr()) // Assuming this key exists
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // TODO: Implement Listings of Nearby/Popular Vendors
              Text(LocaleKeys.home_nearby_vendors_title.tr(),
                  style: context
                      .theme.textTheme.titleLarge), // Assuming this key exists
              const SizedBox(height: 16),
              // Placeholder for vendor list - to be replaced with a ListView.builder and VendorCard widgets
              Text("Nearby Vendors List Placeholder",
                  style: context.theme.textTheme.titleMedium),
              const SizedBox(height: 24),

              Text(LocaleKeys.home_popular_vendors_title.tr(),
                  style: context
                      .theme.textTheme.titleLarge), // Assuming this key exists
              const SizedBox(height: 16),
              // Placeholder for vendor list
              Text("Popular Vendors List Placeholder",
                  style: context.theme.textTheme.titleMedium),
            ],
          ),
        ),
      ),
      // TODO: Implement BottomNavigationBar
      // bottomNavigationBar: BottomNavigationBar(...),
    );
  }
}
