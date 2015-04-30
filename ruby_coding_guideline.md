<div align='center'><h2>Ruby Coding Guideline</h2></div>

**This is not a book about teaching Ruby programming language, so all the statements, syntax in this guideline are written about when to use, how to use and best practices. They will not be listed in full syntax and semantics.**

####**__I. Comment__**

All classes, modules must have comments about their purposes and functionalities.<br/>
All methods must have comments about their functionalities, parameters and expected input, output<br/>
All the code blocks, paragraphs that contain complex logics must have comments about what they do, how they do the tasks, and why.

####**__II. Rule of thumb when using different types of constants and variables__**

1. Global constants:<br/>
  Use global constants to store information that (ideally) will never change.

  Be careful: In Ruby, values assigned to constants can be reassigned. So when you write code, please refrain from changing constants' values, unless you have absolutely good reason to do so.

2. Global variables<br/>

  Global variables are visible to all components (files, modules, classes, object instances) in a Ruby application.
  From within any components, developers can write code to access (read/write) global variables.

  Use global varibles to hold only the information that
    - have meanings to all the components in a Ruby application.
    - are rarely changed.

  When you use global variables, be aware of these facts:
    - Global variables can potentially be changed by any components of the system. Always be careful with side-effects.
    - When you want to change the values of global variables, you must have a mechanism in place to make sure that no other component/process/thread can change the same global variable at the same time.

  A rule of thumb: Try stay away from using global variables, except reading the ones provided by Ruby.
  When you must absolutely use global variables, please be careful with side effects, concurrent access and multi processes/threads issues.

3. Class variables<br/>
  All class variables are visible to all instances of a class. And when there is no instance of a class, you still can access the class variables via the class itself.

  See the file [**code_samples/class_variables.rb**](https://github.com/linhchauatl/ruby_code_guideline/blob/master/code_samples/class_variables.rb) for illustration about using class variables.

4. Instance variables
  The purpose of instance variables is to hold the states of instances of objects.
  You should NEVER use instance variables to communicate data between methods of an instance.

  See file [**code_samples/instance_variables.rb**](https://github.com/linhchauatl/ruby_code_guideline/blob/master/code_samples/instance_variables.rb) for illustration about how not to abuse instance variables.

  In Rails, there are certain places where they missuse the instance variables to pass data between methods in controllers, helpers and views. It was a historical mistake, and DHH (Rails creator) was not very happy about it.
  Just because we can do something, does not mean that we should necessarily do that thing.

5. Local variables
  The usage of local variables is pretty straightforward, so there is nothing much to mention here.

6. Side effect when Ruby objects are passed as parameters
  It is important to remember that in Ruby, parameters are passed into methods as references.<br/>
  It means that, with the exception of numbers and strings (they are special objects), all other types of objects, including hashes and arrays will have side effects when they are passed as parameters to a method.<br/> Their values will be changed if the method performs computations on them.

  See the file [**code_samples/parameter_side_effect.rb**](https://github.com/linhchauatl/ruby_code_guideline/blob/master/code_samples/parameter_side_effect.rb) for illustrations regarding the side effects of passing parameters into methods.

  Please Google or read books about Object#dup, Object#clone, about deep and shallow dup/clone.

####**__III. Condition checking__**

1. `if-elsif-end` statements<br/>
  Please read about different forms of "if" in a Ruby book or Ruby API docs.<br/>
  Below are some general best practices when using `if`

  - Do not use multi branches of `if-elsif-elsif .... -elsif-end` statements. For these scenarios, you should use `case-when-when ... -when-end` statements.
  - Do not nest your `if` statements too deep. If you do have to use multiple nested `if` statements, you may want to reassess your logical flows and application design.
  - Do not use multi levels of tenary condition checking.
  
  Here is a one-level tenary statement:<br/>
  `condition ? value_if_true : value_if_false`

  For example:
  ```ruby
  (size == 'L') ? 'Large' : 'Small'
  ```

  Here is two-level tenary (multi levels) <- **This MUST be avoided at all cost**:
  ```ruby
  (size == 'L')? 'Large' : ( (size == 'M')? 'Medium' : 'Small' )
  ```

  If you see yourself in this situation, write it in if-elsif-end
  ```ruby
  if size == 'L'
    size_text = 'Large'
  elsif size == 'M'
    size_text = 'Medium'
  else
    size_text = 'Small'
  end
  ```

  Or you can use `case-when-end` statements.<br/>

  But, again, in Ruby, when you see yourself using too many branches of `if-else` or you have to use `case-when`, it is most likely that there is something wrong. At this point you should think about reorganizing your logical flows, using hashes to map, externalize things to a YML file, or using dynamic programming with certain conventions.


2. `case-when-end` statments<br/>
  REPEAT: It is not 100% of the time, but in 99.99% of the time, when you have to use `case-when-end` in Ruby, there is something wrong. At this point you should think about reorganizing your logical flows, using hash to map, externalize things to YML file, or using dynamic programming with certain conventions.

  Example about bad ways and good way of checking many branches of conditions: [**code_samples/condition_checking.rb**](https://github.com/linhchauatl/ruby_code_guideline/blob/master/code_samples/condition_checking.rb)


3. Special case of checking for nil and assigning default value<br/>
  Sometimes you will want to do a check similar to this:
  ```ruby
  if passed_subject.nil?
    subject = 'Default subject'
  else
    subject = passed_subject
  end
  ```

  You can accomplish the same thing using `||`:
  ```ruby
  subject = passed_subject || 'Default subject'
  ```
4. Do not write boolean value explicitly in the "if" condition.

  Here are 2 examples:

  Example 1:
  ```ruby
  # DO NOT WRITE
  if (some_condition == true)
    # Do something
  end

  # Write this instead
  if (some_condition)
    # Do something
  end
  ```

  Example 2:
  ```ruby
  # DO NOT WRITE
  if (some_condition == false)
    # Do something
  end

  # Write this instead
  if (!some_condition)
    # Do something
  end
  ```

5. Special case of checking variables against multple values
  ```ruby
  # DO NOT WRITE
  if (variable == value_1 || variable == value_2 || variable == value_3) 
    # Do something
  end

  # Write this instead
  if ( [value_1, value_2, value_3].include?(variable) )
    # Do something
  end
  ```

6. Use `if` and `unless` wisely to express the logics clearly.<br/>
  There is no hard rules for choosing between `if` and `unless`. Use your own judment.

####**__IV. Loops__**
  In Ruby, there are many ways to write loops, and there are may formats in each way of loop.<br/>
  Therefore it is always a good idea to read thoroughly about Ruby loops at least once to have a concept about what types of loops are available and in what formats the loops can be written.

  Here are just a few of type of loops. Each of them is not even fully listed.

1. Loop N times

  ```ruby
    N.times.each { |idx| do something }

    N.times.each do |idx|
      do something line 1
      do something line 2
    end

    (0...N).each { |idx| do something }

    (0...N).each do |idx| 
      do something line 1
      do something line 2
    end

    (1..N).each { |idx| do something }

    (1..N).each do |idx| 
      do something line 1
      do something line 2
    end

    for idx in 0...N 
      do something
    end

    for idx in 1..N 
      do something
    end

    0.upto(N-1).each { |idx| do something }

    1.upto(N).each { |idx| do something }
  ```

  We also can use `while` or `until` to loop N times, but we should not do so. 

2. Loop when a condition is still true
  ```ruby
    while condition
      do something
    end

    begin 
      do something 
    end while condition
  ```

3. Loop until a condition is satisfied
  ```ruby
    until condition
      do something
    end

    begin 
      do something 
    end until condition
  ```

4. Loop through a collection
  ```ruby

    collection.each { |element| do something }

    collection.each do |element|
      do something line 1
      do something line 2
    end

    for element in collection
      do something
    end

  ```

5. Loop control:

  You should read up about: 
  ```ruby
  break
  next
  redo
  retry
  ```

6. Special case: loop with step:

  Loop through a range of N elements, step M elements at a time
  ```ruby
    (0...N).step(M).each  { |idx| do something }

    (1..N).step(M).each  { |idx| do something }
  ```

  For example: 
  ```ruby
    (0..6).step(2).each  { |idx| puts idx }

  ```

