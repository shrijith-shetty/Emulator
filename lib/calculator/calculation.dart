import 'package:decimal/decimal.dart';

String calculation(String text)
{
  String input = "";
  for (int i = 0; i < text.length; i++)
  {
    if (text[i] != ',')
    {
      input += text[i];
    }
  }
  List<String> value = postfix(input);
  String val = calculator(value);
  if (val.endsWith('.00'))
  {
    return val.substring(0, val.length - 3);
  }
  if (val != "null")
  {
    return val;
  }
  return "Error";
}

List<String> postfix(String expression)
{
  Map<String, int> map =
  {
    '+': 1,
    '-': 1,
    '×': 2,
    '/': 2,
    '^': 3
  };

  List<String> characters = [];
  List<String> exp = [];
  String number = "";

  for (int i = 0; i < expression.length; i++)
  {
    if (expression[i] == ' ') continue;

    if (expression[i] == '-' &&
        (i == 0 || '+-×/^('.contains(expression[i - 1])))
    {
      if (number.startsWith('-'))
      {
        number = number.substring(1);
      }
      else
      {
        number = '-$number';
      }
      continue;
    }

    if (['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'].contains(expression[i]) ||
        expression[i] == '.')
    {
      number += expression[i];
    }
    else
    {
      if (number.isNotEmpty)
      {
        exp.add(number);
        number = "";
      }

      if (expression[i] == '(')
      {
        if (i > 0 &&
            ('0123456789.'.contains(expression[i - 1]) ||
                expression[i - 1] == ')'))
        {
          characters.add('×');
        }
        characters.add('(');
      }
      else if (expression[i] == ')')
      {
        while (characters.isNotEmpty && characters.last != '(')
        {
          exp.add(characters.removeLast());
        }
        if (characters.isEmpty)
        {
          return [];
        }
        characters.removeLast();
      }
      else if (['+', '-', '×', '/', '^'].contains(expression[i]))
      {
        while (characters.isNotEmpty &&
            characters.last != '(' &&
            map[expression[i]]! <= map[characters.last]!)
        {
          exp.add(characters.removeLast());
        }
        characters.add(expression[i]);
      }
      else
      {
        return [];
      }
    }
  }

  if (number.isNotEmpty)
  {
    exp.add(number);
  }

  while (characters.isNotEmpty)
  {
    if (characters.last == '(')
    {
      return [];
    }
    exp.add(characters.removeLast());
  }

  return exp;
}

String calculator(List<String> expression)
{
  String output = "";
  List<String> val = [];

  for (int i = 0; i < expression.length; i++)
  {
    String token = expression[i];

    if (['+', '-', '×', '/', '^'].contains(token))
    {
      if (val.length < 2)
      {
        return "null";
      }

      Decimal num2 = Decimal.parse(val.removeLast());
      Decimal num1 = Decimal.parse(val.removeLast());
      output = simpleCalculator(num1, num2, token);

      if (output == "")
      {
        return "null";
      }

      val.add(output.toString());
    }
    else
    {
      val.add(token);
    }
  }

  if (val.isEmpty)
  {
    return "null";
  }

  return (val.last).toString();
}

String simpleCalculator(Decimal values, Decimal values2, String character)
{
  if (character == '+')
  {
    return (values + values2).toStringAsFixed(2);
  }
  else if (character == '-')
  {
    return (values - values2).toStringAsFixed(2);
  }
  else if (character == '×')
  {
    return (values * values2).toStringAsFixed(2);
  }
  else if (character == '/')
  {

    double a = (values).toDouble();
    double b = (values2).toDouble();
    if (b == 0)
    {
      return "null";
    }
    return (a / b).toStringAsFixed(2);
  }
  return "null";
}