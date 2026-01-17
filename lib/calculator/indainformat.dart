String indianFormat(String text)
{
  String input = "";
  for (int i = 0; i < text.length; i++)
  {
    if (text[i] != ',')
    {
      input += text[i];
    }
  }
  text = input;
  if (text.length < 4)
  {
    return text;
  }
  List<String> values = [];
  int index = 0;
  String subStr = "";
  for (int i = 0; i < text.length; i++)
  {
    if (RegExp(r'[0-9]').hasMatch(text[i]))
    {
      subStr += text[i];
    }
    else if (text[i] == '.')
    {
      if (subStr.isEmpty)
      {
        continue;
      }
      values.insert(index++, subStr);
      subStr = "";
      subStr += text[i];
    }
    else if (RegExp(r'[+-/×()]').hasMatch(text[i]))
    {

      if (subStr.isEmpty)
      {
        values.insert(index++, text[i]);
      } else
      {
        values.insert(index++, subStr);
        subStr = "";
        values.insert(index++, text[i]);
      }
    }
    else
    {

      if (subStr.isEmpty)
      {
        continue;
      }
      values.insert(index++, subStr);
      subStr = "";
    }
  }
  if (subStr.isNotEmpty)
  {
    values.insert(index++, subStr);
  }
  for (int i = 0; i < values.length; i++)
  {
    if (values[i] == '.' || RegExp(r'[+-/×()]').hasMatch(values[i]))
    {
      values[i] = values[i];
      continue;
    }

    values[i] = putComa(values[i]);
  }
  text = "";
  for (int i = 0; i < values.length; i++)
  {
    text += values[i];
  }
  return text;
}

String putComa(String text)
{
  var input = text.split('');
  text = input.reversed.join();

  String result = "";
  // int n = text.length;
  bool third = false;
  for (int i = 0; i < text.length; i++)
  {
    if (i > 2)
    {
      if (!third)
      {
        result += ',';
        third = true;
      }
      else if (third && i % 2 != 0)
      {
        result += ',';
      }
    }
    result += text[i];
  }
  input = result.split('');
  text = input.reversed.join();
  return text;

}