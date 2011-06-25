require 'lib/dates'
require 'test/fixtures'

describe Date do

  describe "list command" do
    it "lists the contents of a dates file correctly" do
      $dates.ideas.length.should == 6
    end
  end

end
