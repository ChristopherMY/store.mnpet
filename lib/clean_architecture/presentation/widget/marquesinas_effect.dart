import 'package:flutter/material.dart';

class MarquesinasEffect extends StatefulWidget {
  const MarquesinasEffect({Key? key, required this.titles}) : super(key: key);

  final List<String> titles;

  @override
  State<MarquesinasEffect> createState() => _MarquesinasEffectState();
}

class _MarquesinasEffectState extends State<MarquesinasEffect> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final maxExtend = _scrollController.position.maxScrollExtent;

      _scrollController.animateTo(
        maxExtend,
        duration: const Duration(seconds: 5),
        curve: Curves.linear,
      );
    });

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          widget.titles.length,
              (index) => Padding(
            padding: const EdgeInsets.only(right: 5.0),
            child: Center(
              child: Text(
                widget.titles[index],
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}