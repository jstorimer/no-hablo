require 'test/unit'
require File.dirname(__FILE__) + '/../bin/translate'

class GoogleTranslateTest < Test::Unit::TestCase
  
  def setup
    @translate = File.dirname(__FILE__) + '/../bin/translate.rb'
  end
  
  def test_trying_to_translate
    assert_equal("Teste", `ruby #{@translate} Test`.strip!)
  end
  
  def test_trying_to_translate_from_portuguese_to_english
    assert_equal("Hello world", `ruby #{@translate} 'Olá mundo' en`.strip!)
  end
  
  def test_trying_to_translate_from_spanish_to_english
    assert_equal("Hola mundo", `ruby #{@translate} 'Olá mundo' es`.strip!)
  end
end