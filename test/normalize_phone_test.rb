require 'normalize_phone'
require 'test/unit'

class ClassUnderTest
  include NormalizePhone
  attr_accessor :my_phone
  
  normalize_phone_attributes :my_phone
  
  def write_attribute(key, value)
    instance_variable_set("@#{key}", value)
  end
end

class NormalizePhoneTest < Test::Unit::TestCase
  def test_normalize
    assert_equal "+49 22129233069", NormalizePhone.normalize("0049 22129233069")
    assert_equal "+49 22129233069", NormalizePhone.normalize("+49 22129233069")
    assert_equal "+49 22129233069", NormalizePhone.normalize("++49 22129233069")
    assert_equal "+49 22129233069", NormalizePhone.normalize("++49 022129233069")
    assert_equal "+49 22129233069", NormalizePhone.normalize("++49 (0)22129233069")
    assert_equal "+49 22129233069", NormalizePhone.normalize("0049 0221/292330-69")
    assert_equal "+49 22129233069", NormalizePhone.normalize("0049 (0221)292330-69")
    assert_equal "+49 22129233069", NormalizePhone.normalize("0221-29233069")
    assert_equal "+49 22129233069", NormalizePhone.normalize("0221/29233069")
    assert_equal "+49 22129233069", NormalizePhone.normalize("0221/292330-69")
    assert_equal "+49 22129233069", NormalizePhone.normalize("(0221)29233069")
    assert_equal "+49 22129233069", NormalizePhone.normalize("0221 292 330-69")
    assert_equal "+49 22129233069", NormalizePhone.normalize("0221 - 29233069")
    assert_equal "+49 1727320524" , NormalizePhone.normalize("+49 (0) 172 73 20 524")
    assert_equal "+49 1702419645" , NormalizePhone.normalize("00491702419645")
    assert_equal "+49 1702419645" , NormalizePhone.normalize("+491702419645")
    assert_equal "+49 1636905280" , NormalizePhone.normalize("+49 - (0) 163 / 6905280")
    assert_equal "+49 1777747174" , NormalizePhone.normalize("+49.(0)17.77.74.71.74")
    assert_equal "+49 1712054740" , NormalizePhone.normalize("+ 49 1 71 - 2 05 47 40")
    assert_equal "+352 621155224" , NormalizePhone.normalize("+352621155224")
    
    assert_equal "+7 22129233069", NormalizePhone.normalize("007 22129233069")
    assert_equal "+7 22129233069", NormalizePhone.normalize("+7 22129233069")
    assert_equal "+7 22129233069", NormalizePhone.normalize("++7 22129233069")
    assert_equal "+7 22129233069", NormalizePhone.normalize("++7 022129233069")
    assert_equal "+7 22129233069", NormalizePhone.normalize("++7 (0)22129233069")
    assert_equal "+7 22129233069", NormalizePhone.normalize("007 0221/292330-69")
    assert_equal "+7 22129233069", NormalizePhone.normalize("007 (0221)292330-69")

    assert_equal "+1557 22129233069", NormalizePhone.normalize("001557 22129233069")
    assert_equal "+1557 22129233069", NormalizePhone.normalize("+1557 22129233069")
    assert_equal "+1557 22129233069", NormalizePhone.normalize("++1557 22129233069")
    assert_equal "+1557 22129233069", NormalizePhone.normalize("++1557 022129233069")
    assert_equal "+1557 22129233069", NormalizePhone.normalize("++1557 (0)22129233069")
    assert_equal "+1557 22129233069", NormalizePhone.normalize("001557 0221/292330-69")
    assert_equal "+1557 22129233069", NormalizePhone.normalize("001557 (0221)292330-69")
    assert_equal "+4 22129233069", NormalizePhone.normalize("004 0221292330-69")
    
    
    # Diese Nummern sind nicht valide und sollten so bleiben
    assert_equal "00022129233069", NormalizePhone.normalize("00022129233069")
    assert_equal "0022129233069", NormalizePhone.normalize("0022129233069")
    assert_equal "0800-POTTHOFF", NormalizePhone.normalize("0800-POTTHOFF")
    assert_equal "111111111111111111", NormalizePhone.normalize("111111111111111111")
    assert_equal "0000000000000000000", NormalizePhone.normalize("0000000000000000000")
    assert_nil NormalizePhone.normalize nil
  end
  
  def test_should_use_default_country_code
    NormalizePhone.default_country_code = 33
    assert_equal "+33 22129233069", NormalizePhone.normalize("0221-29233069")
    NormalizePhone.default_country_code = 49
  end
  
  def test_should_have_normalize_phone_attributes_method
    cut = ClassUnderTest.new
    cut.my_phone = "0221-29233069"
    assert_equal "+49 22129233069", cut.my_phone
  end
end
