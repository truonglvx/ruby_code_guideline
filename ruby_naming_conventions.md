<div align='center'><h2>Ruby Naming Conventions</h2></div>

####**__I. Class, Module names__**

Class and Module names in Ruby should be properly formatted using CamelCase.<br/>
Capital Letters must be used to separate words.<br/>
Names should be as descriptive as possible.<br/>

Good examples:
  ```ruby
  class Invoice
  class InvoiceService
  module OrderHelper
  ```

Bad examples:
  ```ruby
  class invoice
  module order_helper
  class invoiceService
  module orderhelper
  ```

####**__II. Constants__**

Constants in Ruby must be in UPPER_SNAKE_CASE.<br/>
Underscores must be used to separate words.<br/>

A good example:<br/>
  `SNS_MAPPING`

A bad example: <br/>
  `SNSMAPPING`

####**__III. Variables__**
All variables in Ruby must be in lower_snake_case.<br/>
Underscores must be used to separate words.<br/>

A good example:<br/>
  `sns_mapping`

A bad example: <br/>
  `snsmapping`

  __1. Global variables__<br/>
  Global variable names start with “$”.<br/>
  Global variables are available throughout the whole Ruby application. So be careful when using global variables!!!<br/>

  For example: `$months_in_year`
    
  __2. Class variables__<br/>
  Class variables names start with “@@”.<br/>
  When creating a class variable, all instances of the same class in a Ruby application will share the new class variables. Likewise, if a change is made to a class variable, all other instances will see the change too.

  __3. Instance variables__<br/>
  Instance variables names start with “@”.<br/>
  Think about instance variables as places to hold state of specific instances. As a rule of thumb, do not use instance variables as a mean to communicate data between methods within an instance, although you can do so. A better way to communicate data between methods is to pass them via parameters (unless data you want to communicate is really a state of an instance).<br/>

  __4. Local variables__<br/>
  Local variables' names must be a simple snake_case_string.<br/>

####**__IV. Method names__**
All methods in Ruby must be in lower_snake_case.<br/>
Underscores must be used to separate words.<br/>

Good examples:
  ```ruby
  parse_json_data
  publish_message
  ```

Bad examples: <br/>
  ```ruby
  parseJsonData
  parseJSONData
  publishMessage
  publishmessage
  ```

####**__V. File names__**
All Ruby filenames must properly be named using snake_case.<br/>

For example:
  ```
  application.rb
  application_controller.rb
  ```

Never use any other conventions in Ruby. The proper Ruby naming conventions always uses underscore to separate words.<br/>
Example of bad names:
  ```
  Application.rb 
  ApplicationController.rb 
  applicationController.rb
  applicationcontroller.rb
  ```

####**__VI. Meaningful names__**
One should never use one-character names. Do not name any of your things, no matter however trivial, with only one character..<br/>
For example : a, h, e  are bad names..<br/>
All names must reflect their purposes and functionalities. <br/>

Bad examples: 
  ```ruby
  text_file_1 
  text_file_2
  get_data(p)
  ```

Good examples: 
  ```ruby
  input_text_file
  output_text_file
  get_json_data(params)
  ```

At the same time, do not write too long a name.<br/>

It is a good practice to use the names to communicate what the things are. <br/>
For example: If you want to store a filename in a variable, calling it “**input_filename**” is better than calling it “**input_file**”.




