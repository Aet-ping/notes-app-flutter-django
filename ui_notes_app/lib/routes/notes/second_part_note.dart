import 'package:ui_notes_app/services/notes_data.dart';
import 'package:flutter/material.dart';

class SecondPartNote extends StatefulWidget {
  SecondPartNote(
      {super.key,
      required this.content,
      required this.id,
      required this.title,
      required this.actions});
  String actions;
  String id;
  String content;
  String title;
  @override
  State<SecondPartNote> createState() => _SecondPartNoteState();
}

class _SecondPartNoteState extends State<SecondPartNote> {
  Future<void> test() {
    if (widget.actions == "createNote") {
      return createNote(
          _modTitle?.text != null
              ? _modTitle!.text.toString()
              : "Default Value",
          _modContent?.text != null
              ? _modContent!.text.toString()
              : "Default Value");
    } else {
      return updateNote(
          _modTitle?.text != null
              ? _modTitle!.text.toString()
              : "Default Value",
          _modContent?.text != null
              ? _modContent!.text.toString()
              : "Default Value",
          int.parse(widget.id));
    }
  }

  String? contents;
  TextEditingController? _modContent;
  TextEditingController? _modTitle;
  bool _isButtonDisabled = false;

  @override
  void initState() {
    super.initState();
    contents = widget.content;
    _modContent = TextEditingController(
      text: contents,
    );
    _modTitle = TextEditingController(text: widget.title);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_left),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            IconButton(
              onPressed: _isButtonDisabled
                  ? null
                  : () {
                      setState(() {
                        _isButtonDisabled = true;
                      });

                      test();

                      ScaffoldMessenger.of(context)
                          .showSnackBar(
                            SnackBar(
                              content: Text('Note succesfuly save!'),
                              duration: Duration(seconds: 2),
                            ),
                          )
                          .closed
                          .then((_) {
                        setState(() {
                          _isButtonDisabled = false;
                        });
                      });
                    },
              icon: Icon(Icons.archive),
            )
          ],
          title: TextField(
            controller: _modTitle,
            maxLines: 1,
            maxLength: 15,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              border: InputBorder.none,
              counterText: '',
            ),
          ),
        ),
        body: SingleChildScrollView(
            child: Container(
          margin: EdgeInsets.all(30),
          height: 400,
          child: TextField(
            controller: _modContent,
            maxLines: null,
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "Enter your text here...",
            ),
          ),
        )));
  }
}
