require File.dirname(__FILE__)+ '/../lib/dates'

ideas = DateIdeas.new do

  date "watch primer in north" do
    kind :adventure => 2, :romantic => 4, :intellectual => 6, :athletic => 0
    requires :weather => 0, :hours => 2
    outcome 20
  end

  date "very close to primer" do
    kind :adventure => 2, :romantic => 4, :intellectual => 6, :athletic => 1
    requires :weather => 0, :hours => 2
  end

  date "very far from primer" do
    kind :adventure => 10, :romantic => 10, :intellectual => 0, :athletic => 10
    requires :weather => 0, :hours => 2
  end

  date "escher in the DiVE" do
    kind :adventure => 4, :romantic => 3, :intellectual => 4, :athletic => 0
    requires :weather => 0, :hours => 2
  end

  date "mushroom hunting" do
    kind :adventure => 6, :romantic => 3, :intellectual => 5, :athletic => 3
    requires :weather => 5, :hours => 2
  end

  date "duke observatory" do
    kind :adventure => 100, :romantic => 7, :intellectual => 5, :athletic => 1
    requires :weather => 8, :hours => 4
  end

end

valid_attributes = [:adventure, :romantic, :intellectual, :athletic]

describe Date do

  describe "interprets an ideas file" do
    it "correctly identifies incomplete and completed dates" do
      ideas.incomplete.length.should == 5
      ideas.complete.length.should == 1
      ideas.complete.first.name == "watch primer in north"
    end

    it "correctly loads the attributes and requirements for each date" do
      ideas.ideas.map { |idea|
        if idea.stub?
          idea.attributes.empty?.should == true
        else
          idea.attributes.length.should == valid_attributes.length
          idea.attributes.map { |name, val|
            valid_attributes.member?(name).should == true
          }
        end
      }
    end
  end

  describe "list command" do
    it "lists the contents of a dates file correctly" do
      ideas.ideas.length.should == 6
    end
  end

  describe "choose command" do
    it "chooses a date from the incomplete dates list" do
      choosed = ideas.choose(2, 2)
      ideas.incomplete.member?(choosed).should == true
    end
  end

end
