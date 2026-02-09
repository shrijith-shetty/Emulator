void Calculation(String expression)
{

    List<String> stack = [];
    String digits = "";

    List<String> splitted = splitter(expression);
    List<String> postFix = [];
    for (int i = 0; i < splitted.length; i++)
    {
        // print(stack);
        if (splitted[i] != '+' && splitted[i] != '-' && splitted[i] != '*' && splitted[i] != '/' && splitted[i] != '(' && splitted[i] != ')')
        {
            postFix.add(splitted[i]);

        }
        else if (splitted[i] == '(')
        {
            stack.add(splitted[i]);
        }
        else if (splitted[i] == ')')
        {
            // print(stack);
            while (stack.isNotEmpty && stack.last != '(')
            {
                // print(stack);
                postFix.add(stack.last);
                stack.removeLast();

            }
            // if(stack.isEmpty) {
            //   // print("error");
            //   continue;
            // }
            //     stack.removeLast();

        }
        else
        {
            if (stack.isEmpty)
            {
                stack.add(splitted[i]);

            }
            else
            {
                if (splitted[i] == "*" || splitted[i] == "/")
                {

                    if (stack.last == "*" || stack.last == "/")
                    {
                        postFix.add(stack.last);

                        stack.removeLast();
                        stack.add(splitted[i]);
                    }
                    else if (stack.last == "+" || stack.last == "-")
                    {
                        stack.add(splitted[i]);
                    }
                }
                else if (splitted[i] == "+" || splitted[i] == "-")
                {

                    if (stack.last == "*" || stack.last == "/")
                    {
                        postFix.add(stack.last);
                        stack.removeLast();
                        stack.add(splitted[i]);
                    }
                    else /*if (stack.last == '+' || stack.last == '-')*/
                        {
                            if (stack.last == '(')
                            {
                                print(stack[stack.length - 1]);
                                stack.removeLast();
                                continue;
                            }
                            postFix.add(stack.last);

                            stack.removeLast();

                            stack.add(splitted[i]);
                        }

                }
                // else if(stack.last=="("){
                //     stack.add(splitted[i]);
                // }
            }
        }
    }
    while (stack.isNotEmpty)
    {
        if (stack.last == '(')
        {
            // print(stack[stack.length - 1]);
            stack.removeLast();
            continue;
        }
        postFix.add(stack.removeLast());
    }
    print(postFix);
    // for(int i=0;i<postFix.length;i++){
    //   if(postFix[i]=="+" || postFix[i]=="-" || postFix[i]=="*" || postFix[i]=="/"){
    //     if(i>=2){
    //       double? a = calculation(postFix[i-2], postFix[i-1], postFix[i]);
    //       postFix.removeAt(i);
    //       postFix.removeAt(i-1);
    //       postFix.removeAt(i-2);
    //       postFix.insert(i-2, a.toString());
    //       i=0;
    //     }
    //   }
    // }
}

List<String> splitter(String expression)
{
    List<String> splitted = [];
    String digits = "";
    for (int i = 0; i < expression.length; i++)
    {
        if (expression[i] != '+' && expression[i] != '-' && expression[i] != '*' && expression[i] != '/' && expression[i] != '=' && expression[i] != '(' && expression[i] != ')')
        {
            digits += expression[i];
        }
        else
        {
            if (digits.isNotEmpty)
            {
                splitted.add(digits);
            }
            digits = '';
            digits += expression[i];
            splitted.add(expression[i]);
            digits = '';
        }
    }
    if (digits.isNotEmpty)
    {
        splitted.add(digits);
    }

    return splitted;
}

// double? calculation(String a,String b,String c){
//   if(c=="+"){
//     return double.parse(a)+double.parse(b);
//   }
//   else if(c=="-"){
//     return double.parse(a)-double.parse(b);
//   }
//   else if(c=="*"){
//     return double.parse(a)*double.parse(b);
//   }
//   else if(c=="/"){
//     return double.parse(a)/double.parse(b);
//   }
//   return null;
// }

void main()
{
    Calculation("96/(3+1)");
}