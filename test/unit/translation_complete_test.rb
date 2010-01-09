require 'test_helper'

class TranslationCompleteTest < ActionMailer::TestCase
  test "notification" do
    @expected.subject = 'TranslationComplete#notification'
    @expected.body    = read_fixture('notification')
    @expected.date    = Time.now

    assert_equal @expected.encoded, TranslationComplete.create_notification(@expected.date).encoded
  end

end
