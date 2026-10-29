import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:enseignement_vivant/constant/app_colors.dart';
import 'package:enseignement_vivant/services/storage_services/get_storage_services.dart';
import 'package:enseignement_vivant/utils/gap.dart';
import 'controller/comment_controller.dart';
import 'widget/comment_item_card.dart';

class CommentBottomSheet {
  static void show(BuildContext context, {required String postId, required String postType}) {
    final controller = Get.put(CommentController());
    controller.fetchComments(postId);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.78,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          ),
          child: Column(
            children: [
              Gap(height: 10.h),

              /// Top Drag Indicator Handle
              Container(
                width: 38.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFE5E7EB),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),

              Gap(height: 12.h),

              /// Header Title Row
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Comments",
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF222222),
                            fontFamily: 'SFPro',
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Obx(
                          () => Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                            decoration: BoxDecoration(
                              color: ConstColor.primaryTeal.withAlpha(20),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Text(
                              "${controller.comments.length}",
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.bold,
                                color: ConstColor.primaryTeal,
                                fontFamily: 'SFPro',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: Icon(Icons.close_rounded, color: const Color(0xFF8E8E93), size: 22.sp),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),

              const Divider(color: Color(0xFFE5E7EB), thickness: 1),

              /// Comments List
              Expanded(
                child: Obx(
                  () {
                    if (controller.isLoading.value && controller.comments.isEmpty) {
                      return const Center(
                        child: CircularProgressIndicator(color: ConstColor.primaryTeal),
                      );
                    }

                    if (controller.comments.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.mode_comment_outlined,
                              color: const Color(0xFFC7C7CC),
                              size: 48.sp,
                            ),
                            Gap(height: 12.h),
                            Text(
                              "No comments yet",
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: const Color(0xFF8E8E93),
                                fontFamily: 'SFPro',
                              ),
                            ),
                            Gap(height: 4.h),
                            Text(
                              "Be the first to share your thoughts!",
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: const Color(0xFFA1A1A1),
                                fontFamily: 'SFPro',
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.separated(
                      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                      itemCount: controller.comments.length,
                      separatorBuilder: (context, index) => Gap(height: 16.h),
                      itemBuilder: (context, index) {
                        final item = controller.comments[index];
                        return CommentItemCard(
                          item: item,
                          controller: controller,
                          postId: postId,
                        );
                      },
                    );
                  },
                ),
              ),

              /// Bottom Comment, Reply & Edit Input Field
              Container(
                padding: EdgeInsets.only(
                  left: 16.w,
                  right: 16.w,
                  top: 10.h,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 12.h,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(10),
                      blurRadius: 8,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      /// Replying To Banner Chip
                      Obx(() {
                        final replyingTo = controller.replyingToComment.value;
                        if (replyingTo == null) return const SizedBox.shrink();

                        return Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                          margin: EdgeInsets.only(bottom: 8.h),
                          decoration: BoxDecoration(
                            color: ConstColor.primaryTeal.withAlpha(20),
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.reply_rounded, color: ConstColor.primaryTeal, size: 16.sp),
                              SizedBox(width: 6.w),
                              Expanded(
                                child: Text(
                                  "Replying to @${replyingTo.userName}",
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.bold,
                                    color: ConstColor.primaryTeal,
                                    fontFamily: 'SFPro',
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  controller.replyingToComment.value = null;
                                },
                                child: Icon(Icons.close_rounded,
                                    color: ConstColor.primaryTeal, size: 16.sp),
                              ),
                            ],
                          ),
                        );
                      }),

                      /// Editing Comment Banner Chip
                      Obx(() {
                        final editing = controller.editingComment.value;
                        if (editing == null) return const SizedBox.shrink();

                        return Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                          margin: EdgeInsets.only(bottom: 8.h),
                          decoration: BoxDecoration(
                            color: Colors.orange.withAlpha(30),
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.edit_rounded, color: Colors.orange, size: 16.sp),
                              SizedBox(width: 6.w),
                              Expanded(
                                child: Text(
                                  "Editing comment...",
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange,
                                    fontFamily: 'SFPro',
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              GestureDetector(
                                onTap: controller.cancelEditing,
                                child: Icon(Icons.close_rounded,
                                    color: Colors.orange, size: 16.sp),
                              ),
                            ],
                          ),
                        );
                      }),

                      Row(
                        children: [
                          /// Current User Avatar
                          CircleAvatar(
                            radius: 18.r,
                            backgroundColor: const Color(0xFFE0F2F1),
                            backgroundImage: StorageServices.instance.getProfileImage().isNotEmpty
                                ? NetworkImage(StorageServices.instance.getProfileImage())
                                : null,
                            child: StorageServices.instance.getProfileImage().isEmpty
                                ? Icon(Icons.person_rounded,
                                    color: ConstColor.primaryTeal, size: 20.sp)
                                : null,
                          ),

                          SizedBox(width: 10.w),

                          /// Input TextField
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 14.w),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF2F2F7),
                                borderRadius: BorderRadius.circular(24.r),
                              ),
                              child: TextField(
                                controller: controller.commentInputController,
                                style: TextStyle(fontSize: 13.sp, color: Colors.black87),
                                decoration: InputDecoration(
                                  hintText: "Add a comment...",
                                  hintStyle: TextStyle(fontSize: 13.sp, color: const Color(0xFF8E8E93)),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(vertical: 10.h),
                                ),
                              ),
                            ),
                          ),

                          SizedBox(width: 8.w),

                          /// Send Button
                          GestureDetector(
                            onTap: () {
                              if (controller.editingComment.value != null) {
                                controller.updateComment(postId: postId, postType: postType);
                              } else if (controller.replyingToComment.value != null) {
                                final replyingTo = controller.replyingToComment.value!;
                                controller.postReply(replyingTo.id, postId, postType);
                              } else {
                                controller.postComment(postId, postType);
                              }
                            },
                            child: Container(
                              width: 40.r,
                              height: 40.r,
                              decoration: const BoxDecoration(
                                color: ConstColor.primaryTeal,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.send_rounded,
                                  color: Colors.white,
                                  size: 18.sp,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
