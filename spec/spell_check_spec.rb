require File.dirname(__FILE__)+"/../lib/spell_check"

describe SpellCheck do
  it "should not find spelling errors in an empty string" do
    spelling("").should be_correct
  end
  it "should know when words are spelled correctly" do
    spelling("trademark").should be_correct
  end
  it "should know when words are not spelled correctly" do
    spelling("awesome").should_not be_correct
  end
  it "should not suggest alternatives for words that are spelled correctly" do
    spelling("trademark").alternatives.should have(0).words
    spelling("trademark").alternatives.should == []
  end
  it "should suggest alternatives for words that are not spelled correctly" do
    spelling("trademak").alternatives.should have(1).words
    spelling("trademak").alternatives.should == ['trademark']
  end

  context "with a custom dictionary" do
    it "should know words are spelled correctly" do
      spelling("awesome").with_dictionary("spelling is awesome").should be_correct
    end
    it "should know when words are not spelled correctly" do
      spelling("trademark").with_dictionary("spelling is awesome").should_not be_correct
    end
  end
  
  context "an entire sentence" do
    it "should be able to check an entire sentence"
    it "should suggest alternatives for each individual word"
  end

  def spelling(string)
    string.extend(SpellCheck)
  end
end