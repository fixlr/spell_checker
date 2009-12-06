require File.dirname(__FILE__)+"/../lib/spell_check"

describe SpellCheck do
  context "with the default dictionary" do
    it "should not find spelling errors in an empty string" do
      spelling("").should be_correct
    end
      
    it "should know words that are in the word dictionary" do
      spelling("trademark").should be_correct
    end
      
    it "should find spelling errors for words that are not in the word dictionary" do
      spelling("awesome").should_not be_correct
    end
    
    it "should not suggest alternatives for words that are spelled correctly" do
      spelling("trademark").alternatives.should == []
    end
      
    it "should suggest alternatives for words that are not spelled correctly" do
      spelling("trademak").alternatives.should == ['trademark']
    end
  end

  context "with a custom dictionary" do
    it "should know words that are in the custom dictionary" do
      spelling("awesome").with_dictionary("spelling is awesome").should be_correct
    end
    it "should not know words that are in the default dictionary" do
      spelling("trademark").with_dictionary("spelling is awesome").should_not be_correct
    end
  end

  def spelling(string)
    string.extend(SpellCheck)
  end
end