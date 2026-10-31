import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:enseignement_vivant/constant/app_colors.dart';
import '../controller/comment_controller.dart';
import '../model/comment_model.dart';

class CommentItemCard extends StatelessWidget {
  final CommentModel item;
  final CommentController controller;
  final String postId;

  const CommentItemCard({
    super.key,
    required this.item,
    required this.controller,
    required this.postId,
  });

  void _showDeleteDialog(BuildContext context, String commentId, {CommentModel? parentComment}) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        title: Text(
          "Delete Comment?",
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, fontFamily: 'SFPro'),
        ),
        content: Text(
          "Are you sure you want to delete this comment?",
          style: TextStyle(fontSize: 13.sp, color: const Color(0xFF666666), fontFamily: 'SFPro'),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text("Cancel", style: TextStyle(color: const Color(0xFF8E8E93), fontSize: 13.sp, fontFamily: 'SFPro')),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.deleteComment(commentId: commentId, postId: postId, parentComment: parentComment);
            },
            child: Text("Delete", style: TextStyle(color: Colors.redAccent, fontSize: 13.sp, fontWeight: FontWeight.bold, fontFamily: 'SFPro')),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Parent Comment Row
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 18.r,
              backgroundColor: const Color(0xFFE0F2F1),
              backgroundImage: item.userImage.isNotEmpty
                  ? NetworkImage(item.userImage)
                  : null,
              child: item.userImage.isEmpty
                  ? Icon(Icons.person_rounded,
                      color: ConstColor.primaryTeal, size: 20.sp)
                  : null,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item.userName,
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF222222),
                          fontFamily: 'SFPro',
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            item.timeAgo,
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: const Color(0xFF8E8E93),
                              fontFamily: 'SFPro',
                            ),
                          ),
                          SizedBox(width: 4.w),
                          PopupMenuButton<String>(
                            padding: EdgeInsets.zero,
                            icon: Icon(Icons.more_vert_rounded, color: const Color(0xFF8E8E93), size: 18.sp),
                            onSelected: (value) {
                              if (value == 'edit') {
                                controller.startEditing(item);
                              } else if (value == 'delete') {
                                _showDeleteDialog(context, item.id);
                              }
                            },
                            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                              PopupMenuItem<String>(
                                value: 'edit',
                                child: Row(
                                  children: [
                                    Icon(Icons.edit_rounded, color: const Color(0xFF222222), size: 16.sp),
                                    SizedBox(width: 8.w),
                                    Text('Edit', style: TextStyle(fontSize: 13.sp, fontFamily: 'SFPro')),
                                  ],
                                ),
                              ),
                              PopupMenuItem<String>(
                                value: 'delete',
                                child: Row(
                                  children: [
                                    Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 16.sp),
                                    SizedBox(width: 8.w),
                                    Text('Delete', style: TextStyle(fontSize: 13.sp, color: Colors.redAccent, fontFamily: 'SFPro')),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    item.text,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: const Color(0xFF444444),
                      fontFamily: 'SFPro',
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: 6.h),

                  /// Action Controls (Reply & View Replies)
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          controller.replyingToComment.value = item;
                          controller.fetchReplies(item);
                        },
                        child: Text(
                          "Reply",
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                            color: ConstColor.primaryTeal,
                            fontFamily: 'SFPro',
                          ),
                        ),
                      ),
                      Obx(() {
                        if (item.replies.isNotEmpty || item.isRepliesExpanded.value) {
                          return Row(
                            children: [
                              SizedBox(width: 16.w),
                              GestureDetector(
                                onTap: () {
                                  if (!item.isRepliesExpanded.value) {
                                    controller.fetchReplies(item);
                                  } else {
                                    item.isRepliesExpanded.value = false;
                                  }
                                },
                                child: Text(
                                  item.isRepliesExpanded.value
                                      ? "Hide replies"
                                      : "View replies (${item.replies.length})",
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    color: const Color(0xFF8E8E93),
                                    fontFamily: 'SFPro',
                                  ),
                                ),
                              ),
                            ],
                          );
                        }
                        return const SizedBox.shrink();
                      }),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),

        /// Nested Replies Section
        Obx(() {
          if (item.isLoadingReplies.value) {
            return Padding(
              padding: EdgeInsets.only(left: 48.w, top: 8.h),
              child: const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: ConstColor.primaryTeal,
                ),
              ),
            );
          }

          if (item.isRepliesExpanded.value && item.replies.isNotEmpty) {
            return Padding(
              padding: EdgeInsets.only(left: 48.w, top: 12.h),
              child: Column(
                children: item.replies.map((reply) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 10.h),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 14.r,
                          backgroundColor: const Color(0xFFE0F2F1),
                          backgroundImage: reply.userImage.isNotEmpty
                              ? NetworkImage(reply.userImage)
                              : null,
                          child: reply.userImage.isEmpty
                              ? Icon(Icons.person_rounded,
                                  color: ConstColor.primaryTeal, size: 16.sp)
                              : null,
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    reply.userName,
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF222222),
                                      fontFamily: 'SFPro',
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        reply.timeAgo,
                                        style: TextStyle(
                                          fontSize: 10.sp,
                                          color: const Color(0xFF8E8E93),
                                          fontFamily: 'SFPro',
                                        ),
                                      ),
                                      SizedBox(width: 2.w),
                                      PopupMenuButton<String>(
                                        padding: EdgeInsets.zero,
                                        icon: Icon(Icons.more_vert_rounded, color: const Color(0xFF8E8E93), size: 16.sp),
                                        onSelected: (value) {
                                          if (value == 'edit') {
                                            controller.startEditing(reply);
                                          } else if (value == 'delete') {
                                            _showDeleteDialog(context, reply.id, parentComment: item);
                                          }
                                        },
                                        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                                          PopupMenuItem<String>(
                                            value: 'edit',
                                            child: Row(
                                              children: [
                                                Icon(Icons.edit_rounded, color: const Color(0xFF222222), size: 16.sp),
                                                SizedBox(width: 8.w),
                                                Text('Edit', style: TextStyle(fontSize: 13.sp, fontFamily: 'SFPro')),
                                              ],
                                            ),
                                          ),
                                          PopupMenuItem<String>(
                                            value: 'delete',
                                            child: Row(
                                              children: [
                                                Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 16.sp),
                                                SizedBox(width: 8.w),
                                                Text('Delete', style: TextStyle(fontSize: 13.sp, color: Colors.redAccent, fontFamily: 'SFPro')),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                reply.text,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: const Color(0xFF555555),
                                  fontFamily: 'SFPro',
                                  height: 1.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            );
          }
          return const SizedBox.shrink();
        }),
      ],
    );
  }
}
