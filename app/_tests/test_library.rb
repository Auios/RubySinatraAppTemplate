require_relative 'setup_tests'
require_relative '../lib/library'

class LibraryTest < Test
  class FooBar
    include FromHash

    attr_accessor :foo
    attr_accessor :bar
  end

  def test_from_hash
    fb = FooBar.new

    hash = {
      'foo' => 'this_foo',
      'bar' => 'this_bar'
    }
    fb.from_hash(hash)

    assert_equal('this_foo', fb.foo)
    assert_equal('this_bar', fb.bar)
  end
end
