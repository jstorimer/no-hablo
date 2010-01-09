class TranslationMailer < ActionMailer::Base
  def notification(recipient, translation)
    subject    "[No-Hablo] Finished translating your products to #{translating.to_lang}"
    recipients recipient
    from       'no-reply@no-hablo.net'
    
    body       :translation => translation
  end
end
