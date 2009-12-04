module SpellCheck
  def correct?
    return true if empty?
    return true if is_known_word?
    false
  end

  def alternatives
    return [] if is_known_word?
    result = (deletions+transpositions+alterations+insertions).find_all {|w| known_words.include?(w) }
  end

  def known_words
    @known_words ||= dictionary_file.downcase.scan(/[a-z]+/)
  end

  private
  def deletions
    (0...length).collect {|i| self[0...i]+self[i+1..-1] }
  end
  
  def transpositions
    (0...length-1).collect {|i| self[0...i]+self[i+1,1]+self[i,1]+self[i+2..-1] }
  end
  
  def alterations
    words = []
    length.times {|i| letters.each_byte {|l| words << self[0...i]+l.chr+self[i+1..-1] } }
    words
  end
  
  def insertions
    words = []
    (length+1).times {|i| letters.each_byte {|l| words << self[0...i]+l.chr+self[i..-1] } }
    words
  end

  def is_known_word?
    known_words.include?(self)
  end
  
  def dictionary_file
    File.read(File.dirname(__FILE__)+'/holmes.txt')
  end
  
  def letters
    ("a".."z").to_a.join
  end
end