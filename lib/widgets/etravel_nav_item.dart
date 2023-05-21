import 'package:etravel/config/app_colors.dart';
import 'package:flutter/material.dart';

class ETravelNavItem extends StatelessWidget {
  const ETravelNavItem(
      {Key? key,
      required this.title,
      required this.icon,
      this.desc,
      this.trailing,
      required this.onTap})
      : super(key: key);

  final String title;
  final IconData icon;
  final String? desc;
  final Widget? trailing;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                  if (desc != null) ...[
                    const SizedBox(height: 5),
                    Text(
                      desc!,
                      style: TextStyle(
                        color: AppColors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}
