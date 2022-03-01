puts "Loading ~/.pryrc"
Pry.config.editor = 'vim'
#require 'math' # does not need to be required, prefix operations with Math::
include Math and \
  puts "The Math module has been included, you can skip the prefix for Math."
puts "Try Math::log(8, 2) or Math.log2(8)."
puts "Also Math.log10(100) for base 10."

def mklog(base)
  ->(n) { Math::log(n, base) }
end

