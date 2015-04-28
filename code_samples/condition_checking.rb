
# Not a good way to check many conditions
class IfSizeService
  class << self
    
    def size_name(size_character)
      if size_character == 'L'
        return 'Large'
      elsif size_character == 'M'
        return 'Medium'
      elsif size_character == 'S'
        return 'Small'
      else
        return 'Unknown'
      end
    end
  
  end
end


# A terrible way to check many conditions
class TenarySizeService
  class << self
    
    def size_name(size_character)
      (size_character == 'L')? 'Large' : ( (size_character == 'M')? 'Medium' : ( (size_character == 'S')? 'Small' : 'Unknown' ) )
    end
  
  end
end


# An acceptable way to check many conditions
class CaseWhenSizeService
  class << self
    
    def size_name(size_character)
      case size_character
      when 'L'
        return 'Large'
      when 'M'
        return 'Medium'
      when 'S'
        return 'Small'
      else
        return 'Unknown'
      end
    end
  
  end
end


# A good way to check many conditions
class SizeService

  # The mapping here can be externalized to YML file
  SIZE_MAPPING = {
    l: 'Large',
    m: 'Medium',
    s: 'Small'
  }

  class << self
    def size_name(size_character)
      SIZE_MAPPING[size_character.downcase.to_sym] || 'Unknown'
    end
  end
end
