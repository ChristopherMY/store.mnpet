import 'package:flutter/material.dart';
import 'package:store_mundo_pet/clean_architecture/helper/constants.dart';

class SortOption extends StatelessWidget {
  const SortOption({
    Key? key,
    this.isChecked = false,
    required this.title,
    required this.onChange,
  }) : super(key: key);

  final VoidCallback onChange;
  final bool isChecked;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isChecked ? kPrimaryColor : Colors.white,
      child: InkWell(
        onTap: onChange,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 4.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 18.0,
                      color: isChecked ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    isChecked ? Icons.sort_by_alpha : Icons.sort_by_alpha_sharp,
                  ),
                  color: isChecked ? Colors.white : Colors.black,
                  onPressed: () {},
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
