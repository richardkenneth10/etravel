import 'package:etravel/config/app_colors.dart';
import 'package:etravel/config/routes.dart';
import 'package:etravel/services/user_data_service.dart';
import 'package:etravel/widgets/etravel_avatar.dart';
import 'package:etravel/widgets/etravel_nav_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ETravelNavDrawer extends StatelessWidget {
  const ETravelNavDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Get.find<UserDataService>().currentUser;

    return Drawer(
      backgroundColor: Colors.white,
      child: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: SafeArea(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      height: 70,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 10,
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 60,
                            height: 60,
                            child: ETravelAvatar(image: user?.image),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  user?.displayName ?? '',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'Edit profile',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 14,
                                      color: AppColors.grey),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(
                    height: 1,
                    color: AppColors.grey.withOpacity(0.5),
                  ),
                  ETravelNavItem(
                    title: 'Payment',
                    icon: Icons.payment_rounded,
                    onTap: () {
                      Get.back();
                      Get.toNamed(Routes.paymentScreen);
                    },
                  ),
                  ETravelNavItem(
                    title: 'Promotions',
                    desc: 'Enter promo code',
                    icon: Icons.bookmark_border,
                    onTap: () {},
                    trailing: Container(
                      height: 25,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Text(
                          'NEW',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                  ETravelNavItem(
                    title: 'My Rides',
                    icon: Icons.punch_clock_outlined,
                    onTap: () {},
                  ),
                  ETravelNavItem(
                    title: 'Work Rides',
                    icon: Icons.badge,
                    onTap: () {},
                  ),
                  ETravelNavItem(
                    title: 'Support',
                    icon: Icons.message_outlined,
                    onTap: () {},
                  ),
                  ETravelNavItem(
                    title: 'About',
                    icon: Icons.info_outline,
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
