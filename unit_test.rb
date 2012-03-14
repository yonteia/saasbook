# test methods

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
