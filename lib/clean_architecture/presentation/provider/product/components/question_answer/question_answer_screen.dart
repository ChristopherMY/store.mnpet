import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:store_mundo_pet/clean_architecture/helper/constants.dart';

class QuestionAnswerScreen extends StatelessWidget {
  static String routeName = "/question_answer_screen";

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        bottomOpacity: 0.0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close),
          color: Colors.white,
        ),
        backgroundColor: Colors.black,
        title: Text("Lista de preguntas (14)"),
        elevation: 0.0,
      ),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 45),
            child: SingleChildScrollView(
              padding: EdgeInsets.zero,
              child: Column(
                children: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
                    .map(
                      (e) => Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 10,
                            ),
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 26,
                                      child: Image.asset(
                                        "assets/icons/other/ask_question.png",
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    const Flexible(
                                      child: Text(
                                        "¿Lorem Ipsum es simplemente el texto de relleno de las imprentas y archivos de texto?",
                                        style: TextStyle(
                                            fontSize: 13,
                                            height: 1.5,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 26,
                                      child: Image.asset(
                                        "assets/icons/other/answer.png",
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    const Text(
                                      "Clasico",
                                      style: TextStyle(fontSize: 13),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  children: const [
                                    Expanded(
                                      child: Text(
                                        "2 respuestas",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ),
                                    Text("11 Oct 2022",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ))
                                  ],
                                )
                              ],
                            ),
                          ),
                          _buildDivider()
                        ],
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ),
      ),
      bottomSheet: Container(
        constraints: BoxConstraints(
          minHeight: 55,
          maxHeight: 55,
          minWidth: double.infinity,
        ),
        decoration: BoxDecoration(
          color: kDividerColor,
          boxShadow: [
            BoxShadow(
              color: kSecondaryColor,
              blurRadius: 7.0,
              spreadRadius: 1.0,
              offset: Offset(0.0, 0.0),
            )
          ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: buildQuestionField(),
              ),
              Container(
                color: Colors.red,
                width: 90,
                height: double.maxFinite,
                padding: EdgeInsets.all(0),
                alignment: Alignment.center,
                child: Text(
                  "Preguntar".toUpperCase(),
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildDivider() {
    return Container(
      height: 10,
      color: kDividerColor,
    );
  }

  buildQuestionField() {
    return TextField(
      controller: _controller,
      style: TextStyle(
        fontWeight: FontWeight.normal,
        fontSize: 14,
      ),
      inputFormatters: [
        LengthLimitingTextInputFormatter(300),
      ],
      textInputAction: TextInputAction.newline,
      keyboardType: TextInputType.multiline,
      maxLines: null,
      expands: true,
      autocorrect: true,
      decoration: InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.fromLTRB(10.0, 15.0, 0.0, 0.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(0),
          borderSide: BorderSide(color: Colors.black, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(0),
          borderSide: BorderSide(
            color: Colors.black,
            width: 1,
          ),
        ),
        hintText: "¿Que quieres saber?",
        filled: true,
        suffixIcon: IconButton(
          padding: EdgeInsets.all(0),
          icon: Icon(CupertinoIcons.clear_circled_solid, color: Colors.black45),
          iconSize: 25,
          onPressed: () => _controller.clear(),
        ),
      ),
    );
  }
}
