require 'test/unit'
require File.dirname(__FILE__) + '/../lib/google_translate'

class GoogleTranslateTest < Test::Unit::TestCase
  def setup
    @gt = GoogleTranslate.new("Test")
  end
  
  def test_trying_to_translate
    assert_equal("Teste", @gt.translate)
  end
  
  def test_trying_to_translate_from_portuguese_to_english
    assert_equal("Oi, meu nome é Bruno", @gt.translate("Hi, my name is Bruno"))
  end
  
  def test_trying_to_translate_from_english_to_portuguese
    @gt.tl = "en"
    assert_equal("Hello world", @gt.translate("Olá mundo"))
    
    @gt.tl = "pt"
    assert_equal("Meninos", @gt.translate("Muchachos"))
    
    @gt.tl = "es"
    assert_equal("Hola mundo", @gt.translate("Olá mundo"))
  end
  
  def test_using_htmlentities
    @gt.tl = "fr"
    assert_equal("Je t'aime", @gt.translate("I love you"))
  end
  
  def test_translate_from_string
    assert_equal("Hello world", "Olá mundo".to_en)
    assert_equal("Olá mundo", "Hello world".to_pt)
    assert_equal("Hola mundo", "Hello world".to_es)
  end
end