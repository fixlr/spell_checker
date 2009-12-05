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

describe SpellCheck do
  it "should not find spelling errors in an empty string" do
    "".should be_spelled_correctly
  end
  
  it "should know words that are in the word dictionary" do
    "trademark".should be_spelled_correctly
  end
  
  it "should find spelling errors for words that are not in the word dictionary" do
    "asdkfljlskjf".should_not be_spelled_correctly
  end

  it "should not suggest alternatives for words that are spelled correctly" do
    "trademark".extend(SpellCheck).alternatives.should == []
  end
  
  it "should suggest alternatives for words that are not spelled correctly" do
    "trademak".extend(SpellCheck).alternatives.should == ['trademark']
  end
  
  it "should allow custom dictionaries" do
    pending
    # "trademark".extend(SpellCheck).with_dictionary("spelling is cool").should_not be_spelled_correctly
  end
end