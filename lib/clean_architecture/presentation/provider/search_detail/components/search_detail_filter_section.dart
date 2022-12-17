import 'package:flutter/material.dart';

class SearchDetailFilterSection extends StatelessWidget {
  const SearchDetailFilterSection({
    Key? key,
    required this.title,
    required this.child,
    this.hasOptionHeader = false,
    this.onTap,
    this.defaultBackground = Colors.white,
  }) : super(key: key);

  final String title;
  final Widget child;
  final bool? hasOptionHeader;
  final Color defaultBackground;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                if (hasOptionHeader!)
                  GestureDetector(
                    onTap: onTap,
                    child: const Icon(
                      Icons.arrow_forward_ios_outlined,
                      size: 18.0,
                    ),
                  )
              ],
            ),
          ),
          const SizedBox(height: 15.0),
          Container(
            color: defaultBackground,
            child: child,
          )
        ],
      ),
    );
  }
}
