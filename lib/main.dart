import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() => runApp(CalculatorApp());

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculator',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: CalculatorHomePage(),
    );
  }
}

class CalculatorHomePage extends StatefulWidget {
  @override
  _CalculatorHomePageState createState() => _CalculatorHomePageState();
}

class _CalculatorHomePageState extends State<CalculatorHomePage> {
  String output = "0";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculator'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(20),
            alignment: Alignment.centerRight,
            child: Text(
              output,
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Divider(),
          Column(
            children: [
              _buildButtonRow(['7', '8', '9', '/']),
              _buildButtonRow(['4', '5', '6', '*']),
              _buildButtonRow(['1', '2', '3', '-']),
              _buildButtonRow(['.', '0', '00', '+']),
              _buildButtonRow(['CLEAR', '=']),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildButtonRow(List<String> buttons) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: buttons.map((buttonText) {
        return _buildButton(buttonText);
      }).toList(),
    );
  }

  Widget _buildButton(String buttonText) {
    return Expanded(
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.all(25.0),
          side: BorderSide(
            width: 2.0,
            color: Colors.grey,
          ),
        ),
        child: Text(
          buttonText,
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: () => _buttonPressed(buttonText),
      ),
    );
  }

  void _buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == "CLEAR") {
        output = "0";
      } else if (buttonText == "=") {
        try {
          String expressionString =
              output.replaceAll('×', '*').replaceAll('÷', '/');
          double result = _evaluateExpression(expressionString);
          if (result.isNaN) {
            output = "Error";
          } else {
            output = result.toString();
          }
        } catch (e) {
          output = "Error";
        }
      } else {
        if (output == "0") {
          output = buttonText;
        } else {
          output += buttonText;
        }
      }
    });
  }

  double _evaluateExpression(String expression) {
    try {
      // Create a parser and parse the expression
      Parser parser = Parser();
      Expression exp = parser.parse(expression);

      // Create an evaluator and evaluate the expression
      ContextModel contextModel = ContextModel();
      double result = exp.evaluate(EvaluationType.REAL, contextModel);

      return result;
    } catch (e) {
      // Handle errors
      return double.nan;
    }
  }
}
