import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
import 'package:qr_code_inventory/app/utils/app_colors.dart';

class PhoneNumberField extends StatefulWidget {
  final String label;
  final String hint;
  final TextEditingController controller;

  const PhoneNumberField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
  });

  @override
  State<PhoneNumberField> createState() => _PhoneNumberFieldState();
}

class _PhoneNumberFieldState extends State<PhoneNumberField> {
  Country _selectedCountry = Country(
    phoneCode: '62',
    countryCode: 'ID',
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: 'Indonesia',
    example: '812-345-678',
    displayName: 'Indonesia (ID)',
    displayNameNoCountryCode: 'Indonesia',
    e164Key: '62-ID-0',
  );

  @override
  Widget build(BuildContext context) {
    // Set theme for country picker 
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.primaryText,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: widget.controller,
          keyboardType: TextInputType.phone,
          cursorColor: AppColors.primary,
          style: const TextStyle(
            color: AppColors.primaryText,
            fontSize: 16,
            fontWeight: FontWeight.normal,
          ),
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: const TextStyle(color: AppColors.secondaryText),
            prefixIcon: InkWell(
              onTap: () {
                showCountryPicker(
                  context: context,
                  showPhoneCode: true,
                  favorite: ['ID', 'US', 'SG', 'MY'],
                  countryListTheme: CountryListThemeData(
                    borderRadius: BorderRadius.circular(12),
                    backgroundColor: Colors.white,
                    // Use theme for consistent text styling
                    textStyle: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.primaryText,
                      fontSize: 16,
                    ),
                    searchTextStyle: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.primaryText,
                      fontSize: 16,
                    ),
                    bottomSheetHeight: 500,
                    inputDecoration: InputDecoration(
                      labelText: 'Search',
                      filled: true,
                      fillColor: Colors.white,
                      labelStyle: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.primaryText,
                        fontWeight: FontWeight.w500,
                      ),
                      hintText: 'Start typing to search',
                      hintStyle: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.secondaryText,
                      ),
                      prefixIcon: const Icon(Icons.search, color: AppColors.primaryText),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: const Color(0xFF8C98A8).withOpacity(0.2),
                        ),
                      ),
                    ),
                  ),
                  onSelect: (Country country) {
                    setState(() {
                      _selectedCountry = country;
                    });
                  },
                );
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Text(
                      '+${_selectedCountry.phoneCode}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primaryText,
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Icon(Icons.keyboard_arrow_down, color: AppColors.secondaryText),
                  ),
                ],
              ),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: AppColors.textFieldBorder, width: 1.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: AppColors.textFieldBorder, width: 1.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}