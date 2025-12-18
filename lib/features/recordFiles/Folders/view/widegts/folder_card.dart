import 'package:diagno_bot/core/database/drift_db.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FolderCard extends StatelessWidget {
  final PatientFolder folder;
  final Function(int id) onTap;

  const FolderCard({super.key, required this.folder, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black12, spreadRadius: 1, blurRadius: 6),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () => onTap(folder.id),
        child: Padding(
          padding: const EdgeInsets.only(
            top: 12,
            right: 10,
            left: 10,
            bottom: 12,
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.folder_open_rounded,
                    size: 30,
                    color: Colors.blue.shade600,
                  ),
                  10.horizontalSpace,
                  Text(
                    folder.name,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
