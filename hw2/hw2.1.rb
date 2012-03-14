# from unit_test.rb (everything has to be in the same file for submitting)
$trace_on = false

def put_line(string)
  puts string
  puts "\n"
end

def trace(string)
  # todo: comment this out before shipping
  if $trace_on
    put_line string
  end
end
# assert the test is true
# @param testString the test name
def assert_true(test, testString)
  put_line (test ? :Passed!.to_s : :Failed!.to_s) + ' ' + testString + ' '
end

def assert_false(test, testString)
  assert_true(!test, testString) # no reason to duplicate code
end

#$trace_on = true

# reopen numeric and modify
# hw 2, 1.a
class Numeric

  attr_accessor :currency

  @@currencies = {'dollar' => 1.000, 'yen' => 0.013, 'euro'   => 1.292, 'rupee' => 0.019}

  def method_missing(method_id)
    singular_currency = method_id.to_s.gsub(/s$/, '')
    if @@currencies.has_key?(singular_currency)
      number = self #/
                 #(@currency != nil ? @@currencies[@currency] : 1) *
                # @@currencies[singular_currency]
      number.currency = singular_currency
      return number
    else
      super
    end
  end

  def in (currency)
    singular_currency = currency.to_s.gsub(/s$/, '')
    if @@currencies.has_key?(singular_currency)
      trace @currency
      trace @@currencies[@currency]
      trace (@currency != nil ? @@currencies[@currency] : 1)
      number = (self *
                (@currency != nil ? @@currencies[@currency] : 1) /
                @@currencies[singular_currency])
      number.currency = singular_currency
      trace number
      return number
    end
  end
end

def test_hw_2_1_a
  assert_true(5.euros == 5,
              "5.euros == #{5}")
  assert_true(5.dollar.in(:euros) == 5 * 1 / 1.292,
              "5.dollar.in(:euros) == #{5 / 1.292}")
  assert_true(10.rupees.in(:euro) == 10 * 0.019 / 1.292,
              "10.rupees.in(:euro) == #{10 * 0.019 / 1.292}")
end

class String

  def palindrome?
    return self.downcase.gsub(/[^a-z]/, '') ==
      self.reverse.downcase.gsub(/[^a-z]/, '')
  end

end

module Enumerable
  def palindrome?
    if !self.respond_to?('reverse')
      return false
    end

    return self.entries == self.reverse.entries
  end
end

def test_hw_2_1_b
  if "foo".palindrome? == false
    assert_true(true, '\"foo\".palindrome? == false')
  end

  if "foo, foof 45".palindrome? == true
    assert_true(true, '\"foo, foof 45\".palindrome? == true')
  end
end

def test_hw_2_1_c
  if [1, 2, 3, 2, 1].palindrome? == true
    assert_true(true, '[1, 2, 3, 2, 1].palindrome? == true')
  else
    assert_false(true, '[1, 2, 3, 2, 1].palindrome? == true')
  end

  if ["red", "green", "red"].palindrome? == true
    assert_true(true, "\"red\", \"green\", \"red\"].palindrome? == true")
  else
    assert_false(true, "\"red\", \"green\", \"red\"].palindrome? == true")
  end

   if ["red", "green", "blue"].palindrome? == false
     assert_true(true, "\"red\", \"green\", \"blue\"].palindrome? == false")
   else
     assert_false(true, "\"red\", \"green\", \"blue\"].palindrome? == false")
   end

  if {:yes => 42, :no => 65}.palindrome? == true
    assert_true(false, "hash bail")
  else
    assert_true(true, "hash bail")
  end
end

def run_all_tests
  test_hw_2_1_a
  test_hw_2_1_b
  test_hw_2_1_c
end

run_all_tests
