import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:khubzati/core/routes/app_router.dart';
import 'package:khubzati/core/theme/styles/app_colors.dart';
import 'package:khubzati/features/restaurant_owner/auth/application/blocs/restaurant_signup_event.dart';
import 'package:khubzati/features/restaurant_owner/auth/application/blocs/restaurant_signup_state.dart';
import 'package:khubzati/gen/translations/locale_keys.g.dart';
import 'package:khubzati/features/restaurant_owner/auth/application/blocs/restaurant_signup_bloc.dart';
import 'package:khubzati/features/restaurant_owner/auth/presentation/widgets/restaurant_signup_header.dart';
import 'package:khubzati/features/restaurant_owner/auth/presentation/widgets/restaurant_signup_form.dart';
import 'package:khubzati/features/restaurant_owner/auth/presentation/widgets/restaurant_file_upload.dart';
import 'package:khubzati/features/restaurant_owner/auth/presentation/widgets/restaurant_chef_section.dart';
import 'package:khubzati/features/restaurant_owner/auth/presentation/widgets/restaurant_signup_actions.dart';

@RoutePage()
class RestaurantSignupScreen extends StatefulWidget {
  const RestaurantSignupScreen({super.key});

  @override
  State<RestaurantSignupScreen> createState() => _RestaurantSignupScreenState();
}

class _RestaurantSignupScreenState extends State<RestaurantSignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _restaurantNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _locationController = TextEditingController();
  final _chefNameController = TextEditingController();

  String? _selectedLogoPath;
  String? _selectedCommercialRegisterPath;
  final List<String> _chefs = [];

  @override
  void dispose() {
    _restaurantNameController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    _chefNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          LocaleKeys.app_signup_app_signup_createNewAccount.tr(),
          style: const TextStyle(
            color: AppColors.onSurface,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocListener<RestaurantSignupBloc, RestaurantSignupState>(
        listener: (context, state) {
          if (state is RestaurantSignupSuccess) {
            context.router.push(RestaurantOtpVerificationRoute(
              phoneNumber: _phoneController.text,
              verificationId: state.verificationId,
            ));
          } else if (state is RestaurantSignupError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const RestaurantSignupHeader(),
                const SizedBox(height: 30),
                RestaurantSignupForm(
                  restaurantNameController: _restaurantNameController,
                  phoneController: _phoneController,
                  locationController: _locationController,
                ),
                const SizedBox(height: 30),
                _buildFileUploads(),
                const SizedBox(height: 20),
                RestaurantChefSection(
                  chefNameController: _chefNameController,
                  chefs: _chefs,
                  onAddChef: _addChef,
                ),
                const SizedBox(height: 30),
                BlocBuilder<RestaurantSignupBloc, RestaurantSignupState>(
                  builder: (context, state) {
                    return RestaurantSignupActions(
                      onSubmit: _submitForm,
                      isLoading: state is RestaurantSignupLoading,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFileUploads() {
    return Column(
      children: [
        RestaurantFileUpload(
          title: LocaleKeys.app_restaurant_owner_auth_restaurant_logo.tr(),
          subtitle: LocaleKeys
              .app_restaurant_owner_auth_restaurant_logo_subtitle
              .tr(),
          selectedPath: _selectedLogoPath,
          onTap: () => _selectFile(true),
        ),
        const SizedBox(height: 16),
        RestaurantFileUpload(
          title: LocaleKeys.app_restaurant_owner_auth_commercial_register.tr(),
          subtitle: LocaleKeys
              .app_restaurant_owner_auth_commercial_register_subtitle
              .tr(),
          selectedPath: _selectedCommercialRegisterPath,
          onTap: () => _selectFile(false),
        ),
      ],
    );
  }

  void _selectFile(bool isLogo) {
    // TODO: Implement file selection
    setState(() {
      if (isLogo) {
        _selectedLogoPath = 'logo_selected.png';
      } else {
        _selectedCommercialRegisterPath = 'commercial_register_selected.pdf';
      }
    });
  }

  void _addChef() {
    if (_chefNameController.text.isNotEmpty) {
      setState(() {
        _chefs.add(_chefNameController.text);
        _chefNameController.clear();
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      context.read<RestaurantSignupBloc>().add(
            RestaurantSignupRequested(
              restaurantName: _restaurantNameController.text,
              phoneNumber: _phoneController.text,
              location: _locationController.text,
              logoPath: _selectedLogoPath,
              commercialRegisterPath: _selectedCommercialRegisterPath,
              chefNames: _chefs,
            ),
          );
    }
  }
}
