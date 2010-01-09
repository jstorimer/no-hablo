class Translation < ActiveRecord::Base
  UNIT_PRICE = 0.10 # cents
  LANGUAGES = [["Afrikaans", "af"], ["Albanian", "sq"], ["Arabic", "ar"], ["Belarusian", "be"], ["Bulgarian", "bg"], ["Catalan", "ca"], ["Chinese (Simplified)", "zh-CN"], ["Chinese (Traditional)", "zh-TW"], ["Croatian", "hr"], ["Czech", "cs"], ["Danish", "da"], ["Dutch", "nl"], ["English", "en"], ["Estonian", "et"], ["Filipino", "tl"], ["Finnish", "fi"], ["French", "fr"], ["Galician", "gl"], ["German", "de"], ["Greek", "el"], ["Hebrew", "iw"], ["Hindi", "hi"], ["Hungarian", "hu"], ["Icelandic", "is"], ["Indonesian", "id"], ["Irish", "ga"], ["Italian", "it"], ["Japanese", "ja"], ["Korean", "ko"], ["Latvian", "lv"], ["Lithuanian", "lt"], ["Macedonian", "mk"], ["Malay", "ms"], ["Maltese", "mt"], ["Norwegian", "no"], ["Persian", "fa"], ["Polish", "pl"], ["Portuguese", "pt"], ["Romanian", "ro"], ["Russian", "ru"], ["Serbian", "sr"], ["Slovak", "sk"], ["Slovenian", "sl"], ["Spanish", "es"], ["Swahili", "sw"], ["Swedish", "sv"], ["Thai", "th"], ["Turkish", "tr"], ["Ukrainian", "uk"], ["Vietnamese", "vi"], ["Welsh", "cy"], ["Yiddish", "yi"]]
  
  belongs_to :shop
  validates_presence_of :to_lang
  
  def translate
    ShopifyAPI::Base.site = shop.site
    translator = GoogleTranslate.new(ShopifyAPI::Product.find(:first).body, to_lang)
    
    ShopifyAPI::Product.find_each do |product|      
      metafield = ShopifyAPI::Metafield.new
      metafield.load({
         :description => "Translation of description to #{to_lang}",
         :namespace => 'translations',
         :key => to_lang,
         :value => translator.translate(product.body),
         :value_type => 'string'
      })
      
      product.add_metafield(metafield)
    end
    
    shop.update_attributes(:processing => false)
    TranslationMailer.deliver_notification(ShopifyAPI::Shop.current.email)
  end
end
