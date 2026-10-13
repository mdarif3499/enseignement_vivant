import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:enseignement_vivant/constant/app_const_string.dart';

class NotificationItem {
  final String titleKey;
  final String subtitleKey;
  final String time;
  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;

  NotificationItem({
    required this.titleKey,
    required this.subtitleKey,
    required this.time,
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
  });
}

class NotificationsController extends GetxController {
  final RxList<NotificationItem> notifications = <NotificationItem>[
    NotificationItem(
      titleKey: ConstString.bookingConfirmation,
      subtitleKey: ConstString.bookingConfirmedDesc,
      time: '8:20 AM',
      icon: Icons.apartment_rounded,
      iconBgColor: const Color(0xFFF3E5F5),
      iconColor: const Color(0xFF7B1FA2),
    ),
    NotificationItem(
      titleKey: ConstString.paymentSuccessful,
      subtitleKey: ConstString.paymentDoneDesc,
      time: '8:20 AM',
      icon: Icons.account_balance_wallet_rounded,
      iconBgColor: const Color(0xFFE1F5FE),
      iconColor: const Color(0xFF0288D1),
    ),
    NotificationItem(
      titleKey: ConstString.enjoy30Off,
      subtitleKey: ConstString.enjoy30OffDesc,
      time: '8:20 AM',
      icon: Icons.campaign_rounded,
      iconBgColor: const Color(0xFFFFF8E1),
      iconColor: const Color(0xFFFBC02D),
    ),
    NotificationItem(
      titleKey: ConstString.santaMariaMessage,
      subtitleKey: ConstString.enjoy30OffDesc,
      time: '8:20 AM',
      icon: Icons.chat_bubble_rounded,
      iconBgColor: const Color(0xFFEDE7F6),
      iconColor: const Color(0xFF512DA8),
    ),
  ].obs;
}
