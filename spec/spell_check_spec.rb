require File.dirname(__FILE__)+"/../lib/spell_check"

Spec::Matchers.define :be_spelled_correctly do
  match do |string|
    string.extend(SpellCheck).correct?
  end
  
  failure_message_for_should do |string|
    "Expected '#{string}' to be spelled correctly."
  end

  failure_message_for_should_not do |string|
    "Expected '#{string}' to be spelled incorrectly."
  end
end

Spec::Matchers.define :have_alternatives do |expected|
  match do |string|
    string.extend(SpellCheck).alternatives == expected
  end
end

describe SpellCheck do
  context "with the default dictionary" do
    it "should not find spelling errors in an empty string" do
      "".should be_spelled_correctly
    end
  
    it "should know words that are in the word dictionary" do
      "trademark".should be_spelled_correctly
    end
  
    it "should find spelling errors for words that are not in the word dictionary" do
      "awesome".should_not be_spelled_correctly
    end

    it "should not suggest alternatives for words that are spelled correctly" do
      "trademark".should have_alternatives([])
    end
  
    it "should suggest alternatives for words that are not spelled correctly" do
      "trademak".should have_alternatives(['trademark'])
    end
  end

  context "with a custom dictionary" do
    it "should know words that are in the custom dictionary" do
      "awesome".extend(SpellCheck).with_dictionary("spelling is awesome").should be_spelled_correctly
    end
    it "should not know words that are in the default dictionary" do
      "trademark".extend(SpellCheck).with_dictionary("spelling is awesome").should_not be_spelled_correctly
    end
  end
end