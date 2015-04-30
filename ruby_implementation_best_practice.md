<div align='center'><h2>Ruby Implementation Best Practice</h2></div>

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
  1. Recoverable and Non-recoverable exceptions
    - Recoverable exceptions are exceptions that the application can try to resolve on its own.
    
    For example:
      When a network call fails due to 'Timeout' or 'Host is not reachable', the application can sleep for a few seconds and try the call again without user/consumer intervention. If it happens, to the user/consumer, the call will be a little slow, but they don't have to do anything to resolve the problems.

    - Non-recoverable exceptons are exceptions that required user/consumer input to fix the problems.

    For example:
      A user/consumer submits a request with wrong data. The application cannot do anything to fix it. In this case, the application will send back an error code and error message to user/consumer to tell them that they have to fix the data and submit the request again.

    - There must be a time Recoverable exceptions become Non-recoverable exceptions: After the application tries all things within its capability to resolve a Recoverable exception, but it still fails, the exception become Non-recoverable exception.

    For example:
      When a network call fails due to 'Timeout', the appicaltion tries to sleep few seconds and calls again for a few times (maybe 3 times), but the network call still fails, we must throw an exception about Service Call failed. The application cannot, and should not, wait and try forever.


    - Rule of thumbs: All the Business Errors (missing parameters, wrong data format, wrong data content) are Non-recoverable exceptions. Many System Errors are Recoverable exceptions.

  2. Exception handling

    - Catch a Recoverable exception immediately where it happens, try to resolve it programmatically within reasonable time and effort. If it is resolved, great. If the error still happens, log the exception in details for internal use, and raise the exception again.

    - Catch a Non-recoverable exception only at the tier's boundaries or application's boundaries.
      There is no point to catch a Non-recoverable all over the places, because the application cannot programmatically do anything to resolve it. It requires user/consumer input to fix the problem.

      However, as a security measure, and as a tier-decoupling principle, never let any exception go pass any boundary, be it tier's boundary or application's boundary.

      Example:
      ```
      A consumer makes a request to an API Server to get information about an invoice.

      If the call is success, great!

      But there are many things that can go wrong. Here are a few specific examples.

      a - User does not send all required parameters, the validation service within the API Server must detect this problem and throw an exception. This is a Non-recoverable exception, so we don't need to catch it immediately, or catch it all over the places. However, at the controller level, which is the boundary between the API Server and the consumer, we should not let the exception blow up to the consumer face. The controller must catch it, log the details for internal use and render appropriate error with appropriate HTML status code to the consumer.

      b - User send all the required the data. The API Server makes a call to another Service to get invoice details, but the call fails due to Network connection.
      Although we try a few times, but the call still fails, so it becomes Non-recoverable, and we throw an exception. We will not catch the exception all over the places, because at this point, the appication cannot programmatically do anything with it.
      But at the boundary of system call and business service, there must be a place you catch it and raise another appropriate exception.

      Reason: Business tier doesn't care about low-level system details such as network exception or the likes. It cares about whether the system layer can give it the invoice it wants or not.

      c - User send all the required the data. The API Server makes a call to another Service to get invoice details. It can make the call, but it comes back with error because of data mismatch. This is a business error, so we just let the exception bubble up all the way upto the application boundary. But at the very least, the controller must catch it, log information details, and render an appropriate response to the consumer.

      ```
    - Note:
      . Do not catch exceptions all over the places. Catch exception only if you can programmatically do something about it, or at tier's boudaries or application's boundaries.

      . Never give (render/return) information about exceptions directly to user/consumer. This is a capital offense of security standard.

####**__VI. Test coverage__**

  1. All of components in the system must have unit tests for all of their public methods.

  2. All of the test cases must cover happy path and failed path.

  3. If a method has multiple branches of executions (if-else, case-when or dynamic code), all the possiblities must have test cases.

  4. The whole application must have a set of comprehensive integration tests. The tests must cover all the entry points (API endpoints, input/output, external system interfaces) of the application.

  5. Before you write code, always write tests first.

  6. When you fix a bug, write test cases to prove that the bug exists, then write code to make the test cases passed.
