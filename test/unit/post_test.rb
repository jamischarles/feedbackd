require 'test_helper'

class PostTest < ActiveSupport::TestCase
  # Replace this with your real tests.
	test "the truth" do
		assert true
	end
	
	def test_word_is_english_and_polish
	   zone = Zone.new :top=>'20', :width=>'50'
	   assert_equal '20', zone.top
	   assert_equal '50', zone.width
	 end

end
