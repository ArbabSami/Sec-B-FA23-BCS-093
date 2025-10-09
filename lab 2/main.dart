import 'package:flutter/material.dart';

void main() => runApp(CalculatorApp());

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Calculator(),
    );
  }
}

class Calculator extends StatefulWidget {
  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String display = '0';
  double previous = 0;
  String operation = '';

  void buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == 'C') {
        display = '0';
        previous = 0;
        operation = '';
      } else if (buttonText == '+' || buttonText == '-' || buttonText == '*' || buttonText == '/') {
        previous = double.parse(display);
        operation = buttonText;
        display = '0';
      } else if (buttonText == '=') {
        double current = double.parse(display);
        switch (operation) {
          case '+':
            display = (previous + current).toString();
            break;
          case '-':
            display = (previous - current).toString();
            break;
          case '*':
            display = (previous * current).toString();
            break;
          case '/':
            display = (previous / current).toString();
            break;
        }
        operation = '';
      } else {
        if (display == '0') {
          display = buttonText;
        } else {
          display += buttonText;
        }
      }
    });
  }

  Widget buildButton(String buttonText) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () => buttonPressed(buttonText),
        child: Text(buttonText, style: TextStyle(fontSize: 20)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Calculator')),
      body: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.symmetric(vertical: 24, horizontal: 12),
            child: Text(display, style: TextStyle(fontSize: 48)),
          ),
          Expanded(
            child: Divider(),
          ),
          Column(
            children: [
              Row(children: [buildButton('7'), buildButton('8'), buildButton('9'), buildButton('/')]),
              Row(children: [buildButton('4'), buildButton('5'), buildButton('6'), buildButton('*')]),
              Row(children: [buildButton('1'), buildButton('2'), buildButton('3'), buildButton('-')]),
              Row(children: [buildButton('.'), buildButton('0'), buildButton('00'), buildButton('+')]),
              Row(children: [buildButton('C'), Expanded(flex: 3, child: ElevatedButton(onPressed: () => buttonPressed('='), child: Text('=', style: TextStyle(fontSize: 20))))]),
            ],
          ),
        ],
      ),
    );
  }
}
