<div align='center'><h2>Ruby Implementation Best Practice (Still in the middle of writing)</h2></div>

**This document assumes that the readers already have reasonable knowledge about the following things:**
  - Basic concepts of Object Oriented Programming: Encapsulation, Inheritance, Polymorphism.
  - Ruby programming language's basic components such as keywords, data types, operators, programming flow controls.
  - Good Ruby naming conventions and how to name classes, modules, methods, constants, variables meaningfully.

This document is not a full complete list about all the Ruby best practices. It requires a book.<br/>
This document is rather a reference to common implementation situations with common best practices.

Developers are encouraged to read more in Ruby books, more detailed documents after they finish with this document and can apply its main principles to their work. 

####**__I. Method implementation__**
1. Basic method definitions

  Methods that receive no parameter: Do not use ( ) at the end of method names.
  ```ruby
  def some_method
    # Do something
  end
  ```

  Methods that receive one parameter: Many developers like the idea of using a space between method name and single parameter. But using the ( ) is clearer.
  ```ruby
  def some_method(one_parameter)
    # Do something
  end
  ```

  Methods that receive many parameters: Use ( )
  ```ruby
  def some_method(parameter_1, parameter_2, parameter_3)
    # Do something
  end
  ```

  Ruby also allows methods to reveive arbitrary numbers of parameters. Use ( )
  ```ruby
  def some_method(*parameters)
    # Do something
  end
  ```

  **Additional read:**
   - Methods that receive parameters with default values.
   - Statement 'alias'.
   - Statement 'undef'.

   **Note:** When you write a method that receives too many parameters, consider about using a Hash or a Struct or an object instead.

2. Early Return principle

  Avoid if-else if there is simple condition that allows early exit

  Avoid nested if-else

3. Break down long methods
  Break down repetitive code

  Break down common functionalities

  Break down with naming conventions to dynamically process conditional branches

4. Use loop and dynamic programming to avoid repetitive code

####**__II. Logging__**

When to log
Where to log
How to log
What to log

####**__III. Exception handling__**
Two different types of exceptions: Recoverable and Non-recoverable
(including when Recoveable exceptions become Non-recoverable exceptions)

Differences between Business Errors and System Errors 

####**__VI. Test coverage__**
