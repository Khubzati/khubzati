import 'dart:ui';
import 'package:flutter/material.dart';

class EditProductScreenBloc extends StatefulWidget {
  const EditProductScreenBloc({Key? key}) : super(key: key);

  @override
  State<EditProductScreenBloc> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreenBloc> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _caloriesController = TextEditingController();

  String? _selectedType;
  String? _selectedUnit;

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    _caloriesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F2E4),
      body: Stack(
        children: [
          // Main content
          SingleChildScrollView(
            child: Column(
              children: [
                // Header with blur
                Stack(
                  children: [
                    // Background image
                    Image.network(
                      'https://api.builder.io/api/v1/image/assets/TEMP/de10d90a694f734400b0d04df185773f2f050380?width=780',
                      width: double.infinity,
                      height: 125,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: double.infinity,
                          height: 125,
                          color: const Color(0xFF965641),
                        );
                      },
                    ),
                    // Blur overlay
                    Container(
                      width: double.infinity,
                      height: 125,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.01),
                      ),
                      child: ClipRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 6.3, sigmaY: 6.3),
                          child: Container(
                            color: Colors.transparent,
                          ),
                        ),
                      ),
                    ),
                    // Title
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 24),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.chevron_left,
                              color: Color(0xFFF9F2E4),
                              size: 24,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'تعديل على الصنف',
                              style: TextStyle(
                                color: Color(0xFFF9F2E4),
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Tajawal',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                // Form fields
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const SizedBox(height: 20),

                        // Product Name
                        _buildTextFieldWithLabel(
                          label: 'اسم الصنف',
                          placeholder: 'ادخل الاسم',
                          controller: _nameController,
                        ),
                        const SizedBox(height: 16),

                        // Type Dropdown
                        _buildDropdownWithLabel(
                          label: 'النوع',
                          placeholder: 'اختر النوع',
                          value: _selectedType,
                          items: ['خبز', 'معجنات', 'حلويات'],
                          onChanged: (value) {
                            setState(() {
                              _selectedType = value;
                            });
                          },
                        ),
                        const SizedBox(height: 16),

                        // Quantity
                        _buildTextFieldWithLabel(
                          label: 'الكمية',
                          placeholder: 'ادخل الكمية اليومية',
                          controller: _quantityController,
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 16),

                        // Unit Dropdown
                        _buildDropdownWithLabel(
                          label: 'x',
                          placeholder: 'بالكيلو',
                          value: _selectedUnit,
                          items: ['بالكيلو', 'بالقطعة', 'بالحبة'],
                          onChanged: (value) {
                            setState(() {
                              _selectedUnit = value;
                            });
                          },
                        ),
                        const SizedBox(height: 16),

                        // Price
                        _buildTextFieldWithLabel(
                          label: 'السعر/الكمية',
                          placeholder: 'ادخل السعر',
                          controller: _priceController,
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 28),

                        // Nutritional Value Header
                        const Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'القيمة الغذائية',
                            style: TextStyle(
                              color: Color(0xFF67392A),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Tajawal',
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Calories
                        _buildTextFieldWithLabel(
                          label: 'السعرات الحرارية',
                          placeholder: 'ادخل السعرات الحرارية',
                          controller: _caloriesController,
                          keyboardType: TextInputType.number,
                        ),

                        const SizedBox(height: 120),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Bottom button
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 96,
              decoration: BoxDecoration(
                color: const Color(0xFFF9F2E4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 18,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 21),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Save changes
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFC25E3E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    elevation: 0,
                  ),
                  child: const Text(
                    'حفظ التعديلات',
                    style: TextStyle(
                      color: Color(0xFFF9F2E4),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Tajawal',
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextFieldWithLabel({
    required String label,
    required String placeholder,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return SizedBox(
      height: 59,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Text field
          Positioned(
            top: 17,
            left: 0,
            right: 0,
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: Color(0xFF965641),
                fontSize: 12,
                fontWeight: FontWeight.w500,
                fontFamily: 'Tajawal',
              ),
              decoration: InputDecoration(
                hintText: placeholder,
                hintStyle: TextStyle(
                  color: const Color(0xFF965641).withOpacity(0.46),
                  fontSize: 12,
                  fontFamily: 'Tajawal',
                ),
                contentPadding: const EdgeInsets.all(12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: const Color(0xFF965641).withOpacity(0.46),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: const Color(0xFF965641).withOpacity(0.46),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: Color(0xFF965641),
                  ),
                ),
              ),
            ),
          ),
          // Label
          Positioned(
            top: 0,
            right: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              color: const Color(0xFFF8F2E8),
              child: Text(
                label,
                style: const TextStyle(
                  color: Color(0xFF67392A),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Tajawal',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownWithLabel({
    required String label,
    required String placeholder,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return SizedBox(
      height: 61,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Dropdown field
          Positioned(
            top: 17,
            left: 0,
            right: 0,
            child: DropdownButtonFormField<String>(
              value: value,
              isExpanded: true,
              decoration: InputDecoration(
                hintText: placeholder,
                hintStyle: TextStyle(
                  color: const Color(0xFF965641).withOpacity(0.46),
                  fontSize: 12,
                  fontFamily: 'Tajawal',
                ),
                contentPadding: const EdgeInsets.all(12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: const Color(0xFF965641).withOpacity(0.46),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: const Color(0xFF965641).withOpacity(0.46),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: Color(0xFF965641),
                  ),
                ),
              ),
              icon: Icon(
                Icons.keyboard_arrow_down,
                color: const Color(0xFF965641).withOpacity(0.46),
              ),
              style: const TextStyle(
                color: Color(0xFF965641),
                fontSize: 12,
                fontWeight: FontWeight.w500,
                fontFamily: 'Tajawal',
              ),
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  alignment: AlignmentDirectional.centerEnd,
                  child: Text(item),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
          // Label
          Positioned(
            top: 0,
            right: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              color: const Color(0xFFF8F2E8),
              child: Text(
                label,
                style: const TextStyle(
                  color: Color(0xFF67392A),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Tajawal',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
