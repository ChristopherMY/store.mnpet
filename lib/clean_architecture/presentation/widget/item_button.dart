import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ItemButton extends StatelessWidget {
  const ItemButton({
    Key? key,
    required this.title,
    required this.press,
    required this.icon,
  }) : super(key: key);

  final String title;
  final VoidCallback press;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: Container(
        decoration:  const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.black, width: 1),
          ),
        ),
        child: InkWell(
          onTap: press,
          child: Padding(
            padding: const EdgeInsets.only(
                top: 12.0, right: 0.0, bottom: 12.0, left: 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon),
                const SizedBox(width: 10.0),
                Text(
                  title,
                  style: const TextStyle(fontSize: 16.0),
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
