require File.dirname(__FILE__) + '/../test_helper'

class NotifyTest < ActionMailer::TestCase
  tests Notify
  def test_signup
    @expected.subject = 'Notify#signup'
    @expected.body    = read_fixture('signup')
    @expected.date    = Time.now

    assert_equal @expected.encoded, Notify.create_signup(@expected.date).encoded
  end

  def test_remember
    @expected.subject = 'Notify#remember'
    @expected.body    = read_fixture('remember')
    @expected.date    = Time.now

    assert_equal @expected.encoded, Notify.create_remember(@expected.date).encoded
  end

end
