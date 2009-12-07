module SpellCheck
  def correct?
    return true if empty?
    return true if is_known_word?
    false
  end

  def alternatives
    return [] if is_known_word?
    known_words_in(deletions + transpositions + alterations + insertions)
  end

  def with_dictionary(dict)
    @custom_dictionary = Hash[dict.downcase.scan(/[a-z]+/).collect{|v| [v, true]}]
    self
  end

private
  def known_words
    @known_words ||= (@custom_dictionary || dictionary_file)
  end

  def deletions
    (0...length).collect {|i| self[0...i]+self[i+1..-1] }
  end
  
  def transpositions
    (0...length-1).collect {|i| self[0...i]+self[i+1,1]+self[i,1]+self[i+2..-1] }
  end
  
  def alterations
    words = []
    length.times {|i| alphabet.each {|l| words << self[0...i]+l+self[i+1..-1] } }
    words
  end
  
  def insertions
    words = []
    (length+1).times {|i| alphabet.each {|l| words << self[0...i]+l+self[i..-1] } }
    words
  end
  
  def known_words_in(words)
    words.find_all {|w| is_known_word?(w) }
  end

  def is_known_word?(word = nil)
    known_words.has_key?(word || self)
  end
  
  def dictionary_file
    Marshal.load(File.read(File.dirname(__FILE__)+'/holmes.dict'))
  end
  
  def alphabet
    ("a".."z").to_a
  end
end