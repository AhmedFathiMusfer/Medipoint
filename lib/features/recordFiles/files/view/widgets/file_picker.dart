import 'package:diagno_bot/core/theming/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

void showCreateFileDialog({
  required BuildContext context,
  required Function(String name, String type, String sourceOrFile) onUpload,
}) {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();

  String? selectedType;
  String? selectedSource;

  final picker = ImagePicker();
  bool isLoading = false;

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Create New File",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Name Field
                      TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                          labelText: "Name",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Name cannot be empty";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          _smallRadioButton(
                            label: "Image",
                            value: "image",
                            groupValue: selectedType,
                            onChanged: (val) {
                              setState(() {
                                selectedType = val;
                                selectedSource = null;
                              });
                            },
                          ),
                          const SizedBox(width: 20),
                          _smallRadioButton(
                            label: "File",
                            value: "file",
                            groupValue: selectedType,
                            onChanged: (val) {
                              setState(() {
                                selectedType = val;
                                selectedSource = null;
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      if (selectedType == "file")
                        ElevatedButton.icon(
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all<Color>(
                              Colors.white,
                            ),
                          ),
                          onPressed: () async {
                            FilePickerResult? result =
                                await FilePicker.platform.pickFiles();
                            if (result != null) {
                              setState(() {
                                selectedSource = result.files.single.path;
                              });
                            }
                          },
                          icon: const Icon(
                            Icons.insert_drive_file,
                            color: ColorManager.blueColor,
                          ),
                          label: const Text(
                            "Choose File",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),

                      if (selectedType == "image") ...[
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                style: ButtonStyle(
                                  backgroundColor:
                                      WidgetStateProperty.all<Color>(
                                        Colors.white,
                                      ),
                                ),
                                onPressed: () async {
                                  final pickedFile = await picker.pickImage(
                                    source: ImageSource.camera,
                                  );
                                  if (pickedFile != null) {
                                    setState(() {
                                      selectedSource = pickedFile.path;
                                    });
                                  }
                                },
                                icon: const Icon(
                                  Icons.camera_alt,
                                  color: ColorManager.blueColor,
                                ),
                                label: const Text(
                                  "Camera",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: ElevatedButton.icon(
                                style: ButtonStyle(
                                  backgroundColor:
                                      WidgetStateProperty.all<Color>(
                                        Colors.white,
                                      ),
                                ),
                                onPressed: () async {
                                  final pickedFile = await picker.pickImage(
                                    source: ImageSource.gallery,
                                  );
                                  if (pickedFile != null) {
                                    setState(() {
                                      selectedSource = pickedFile.path;
                                    });
                                  }
                                },
                                icon: const Icon(
                                  Icons.photo_library,
                                  color: ColorManager.blueColor,
                                ),
                                label: const Text(
                                  "Gallery",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                      20.verticalSpace,
                      if (selectedSource != null)
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.grey[200],
                          ),
                          child: Row(
                            children: [
                              Icon(
                                selectedType == "file"
                                    ? Icons.insert_drive_file
                                    : Icons.image,
                                size: 40,
                                color: Colors.blue,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  selectedSource!.split('/').last,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      20.verticalSpace,
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                          backgroundColor: ColorManager.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate() &&
                              selectedType != null &&
                              selectedSource != null) {
                            setState(() => isLoading = true);
                            await onUpload(
                              nameController.text.trim(),
                              selectedType!,
                              selectedSource!,
                            );
                            Navigator.pop(context);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Please fill all required fields",
                                ),
                              ),
                            );
                          }
                        },
                        child:
                            isLoading
                                ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                )
                                : const Text(
                                  "Upload",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    },
  );
}

// الدالة الخاصة بالدائرة الصغيرة
Widget _smallRadioButton({
  required String label,
  required String value,
  required String? groupValue,
  required Function(String?) onChanged,
}) {
  bool isSelected = value == groupValue;
  return GestureDetector(
    onTap: () => onChanged(value),
    child: Row(
      children: [
        Container(
          width: 20,
          height: 20,

          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: isSelected ? Colors.blue : Colors.grey,
              width: 2,
            ),
          ),
          child:
              isSelected
                  ? Center(
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue,
                      ),
                    ),
                  )
                  : null,
        ),
        const SizedBox(width: 6),
        Text(label),
      ],
    ),
  );
}
