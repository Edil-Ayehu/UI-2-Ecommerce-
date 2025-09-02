import 'package:ecommerce_ui/controllers/address_controller.dart';
import 'package:ecommerce_ui/features/shipping%20address/models/address.dart';
import 'package:ecommerce_ui/features/shipping%20address/widgets/address_card.dart';
import 'package:ecommerce_ui/utils/app_textstyles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShippingAddressScreen extends StatefulWidget {
  const ShippingAddressScreen({super.key});

  @override
  State<ShippingAddressScreen> createState() => _ShippingAddressScreenState();
}

class _ShippingAddressScreenState extends State<ShippingAddressScreen> {
  final _controller = Get.find<AddressController>();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: isDark ? Colors.white : Colors.black,
          ),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Shipping Address',
          style: AppTextStyle.withColor(
            AppTextStyle.h3,
            isDark ? Colors.white : Colors.black,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.add_circle_outline,
              color: isDark ? Colors.white : Colors.black,
            ),
            onPressed: () => _showAddAddressBottomSheet(context),
          ),
        ],
      ),
      body: GetBuilder<AddressController>(
        builder: (controller) {
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error: ${controller.errorMessage}',
                    style: AppTextStyle.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => controller.loadAddresses(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (controller.addresses.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'No addresses found',
                    style: AppTextStyle.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => _showAddAddressBottomSheet(context),
                    child: const Text('Add Address'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.addresses.length,
            itemBuilder: (context, index) => _buildAddressCard(context, index),
          );
        },
      ),
    );
  }

  Widget _buildAddressCard(BuildContext context, int index) {
    final address = _controller.addresses[index];
    return AddressCard(
      address: address,
      onEdit: () => _showEditAddressBottomSheet(context, address),
      onDelete: () => _showDeleteConfirmation(context, address.id),
      onSetDefault: () async {
        final success = await _controller.setDefaultAddress(address.id);
        if (success) {
          Get.snackbar('Success', 'Default address updated');
        } else {
          Get.snackbar('Error', 'Failed to update default address');
        }
      },
    );
  }

  void _showDeleteConfirmation(BuildContext context, String addressId) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Get.dialog(
      AlertDialog(
        title: Text(
          'Delete Address',
          style: AppTextStyle.withColor(
            AppTextStyle.h3,
            Theme.of(context).textTheme.bodyLarge!.color!,
          ),
        ),
        content: Text(
          'Are you sure you want to delete this address?',
          style: AppTextStyle.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: AppTextStyle.withColor(
                AppTextStyle.buttonMedium,
                isDark ? Colors.white70 : Colors.black54,
              ),
            ),
          ),
          () {
            // Create loading state outside onPressed
            final isLoading = RxBool(false);

            return ElevatedButton(
              onPressed: () {
                // Set loading to true
                isLoading.value = true;

                _controller.deleteAddress(addressId).then((success) {
                  // Set loading to false
                  isLoading.value = false;

                  Get.back(); // Close dialog

                  if (success) {
                    Get.snackbar('Success', 'Address deleted successfully');
                  } else {
                    Get.snackbar('Error', 'Failed to delete address');
                  }
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Obx(
                () => isLoading.value
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        'Delete',
                        style: AppTextStyle.withColor(
                          AppTextStyle.buttonMedium,
                          Colors.white,
                        ),
                      ),
              ),
            );
          }(),
        ],
      ),
    );
  }

  void _showEditAddressBottomSheet(BuildContext context, Address address) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Text controllers for form fields
    final labelController = TextEditingController(text: address.label);
    final fullAddressController =
        TextEditingController(text: address.fullAddress);
    final cityController = TextEditingController(text: address.city);
    final stateController = TextEditingController(text: address.state);
    final zipCodeController = TextEditingController(text: address.zipCode);

    // Address type selection
    final selectedType = address.type.obs;

    // Set as default checkbox
    final isDefault = address.isDefault.obs;

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Edit Address',
                    style: AppTextStyle.withColor(
                      AppTextStyle.h3,
                      Theme.of(context).textTheme.bodyLarge!.color!,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              TextField(
                controller: labelController,
                decoration: InputDecoration(
                  labelText: 'Label (e.g., Home, Office)',
                  prefixIcon: const Icon(Icons.label_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Address Type',
                style: AppTextStyle.bodyMedium,
              ),
              const SizedBox(height: 8),
              Obx(() => Row(
                    children: [
                      _buildAddressTypeChip(
                          context,
                          'Home',
                          AddressType.home,
                          selectedType.value,
                          () => selectedType.value = AddressType.home),
                      const SizedBox(width: 8),
                      _buildAddressTypeChip(
                          context,
                          'Office',
                          AddressType.office,
                          selectedType.value,
                          () => selectedType.value = AddressType.office),
                      const SizedBox(width: 8),
                      _buildAddressTypeChip(
                          context,
                          'Other',
                          AddressType.other,
                          selectedType.value,
                          () => selectedType.value = AddressType.other),
                    ],
                  )),
              const SizedBox(height: 16),
              Obx(() => CheckboxListTile(
                    title: Text('Set as default address',
                        style: AppTextStyle.bodyMedium),
                    value: isDefault.value,
                    onChanged: (value) => isDefault.value = value ?? false,
                    controlAffinity: ListTileControlAffinity.leading,
                  )),
              const SizedBox(height: 16),
              TextField(
                controller: fullAddressController,
                decoration: InputDecoration(
                  labelText: 'Full Address',
                  prefixIcon: const Icon(Icons.location_on_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: cityController,
                decoration: InputDecoration(
                  labelText: 'City',
                  prefixIcon: const Icon(Icons.location_city_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: stateController,
                      decoration: InputDecoration(
                        labelText: 'State',
                        prefixIcon: const Icon(Icons.map_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: zipCodeController,
                      decoration: InputDecoration(
                        labelText: 'ZIP Code',
                        prefixIcon: const Icon(Icons.pin_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: () {
                  // Create loading state outside onPressed
                  final isLoading = RxBool(false);

                  return ElevatedButton(
                    onPressed: () {
                      // Validate inputs
                      if (labelController.text.isEmpty ||
                          fullAddressController.text.isEmpty ||
                          cityController.text.isEmpty ||
                          stateController.text.isEmpty ||
                          zipCodeController.text.isEmpty) {
                        Get.snackbar('Error', 'Please fill all fields');
                        return;
                      }

                      // Create updated address
                      final updatedAddress = Address(
                        id: address.id,
                        label: labelController.text,
                        fullAddress: fullAddressController.text,
                        city: cityController.text,
                        state: stateController.text,
                        zipCode: zipCodeController.text,
                        isDefault: isDefault.value,
                        type: selectedType.value,
                      );

                      // Set loading to true
                      isLoading.value = true;

                      // Update address
                      _controller.updateAddress(updatedAddress).then((success) {
                        // Set loading to false
                        isLoading.value = false;

                        if (success) {
                          Get.back(); // Close bottom sheet
                          Get.snackbar(
                              'Success', 'Address updated successfully');
                        } else {
                          Get.snackbar('Error', 'Failed to update address');
                        }
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Obx(
                      () => isLoading.value
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              'Update Address',
                              style: AppTextStyle.withColor(
                                AppTextStyle.buttonMedium,
                                Colors.white,
                              ),
                            ),
                    ),
                  );
                }(),
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  void _showAddAddressBottomSheet(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Text controllers for form fields
    final labelController = TextEditingController();
    final fullAddressController = TextEditingController();
    final cityController = TextEditingController();
    final stateController = TextEditingController();
    final zipCodeController = TextEditingController();

    // Address type selection
    final selectedType = AddressType.home.obs;

    // Set as default checkbox
    final isDefault = (_controller.addresses.isEmpty).obs;

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Add New Address',
                    style: AppTextStyle.withColor(
                      AppTextStyle.h3,
                      Theme.of(context).textTheme.bodyLarge!.color!,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              TextField(
                controller: labelController,
                decoration: InputDecoration(
                  labelText: 'Label (e.g., Home, Office)',
                  prefixIcon: const Icon(Icons.label_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Address Type',
                style: AppTextStyle.bodyMedium,
              ),
              const SizedBox(height: 8),
              Obx(() => Row(
                    children: [
                      _buildAddressTypeChip(
                          context,
                          'Home',
                          AddressType.home,
                          selectedType.value,
                          () => selectedType.value = AddressType.home),
                      const SizedBox(width: 8),
                      _buildAddressTypeChip(
                          context,
                          'Office',
                          AddressType.office,
                          selectedType.value,
                          () => selectedType.value = AddressType.office),
                      const SizedBox(width: 8),
                      _buildAddressTypeChip(
                          context,
                          'Other',
                          AddressType.other,
                          selectedType.value,
                          () => selectedType.value = AddressType.other),
                    ],
                  )),
              const SizedBox(height: 16),
              Obx(() => CheckboxListTile(
                    title: Text('Set as default address',
                        style: AppTextStyle.bodyMedium),
                    value: isDefault.value,
                    onChanged: (value) => isDefault.value = value ?? false,
                    controlAffinity: ListTileControlAffinity.leading,
                  )),
              const SizedBox(height: 16),
              TextField(
                controller: fullAddressController,
                decoration: InputDecoration(
                  labelText: 'Full Address',
                  prefixIcon: const Icon(Icons.location_on_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: cityController,
                decoration: InputDecoration(
                  labelText: 'City',
                  prefixIcon: const Icon(Icons.location_city_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: stateController,
                      decoration: InputDecoration(
                        labelText: 'State',
                        prefixIcon: const Icon(Icons.map_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: zipCodeController,
                      decoration: InputDecoration(
                        labelText: 'ZIP Code',
                        prefixIcon: const Icon(Icons.pin_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: () {
                  // Create loading state outside onPressed
                  final isLoading = RxBool(false);

                  return ElevatedButton(
                    onPressed: () {
                      // Validate inputs
                      if (labelController.text.isEmpty ||
                          fullAddressController.text.isEmpty ||
                          cityController.text.isEmpty ||
                          stateController.text.isEmpty ||
                          zipCodeController.text.isEmpty) {
                        Get.snackbar('Error', 'Please fill all fields');
                        return;
                      }

                      // Create new address
                      final newAddress = Address(
                        id: '', // ID will be generated by repository
                        label: labelController.text,
                        fullAddress: fullAddressController.text,
                        city: cityController.text,
                        state: stateController.text,
                        zipCode: zipCodeController.text,
                        isDefault: isDefault.value,
                        type: selectedType.value,
                      );

                      // Set loading to true
                      isLoading.value = true;

                      // Save address
                      _controller.addAddress(newAddress).then((success) {
                        // Set loading to false
                        isLoading.value = false;

                        if (success) {
                          Get.back(); // Close bottom sheet
                          Get.snackbar('Success', 'Address added successfully');
                        } else {
                          Get.snackbar('Error', 'Failed to add address');
                        }
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Obx(
                      () => isLoading.value
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              'Save Address',
                              style: AppTextStyle.withColor(
                                AppTextStyle.buttonMedium,
                                Colors.white,
                              ),
                            ),
                    ),
                  );
                }(),
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildAddressTypeChip(BuildContext context, String label,
      AddressType type, AddressType selectedType, VoidCallback onTap) {
    final isSelected = type == selectedType;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color:
              isSelected ? Theme.of(context).primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Theme.of(context).primaryColor : Colors.grey,
          ),
        ),
        child: Text(
          label,
          style: AppTextStyle.withColor(
            AppTextStyle.bodyMedium,
            isSelected
                ? Colors.white
                : Theme.of(context).textTheme.bodyLarge!.color!,
          ),
        ),
      ),
    );
  }
}
