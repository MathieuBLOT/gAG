#!/usr/bin/env ruby

$GAG_ROOT = File.expand_path("..", File.dirname(__FILE__))

$GAG_LIB = File.join($GAG_ROOT, "lib")
$GAG_TESTS = File.join($GAG_ROOT, "tests")
$GAG = File.join($GAG_ROOT, "gag")

$LOAD_PATH.unshift($GAG_ROOT) unless $LOAD_PATH.include?($GAG_ROOT)

def commands_path
	functions = Array.new
	search_dirs = [$GAG_LIB, $GAG_TESTS]
	search_dirs.each { |dir| functions += Dir.entries(dir).map! { |file| File.join(dir, file) } }
	functions.collect! { |file| file if File.basename(file).start_with?("cmd_") and file.end_with?(".rb") } # Remove temporary files
	functions.compact! # Remove nils
end

$commands = Hash.new

commands_path.each do |f|
	fname = File.basename(f).sub("cmd_", "").sub(".rb", "")
	$commands[fname] = f
end

$VOID = RbConfig::CONFIG['host_os'] =~ /msdos|mswin|djgpp|mingw/ ? 'NUL' : '/dev/null'
