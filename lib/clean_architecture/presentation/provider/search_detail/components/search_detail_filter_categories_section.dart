import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:store_mundo_negocio/clean_architecture/helper/constants.dart';

class SearchDetailFilterCategoriesSection extends StatelessWidget {
  const SearchDetailFilterCategoriesSection({
    Key? key,
    required this.valueListenable,
    required this.onTap,
  }) : super(key: key);

  final ValueListenable valueListenable;
  final Function(int index) onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: SizedBox(
        width: double.infinity,
        child: ValueListenableBuilder(
          valueListenable: valueListenable,
          builder: (_, dynamic categories, __) {
            return Wrap(
              runSpacing: 9.0,
              spacing: 9.0,
              children: List.generate(
                categories.length,
                (index) {
                  final category = categories[index];
                  final defaultColor = category.checked!
                      ? kPrimaryColor.withOpacity(0.10)
                      : kBackGroundColor;

                  final defaultBorderColor =
                      category.checked! ? kPrimaryColor :kBackGroundColor;

                  final fontColor =
                      category.checked! ? kPrimaryColor : Colors.black;

                  return Opacity(
                    opacity: category.checked! ? 1 : 0.45,
                    child: Material(
                      color: defaultColor,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: defaultBorderColor, width: 1.5),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      clipBehavior: Clip.hardEdge,
                      elevation: 0,
                      child: InkWell(
                        onTap: () => onTap(index),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(
                            category.name!,
                            style: TextStyle(color: fontColor),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
