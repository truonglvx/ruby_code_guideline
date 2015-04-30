<div align='center'><h2>Ruby Implementation Best Practice<br/>(Still in the middle of writing)</h2></div>

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

  Ruby also allows methods to receive arbitrary numbers of parameters. Use ( )
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
  ```ruby
  # Do not write this
  def some_method(some_args)
    if condition
      # Do a lot of things here
      # Do a lot of things here
      # Do a lot of things here
      result = some_value_1
    else
      # Do something here
      result = some_value_2
    end
    result
  end


  # USE EARLY RETURN
  # Write this instead
  def some_method(some_args)
    unless condition
      # Do something here
      return some_value_2
    end
   
    # Do a lot of things here
    # Do a lot of things here
    # Do a lot of things here
    some_value_1
  end

  # Or write this
  def some_method(some_args)
    if !condition
      # Do something here
      return some_value_2
    end
   
    # Do a lot of things here
    # Do a lot of things here
    # Do a lot of things here
    some_value_1
  end

  ```

  Avoid nested if-else
  ```ruby
  # Do not write this
  def some_method(some_args)
    if condition
      # Do something here
      result = some_value_1
    else
      if another_condition
        # Do something here
        result = some_value_2
      else
        result = some_value_3
      end
    end
    result
  end


  # Write this instead
  def some_method(some_args)
    if condition
      # Do something here
      return some_value_1
    end

    if another_condition
      # Do something here
      return some_value_2
    end
    
    some_value_3
  end

  # In many cases, you can even write something like this
  def some_method(some_args)
    return some_value_1 if condition
    return some_value_2 if another_condition
    some_value_3
  end
  ```


3. Break down long methods
  
  Break down common functionalities
  ```ruby
  # If you have something like this:
  def api_get_invoice(params)
    # A lot of code to build the params here
    # Some code to build and call the service and point here
  end

  # Then you should break it down to several smaller methods

  def build_api_get_invoice_args(params)
    # Move the code that builds the args here
  end

  def invoice_service_call(args)
    # Move the code that really performs the network call here
  end

  # Your api_get_invoice(params) should look like this:
  def api_get_invoice(params)
    args = build_api_get_invoice_args params
    invoice_service_call args
  end

  ```

  
4. Use loop and dynamic programming to avoid repetitive code
  ```ruby

  # When you see some code like this:
  def parsed_log(options={})
    rds_transaction_log = RdsTransactionLog.new
   
    log = ''
    log << "APPLICATION=#{options.dig('application') || 'ServiceAPI'} "
    rds_transaction_log.status = options.dig('status') || 'NONE'
    log << "STATUS=#{rds_transaction_log.status} "
    rds_transaction_log.request = options.dig('request') || 'NONE'
    log << "REQUEST=#{rds_transaction_log.request} "
    rds_transaction_log.response = options.dig('response') || 'NONE'
    log << "RESPONSE=#{rds_transaction_log.response} "
    rds_transaction_log.process_name = options.dig('process_name') || 'NONE'
    log << "PROCESSNAME=#{rds_transaction_log.process_name} "
    rds_transaction_log.source_app = options.dig('source_app') || 'NONE'
    log << "SOURCEAPP=#{rds_transaction_log.source_app} "
    rds_transaction_log.target_app = options.dig('target_app') || 'NONE'
    log << "TARGETAPP=#{rds_transaction_log.target_app} "
    rds_transaction_log.transaction_id = options.dig('transaction_id') || 'NONE'
    log << "TRANSACTIONID=#{rds_transaction_log.transaction_id} "
    rds_transaction_log.object_id = options.dig('object_id') || 'NONE'
    log << "OBJECTID=#{rds_transaction_log.object_id} "
    rds_transaction_log.object_key_1 = options.dig('object_key_1') || 'NONE'
    log << "OBJECTKEY1=#{rds_transaction_log.object_key_1} "
    rds_transaction_log.object_key_2 = options.dig('object_key_2') || 'NONE'
    log << "OBJECTKEY2=#{rds_transaction_log.object_key_2} "
    rds_transaction_log.timestamp = options.dig('timestamp') || DateTime.now
    log << "TIMESTAMP=#{rds_transaction_log.timestamp} "
    rds_transaction_log.host_ip = options.dig('host_ip') || 'NONE'
    log << "HOSTIP=#{rds_transaction_log.host_ip} "
    rds_transaction_log.connection_type = options.dig('connection_type') || 'DEFAULT'
    log << "CONNECTIONTYPE=#{rds_transaction_log.connection_type}"
    rds_transaction_log.save
    logger.info rds_transaction_log.errors.inspect unless rds_transaction_log.valid?
    log
  end
  
  # You should replace the repetitive code with loop. And if it is needed, utilize the dynamic features of Ruby to shorten the code.
  def parsed_log(options={})
    rds_transaction_log = RdsTransactionLog.new

    log = ''
    log << "APPLICATION=#{options.dig('application') || 'ServiceAPI'} "

    [
      'status', 'request', 'response', 'process_name', 'source_app', 'target_app', 'transaction_id',
      'object_id', 'object_key_1', 'object_key_2', 'timestamp', 'host_ip', 'connection_type'
    ].each do |log_key|
      rds_transaction_log.send( "#{log_key}=", options.dig(log_key) || default_value(log_key) )
      log << "#{log_prefix(log_key)}=#{ rds_transaction_log.send(log_key) } "
    end     
    
    rds_transaction_log.save
    logger.info rds_transaction_log.errors.inspect unless rds_transaction_log.valid?
    log
  end
  ```
  
  5. Use naming conventions and dynamic programming to avoid using if-else too much
  ```ruby
  # When you see some code like this
  def call_service(http_method, content = {}, header = {})
    # Some validation code, data processing code here

    # case-when smells bad in Ruby
    case http_method.downcase
    when 'get'
      do_get(content, header)
    when 'put'
      do_put(content, header)
    when 'post'
      do_post(content, header)
    end
  end

  # You already have the methods call_service and do_get, do_put, do_post, you should write this:
  def call_service(http_method, content = {}, header = {})
    # Some validation code, data processing code here
    send("do_#{method_name.downcase}", content, header)
  end

  ```

  In cases you have many more possiblities in `case-when`, and you want to extend more in future, use the dynamic implemntation along with naming conventions will save you a lot of time. And you have easier time writing tests.


####**__II. Logging__**
  
  In an application, logging should be divided in different levels, for example: debug, info, warning, error.
  There are 2 other levels: fatal and unknown, but generally they are not used. Developers can choose to use them or not.

  - When, Where and How to log
  ```
  You should log input of methods at beginning and outputt of methods at the end as INFO.
  You should log information/data after critical execution steps in a method as DEBUG.
  Execution durations and Benchmark data should be logged as DEBUG too.

  You should log problems that cause an execution step to failed, but that step can be ignored in certain situation as WARNING.
  For example:
    An operation uses cache to speed up the data access. However, when the cache is not present, the operation must still work.
    But there should be a warning that said "Cache is not present."

  You MUST log all errors/exceptions with details when a method execution fails, and when you catch an exception as ERROR.
  ```
  
  - What to log
  ```
  . Always log the date, time when the log entry is logged in all cases.
  . When you log input and output of a method, it is a good idea to write Class/Module name and method name along with the data.
  . When you log an exception, make sure that you log both exception.message and exception.backtrace.

  ```

  - Note:
  
  Do not over log. Log only critical information. Log operation costs time and I/O resources and can slow performance down.
  
  Combine data you want to log, then call the logger when the data is ready.
  ```ruby
  # DO NOT WRITE THIS:
  logger.error("#{Time.now} ERROR: #{exception.message}")
  logger.error("#{exception.backtrace.join("\n")}")

  # Write this instead:
  logger.error("#{Time.now} ERROR: #{exception.message}\n#{exception.backtrace.join("\n")}")

  # Reason: Each time a logger is called, I/O operations happen. And I/O operations are slow, compared to in-memory data combination/processing.
  ```

####**__III. Exception handling__**
  1.

Two different types of exceptions: Recoverable and Non-recoverable
(including when Recoveable exceptions become Non-recoverable exceptions)

Differences between Business Errors and System Errors 

####**__VI. Test coverage__**
