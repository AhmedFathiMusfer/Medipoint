import 'package:diagno_bot/core/baseView/base.view.dart';
import 'package:diagno_bot/core/helpers/extensions.dart';
import 'package:diagno_bot/core/routing/router.dart';
import 'package:diagno_bot/core/theming/color.dart';
import 'package:diagno_bot/core/widgets/noData.dart';
import 'package:diagno_bot/features/recordFiles/Folders/cubit/folder.cubit.dart';
import 'package:diagno_bot/features/recordFiles/Folders/cubit/folder.state.dart';
import 'package:diagno_bot/features/recordFiles/Folders/view/widegts/folder_card.dart';
import 'package:diagno_bot/features/recordFiles/Folders/view/widegts/show_create_folder_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class PatientFoldersView extends StatelessWidget {
  const PatientFoldersView({super.key});

  @override
  Widget build(BuildContext context) {
    var folderCubit = context.read<FolderCubit>();
    return BaseView(
      title: "folders".tr(),
      floatingActionButton: BlocBuilder<FolderCubit, FolderState>(
        builder: (context, state) {
          return state.maybeWhen(
            orElse: () => SizedBox(),
            success: (_) {
              return FloatingActionButton.extended(
                backgroundColor: ColorManager.primaryColor,
                onPressed: () {
                  showCreateFolderDialog(
                    context: context,
                    onCreate: (name, description) async {
                      await folderCubit.createNewFolder(name, description);
                      return true;
                    },
                  );
                },
                icon: const Icon(
                  Icons.create_new_folder_rounded,
                  color: Colors.white,
                ),
                label: Text("new".tr(), style: TextStyle(color: Colors.white)),
              );
            },
          );
        },
      ),
      child: BlocBuilder<FolderCubit, FolderState>(
        builder: (context, state) {
          return state.maybeWhen(
            orElse: () => Nodata(),
            loading: () {
              return Center(
                child: CircularProgressIndicator(
                  color: ColorManager.primaryColor,
                ),
              );
            },
            success: (folders) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: TextFormField(
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 12.h,
                            horizontal: 12.w,
                          ),
                          hintText: 'search_folder'.tr(),
                          hintStyle: const TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Colors.grey,
                          ),
                        ),
                        onChanged: (value) async {
                          await folderCubit.fillterFolderByName(value);
                        },
                      ),
                    ),
                  ),

                  if (folders.isEmpty) Nodata(),
                  Expanded(
                    child: AnimationLimiter(
                      child: ListView.separated(
                        padding: const EdgeInsets.all(20),
                        separatorBuilder: (_, __) => const SizedBox(height: 15),
                        itemCount: folders.length,
                        itemBuilder: (context, index) {
                          final folder = folders[index];

                          return FolderCard(
                            folder: folder,
                            onTap: (id) {
                              context.pushNamed(
                                Routers.fileView,
                                arguments: id,
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

// class InteractiveSearchField extends StatefulWidget {
//   final Function(String) onChanged;

//   const InteractiveSearchField({super.key, required this.onChanged});

//   @override
//   State<InteractiveSearchField> createState() => _InteractiveSearchFieldState();
// }

// class _InteractiveSearchFieldState extends State<InteractiveSearchField> {
//   final TextEditingController _controller = TextEditingController();
//   bool _isFocused = false;
//   double _scale = 1.0;

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTapDown: (_) {
//         setState(() {
//           _scale = 0.97; // تأثير الضغط عند لمس الحقل
//         });
//       },
//       onTapUp: (_) {
//         setState(() {
//           _scale = 1.0; // العودة للحجم الطبيعي بعد رفع الإصبع
//         });
//       },
//       onTapCancel: () {
//         setState(() {
//           _scale = 1.0; // إذا تم إلغاء الضغط
//         });
//       },
//       child: Transform.scale(
//         scale: _scale,
//         child: Focus(
//           onFocusChange: (hasFocus) {
//             setState(() {
//               _isFocused = hasFocus;
//             });
//           },
//           child: AnimatedContainer(
//             duration: const Duration(milliseconds: 200),
//             padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(12),
//               boxShadow:
//                   _isFocused
//                       ? [
//                         BoxShadow(
//                           color: Colors.blue.withOpacity(0.3),
//                           blurRadius: 6,
//                           offset: const Offset(0, 3),
//                         ),
//                       ]
//                       : [
//                         BoxShadow(
//                           color: Colors.black12,
//                           blurRadius: 3,
//                           offset: const Offset(0, 1),
//                         ),
//                       ],
//               border: Border.all(
//                 color: _isFocused ? Colors.blue : Colors.grey.shade300,
//                 width: 1,
//               ),
//             ),
//             child: TextFormField(
//               controller: _controller,
//               decoration: InputDecoration(
//                 hintText: 'Search folder...',
//                 hintStyle: const TextStyle(color: Colors.grey),
//                 border: InputBorder.none,
//                 prefixIcon: const Icon(Icons.search, color: Colors.grey),
//                 suffixIcon:
//                     _controller.text.isNotEmpty
//                         ? GestureDetector(
//                           onTap: () {
//                             _controller.clear();
//                             widget.onChanged('');
//                             setState(() {});
//                           },
//                           child: const Icon(Icons.clear, color: Colors.grey),
//                         )
//                         : null,
//               ),
//               onChanged: (value) async {
//                 widget.onChanged(value);
//                 setState(() {}); // لتحديث زر clear
//               },
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
