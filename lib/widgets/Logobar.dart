import 'package:flutter/material.dart';

class Logobar extends StatelessWidget implements PreferredSizeWidget {
  const Logobar({
    super.key,
  });

  @override
  Size get preferredSize =>
      const Size.fromHeight(kToolbarHeight); // 기본 AppBar 높이

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return AppBar(
      leading: GestureDetector(
        child: Row(
          children: [
            Image.asset(
              'lib/assets/images/appbar_logo.png',
              width: screenSize.width * 0.4,
              height: screenSize.height * 0.05,
            ),
          ],
        ),
        onTap: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
