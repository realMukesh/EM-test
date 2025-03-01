import 'package:english_madhyam/routes/my_constant.dart';
import 'package:english_madhyam/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html_table/flutter_html_table.dart';
import 'package:google_fonts/google_fonts.dart';
class QuestionWidget extends StatefulWidget {
  final String questionString;
  const QuestionWidget({required this.questionString,Key?key});

  @override
  State<QuestionWidget> createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Padding(
          padding:  EdgeInsets.symmetric(vertical: 10.adaptSize),
          child: SingleChildScrollView(
            child: Html(
              data: widget.questionString,
              // data: htmlString,
              extensions: const [TableHtmlExtension()],
              style: {
                "body":Style(
                  fontSize: FontSize(14.0,),fontFamily: GoogleFonts.poppins().fontFamily,
                ),
                "table": Style(
                    height: Height.auto(),
                    width: Width.auto(),fontFamily: GoogleFonts.poppins().fontFamily,
                    backgroundColor: Colors.purple.withOpacity(0.1)
                ),
                // some other granular customizations are also possible

                "tr": Style(
                  height: Height.auto(),
                  width: Width.auto(),
                  border:
                  Border(bottom: BorderSide(color: Colors.grey)),
                ),
                "th": Style(
                  padding: HtmlPaddings.all(6),
                  height: Height.auto(),
                  border: const Border(
                    left: BorderSide(color: Colors.black, width: 0.5),
                    bottom: BorderSide(color: Colors.black, width: 0.5),
                    top: BorderSide(color: Colors.black, width: 0.5),
                  ),
                ),
                "td": Style(
                  padding: HtmlPaddings.all(6),
                  height: Height.auto(),
                  border: const Border(
                    left: BorderSide(color: Colors.black, width: 0.5),
                    bottom: BorderSide(color: Colors.black, width: 0.5),
                    top: BorderSide(color: Colors.black, width: 0.5),
                    right: BorderSide(color: Colors.black, width: 0.5),
                  ),
                ),
                "col": Style(
                  height: Height.auto(),
                  width: Width.auto(),
                ),
                "p": Style(fontSize: FontSize(16.0,),fontFamily: GoogleFonts.poppins().fontFamily,)
              },
            ),
          )),

    );
  }
}
