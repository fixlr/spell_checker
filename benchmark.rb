require 'benchmark'
require 'lib/spell_check'

def check(word)
  word.extend(SpellCheck)
end

ebook = File.read('lib/holmes.txt')

Benchmark.bm do |x|
  x.report("#correct? marshalled dictionary") {
    check("trademark").correct?
  }

  x.report("#correct? ebook dictionary") {
    check("trademark").with_dictionary(ebook).correct?
  }

  x.report("#alternatives") {
    check("trademak").alternatives
  }
end