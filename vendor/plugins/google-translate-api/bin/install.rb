#!/usr/bin/env ruby

print "Installing the Google command-line Translate\n"

Dir.chdir File.dirname(__FILE__)

command = "alias t='#{Dir.pwd}/translate.rb'"
print "."

# To prevent an accidental removal of the file.
`cp ~/.bash_profile ~/.bash_profile.bkp`
print "."

# Inserting the alias into ".bash_profile".
`echo "#{command}" >> ~/.bash_profile`
print "."

# Loading alias.
`source ~/.bash_profile`
print "."

puts "\nThe installation is done!"
puts "Maybe you need to close the terminal and reopen it."