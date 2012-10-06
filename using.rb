require 'test/unit'

class TestUsing < Test::Unit::TestCase
  class Resource
    def dispose
      @disposed = true
    end

    def disposed?
      @disposed
    end
  end

  def test_disposes_of_resources
    r = Resource.new
    using(r) {}
    assert r.disposed?
  end

  def test_disposes_in_expection
    r = Resource.new
    assert_raises(Exception) {
      using(r) { raise Exception }
    }
    assert r.disposed?
  end

  def test_disposes_in_throw
    r = Resource.new
    catch(:get_out) {
      using(r) { throw :get_out, "Boo!" }
    }
    assert r.disposed?
  end
end


def using(resource)
  begin
    yield
  rescue Exception => e
    raise e
  ensure
    resource.dispose if resource.respond_to?(:dispose)
  end
end
