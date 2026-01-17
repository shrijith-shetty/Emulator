// import 'package:emulator/Calculator/Calculator.dart'
import 'package:emulator/main.dart';

import 'indainformat.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'calculation.dart';

class Calculator extends StatefulWidget
{
    const Calculator({super.key, required this.title});

    final String title;

    @override
    State<Calculator> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Calculator>
{
    final FocusNode keyboardFocus = FocusNode();
    final FocusNode textFieldFocus = FocusNode();
    final ScrollController textScrollController = ScrollController();
    int openBracket = 0;
    int closedBracket = 0;
    int operatorCount = 0;
    int noDot = 0;
    TextEditingController controller = TextEditingController();
    String display = "";
    String lastString = "";
    String lastCharacter = "";
    String str = "";
    bool isDot = false;
    bool isEntered = false;

    @override
    void initState()
    {
        super.initState();
        WidgetsBinding.instance.addPostFrameCallback((_)
            {
                textFieldFocus.requestFocus();
            });

        controller.addListener(()
            {
                WidgetsBinding.instance.addPostFrameCallback((_)
                    {
                        if (textScrollController.hasClients)
                        {
                            textScrollController.jumpTo(textScrollController.position.maxScrollExtent);
                        }
                    });
            });
    }
    @override
    void dispose()
    {
        controller.dispose();
        keyboardFocus.dispose();
        textFieldFocus.dispose();
        textScrollController.dispose();
        super.dispose();
    }
    @override
    Widget build(BuildContext context)
    {
        bool isPortrait =
            MediaQuery.of(context).orientation == Orientation.portrait;
        return Scaffold(

            appBar: AppBar(

                backgroundColor: CupertinoColors.black,
                title: Center(child: Text("Calculator", style: TextStyle(color: Colors.orange, fontSize: isPortrait ? 30.sp : 20.sp))),
                centerTitle: true

            ),
            body: RawKeyboardListener(focusNode: keyboardFocus,
                autofocus: false,

                onKey: (event)
                {
                    if (event is! RawKeyDownEvent || event.repeat) return;
                    final limitedOperator =
                        {
                            (LogicalKeyboardKey.asterisk),
                            (LogicalKeyboardKey.slash),
                            (LogicalKeyboardKey.add),
                            (LogicalKeyboardKey.minus),
                            (LogicalKeyboardKey.parenthesisLeft),
                            (LogicalKeyboardKey.parenthesisRight)

                        };

                    final operators =
                        {
                            (LogicalKeyboardKey.digit0),
                            (LogicalKeyboardKey.digit1),
                            (LogicalKeyboardKey.digit2),
                            (LogicalKeyboardKey.digit3),
                            (LogicalKeyboardKey.digit4),
                            (LogicalKeyboardKey.digit5),
                            (LogicalKeyboardKey.digit6),
                            (LogicalKeyboardKey.digit7),
                            (LogicalKeyboardKey.digit8),
                            (LogicalKeyboardKey.digit9)
                        };
                    if (isEntered && (limitedOperator.contains(event.logicalKey) || operators.contains(event.logicalKey)))
                    {
                        display = "";
                        lastString += event.logicalKey.keyLabel;
                        controller.text = lastString;
                        isEntered = false;
                    }

                    else if (event.isKeyPressed(LogicalKeyboardKey.enter) || event.isKeyPressed(LogicalKeyboardKey.equal))
                    {
                        if (isEntered)
                        {
                            WidgetsBinding.instance.addPostFrameCallback((_)
                                {
                                    textFieldFocus.requestFocus();
                                });
                            return;
                        }
                        _display("=");
                        isEntered = true;
                    }

                    WidgetsBinding.instance.addPostFrameCallback((_)
                        {
                            textFieldFocus.requestFocus();
                        });

                },
                child: OrientationLayout(
                    portrait: portrait(),
                    landscape: landScape()
                )

            )
        );
    }

    void _display(String text)
    {
        if (display.isNotEmpty && RegExp(r'[()0-9+-/×]').hasMatch(text))
        {
            if (display == "Error")
            {
                display = "";
            }
            else
            {
                controller.text = lastString;
                display = "";
            }
        }

        if (text == "C")
        {
            display = "";
            controller.clear();
            lastString = "";
            openBracket = 0;
            closedBracket = 0;
            operatorCount = 0;
            noDot = 0;
            lastCharacter = "";
            setState(()
                {});

        }
        else if (text == "←")
        {
            if (controller.text.isNotEmpty)
            {
                final text = controller.text;
                if (text.isNotEmpty && text.endsWith('.'))
                {
                    noDot--;
                }if (text.isNotEmpty && text.endsWith('('))
                {
                    openBracket--;
                }if (text.endsWith(')'))
                {
                    closedBracket--;
                }if (str.isNotEmpty && RegExp(r'[+\-×/]').hasMatch(str[str.length - 1]))
                {
                    operatorCount--;
                }

                controller.text =
                controller.text.substring(0, controller.text.length - 1);
            }
        }
        else if (text == '=')
        {
            while (openBracket > closedBracket)
            {
                controller.text += ')';
                closedBracket++;
            }
            while (lastCharacter == '(')
            {
                controller.text = controller.text.substring(0, controller.text.length - 1);
                lastCharacter = controller.text[controller.text.length - 1];
            }
            display = calculation(controller.text);
            lastString = display;
            isDot = false;
            if (noDot > 0)
            {
                noDot = 1;
            }
            if (openBracket > 0)
            {
                openBracket = 0;
                closedBracket = 0;
            }
            operatorCount = 0;

        }
        else
        {
            if (RegExp(r'[+×/.]').hasMatch(text) && RegExp(r'[×/+.–-]').hasMatch(lastCharacter) || ((lastCharacter == "(" ) && (text == ')' || RegExp(r'[+\-/×]').hasMatch(lastCharacter))))
            {
                if (((lastCharacter == '(' || str.endsWith('-')) && ( text == ')' || text == '/' || text == '×' || text == '+')))
                {
                    return;
                } else
                {
                    controller.text =
                    controller.text.substring(0, controller.text.length - 1);
                    controller.text += text;
                }
            }
            else if (text == '(')
            {
                if (str.isNotEmpty && !(str[str.length - 1] == '(' && ( text == '(')))
                {
                    operatorCount++;
                }

                controller.text += text;
                openBracket++;
                isDot = false;
            }
            else if (text == ')')
            {
                if ((lastCharacter == '+' || lastCharacter == '-' || lastCharacter == '×' || lastCharacter == '/') && text == ')')
                {
                    return;
                }
                if (!(openBracket > closedBracket))
                {
                    return;
                }

                closedBracket++;
                controller.text += text;
                isDot = false;

            }
            else
            {
                if (RegExp(r'[+–/×]').hasMatch(text))
                {
                    operatorCount++;
                    isDot = false;
                }
                if (text == '.' && !isDot)
                {

                    isDot = true;
                    controller.text += text;
                    noDot++;
                } else if (text != '.' && text != ')' && text != '(')
                {
                    if (((lastCharacter == '(' || str.endsWith('-')) && (/*text ==')'||*/ text == '/' || text == '×' || text == '+')))
                    {
                        return;
                    }

                    if (text == '–')
                    {
                        controller.text += '-';
                    } else
                    {
                        controller.text += text;
                    }
                }
            }
        }

        str = controller.text;

        if (str.isNotEmpty)
        {
            lastCharacter = str[str.length - 1];
        }

        // final oldSelection = controller.selection;
        controller.text = indianFormat(controller.text);
        controller.selection = TextSelection.collapsed(
            offset: controller.text.length
        );

        if (display.isNotEmpty)
        {

            String str = calculation(controller.text.replaceAll(',', ''));
            display = indianFormat(str);
        }

        setState(()
            {});

    }

    Widget buttonText(String text, {Widget? icon})
    {
        final double size;
        bool isPortrait =
            MediaQuery.of(context).orientation == Orientation.portrait;
        size = isPortrait ? 78.r : 70.r;

        return Container(

            width: isPortrait ? size : size * 3.9,
            height: size,
            decoration: BoxDecoration(
                color: buttonColor(text),

                shape: isPortrait ? BoxShape.circle : BoxShape.rectangle,
                borderRadius: isPortrait ? null : BorderRadius.circular(20)
            ),
            child: InkWell(onTap: () => _display(text),
                child: Center(
                    child: icon ?? Text(text, style: TextStyle(
                                fontSize: isPortrait ? 40.sp : 11.sp,
                                color: CupertinoColors.black,
                                fontWeight: FontWeight.bold
                            )
                        )
                )
            )
        );
    }

    Color buttonColor(String text)
    {
        if (text == 'C') return Colors.grey.shade50;
        if (text == '=') return Colors.grey.shade50;
        if (text == '←') return const Color(0xffFBA526);
        if (text == '(' || text == ')') return Colors.grey.shade50;

        if (RegExp(r'[/×–+]').hasMatch(text))
        {
            return const Color(0xffFBA526);
        }

        return const Color(0xffA5A5A5);
    }

    Widget portrait()
    {
        return Container(
            color: CupertinoColors.black,
            child: Column(
                children: [

                    SizedBox(
                        height: 85.h,
                        width: double.infinity,

                        child: Padding(
                            padding: const EdgeInsets.only(top: 50),

                            child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                reverse: true,

                                child: Text(
                                    display,
                                    textAlign: TextAlign.right,
                                    style: TextStyle(

                                        fontSize: 30.sp,
                                        color: Colors.orange
                                    )
                                )
                            )
                        )
                    ),
                    Container(
                        color: Colors.black,
                        height: 100.h,
                        width: double.infinity,
                        child: TextField(
                            enabled: false,
                            controller: controller,
                            focusNode: textFieldFocus,
                            scrollController: textScrollController,
                            inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp(r'[0-9×/()\-+.]'))
                            ],
                            maxLines: 1,
                            textAlign: TextAlign.right,
                            textDirection: TextDirection.ltr,
                            cursorColor: Colors.orange,
                            cursorWidth: 3.h,
                            style: TextStyle(
                                fontSize: 35.sp,
                                color: Colors.orange,
                                height: 1.2.h
                            ),
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                filled: true,
                                fillColor: CupertinoColors.black,
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(horizontal: 10.r, vertical: 10.r)
                            )
                        )
                    ),
                    Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Wrap(
                            runSpacing: 20.r,
                            children: [

                                Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                        buttonText("C"),
                                        buttonText("("),
                                        buttonText(")"),
                                        buttonText("←", icon: Icon(Icons.backspace))
                                    ]
                                ),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                        buttonText("7"),
                                        buttonText("8"),
                                        buttonText("9"),
                                        buttonText("/")
                                    ]
                                ),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                        buttonText("4"),
                                        buttonText("5"),
                                        buttonText("6"),
                                        buttonText("×")
                                    ]
                                ),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                        buttonText("1"),
                                        buttonText("2"),
                                        buttonText("3"),
                                        buttonText("–")
                                    ]
                                ),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,

                                    children: [
                                        buttonText("0"),
                                        buttonText("."),
                                        buttonText("="),
                                        buttonText("+")
                                    ]
                                )
                            ]
                        )
                    )
                ]
            )
        );
    }

    Widget landScape()
    {
        return Container(
            color: CupertinoColors.black,
            child: Column(
                children: [

                    SizedBox(

                        height: 100.h,
                        width: double.infinity,

                        child: Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                reverse: true,
                                child: Text(
                                    display,
                                    textAlign: TextAlign.right,
                                    style: TextStyle(

                                        fontSize: 13.sp,
                                        color: Colors.orange
                                    )
                                )
                            )
                        )
                    ),
                    Container(
                        color: Colors.black,
                        height: 100.h,
                        width: double.infinity,
                        child: TextField(
                            keyboardType: TextInputType.none,
                            controller: controller,
                            focusNode: textFieldFocus,
                            scrollController: textScrollController,
                            inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp(r'[0-9×/()\-+.]'))
                            ],
                            autofocus: true,
                            maxLines: 1,
                            scrollPhysics: const ClampingScrollPhysics(),
                            enableInteractiveSelection: true,
                            textDirection: TextDirection.ltr,
                            textAlign: TextAlign.right,
                            cursorColor: Colors.orange,
                            cursorWidth: 3.h,
                            style: TextStyle(
                                fontSize: 18.sp,
                                color: Colors.orange,
                                height: 1.2.h
                            ),
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                filled: true,
                                fillColor: CupertinoColors.black,
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(horizontal: 10.r, vertical: 10.r)
                            )
                        )
                    ),

                    Expanded(
                        child: Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: SizedBox(
                                width: 800.w,
                                child: Wrap(
                                    runSpacing: 10.r,
                                    children: [

                                        Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                                buttonText("7"),
                                                buttonText("8"),
                                                buttonText("9"),
                                                buttonText("/"),
                                                buttonText("C")

                                            ]
                                        ),
                                        Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                                buttonText("4"),
                                                buttonText("5"),
                                                buttonText("6"),
                                                buttonText("×"),
                                                buttonText("(")

                                            ]
                                        ),
                                        Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                                buttonText("1"),
                                                buttonText("2"),
                                                buttonText("3"),
                                                buttonText("–"),
                                                buttonText(")")

                                            ]
                                        ),
                                        Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                                            children: [
                                                buttonText("0"),
                                                buttonText("."),
                                                buttonText("="),
                                                buttonText("+"),
                                                buttonText("←", icon: Icon(Icons.backspace)
                                                )
                                            ]
                                        )
                                    ]
                                )
                            )
                        )
                    )
                ]
            )
        );
    }
}

class OrientationLayout extends StatelessWidget
{
    const OrientationLayout({super.key, required this.portrait, required this.landscape});

    final Widget portrait;
    final Widget landscape;

    @override
    Widget build(BuildContext context)
    {

        return OrientationBuilder(builder: (context, orientation)
            {
                return orientation == Orientation.portrait ?
                    portrait :
                    landscape;
            }
        );
    }
}