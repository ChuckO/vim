#!/usr/bin/env ruby

# Checkout and make a plugin for this:
# http://efiquest.org/2010-09-24/49/

git_bundles = [ 
  "git://github.com/scrooloose/nerdtree.git",
  "git://github.com/vim-scripts/tComment.git",
  "git://github.com/vim-scripts/bufkill.vim",
  "git://github.com/vim-scripts/L9",
  "git://github.com/vim-scripts/FuzzyFinder.git",
  "git://github.com/tpope/vim-surround.git",
  "git://github.com/flazz/vim-colorschemes.git",
  "git://github.com/ervandew/supertab.git",
  "git://github.com/vim-scripts/ZoomWin.git",
  "git://github.com/tsaleh/vim-tcomment.git",
#  "git://github.com/scrooloose/nerdcommenter.git",

# No dice with leader, need to figure leader out
#  "git://github.com/Lokaltog/vim-easymotion.git",
  
# doesn't work iwith ruby 1.9 hash syntax but good idea
#  "git://github.com/scrooloose/syntastic.git",

#  "git://github.com/vim-scripts/AsyncCommand",
#  "git://github.com/tpope/vim-haml.git",
#  "git://github.com/msanders/snipmate.vim.git",
#  "git://github.com/tpope/vim-markdown.git",
#  "git://github.com/tpope/vim-rails.git",
#  "git://github.com/vim-ruby/vim-ruby.git",
#  "git://github.com/rson/vim-conque",
#  "git://github.com/tpope/vim-fugitive.git",
#  "git://github.com/tyru/open-browser.vim",
#  "https://github.com/vim-scripts/xml.vim.git",
#  "git://github.com/timcharper/textile.vim.git",
#  "git://github.com/tpope/vim-git.git",
#  "git://github.com/astashov/vim-ruby-debugger.git",
#  "git://github.com/tpope/vim-cucumber.git",
#  "git://github.com/tpope/vim-repeat.git",
#  "git://github.com/tsaleh/vim-align.git",
#  "git://github.com/tsaleh/vim-shoulda.git",
#  "git://github.com/tsaleh/vim-supertab.git",
]

vim_org_scripts = [
  ["railscasts",    "8379",  "colors"],
  ["bufonly",       "3388",  "plugin"],
#  ["IndexedSearch", "7062",  "plugin"],
#  ["gist",          "12732", "plugin"],
#  ["jquery",        "12107", "syntax"],
]

require 'fileutils'
require 'open-uri'

bundles_dir = File.join(File.dirname(__FILE__), "bundle")

FileUtils.cd(bundles_dir)

puts "Trashing everything but symlinks(lookout!)"
Dir["*"].each {|d| FileUtils.rm_rf( d ) unless File.symlink?(d) }

git_bundles.each do |url|
  dir = url.split('/').last.sub(/\.git$/, '')
  puts "  Unpacking #{url} into #{dir}"
  `git clone #{url} #{dir}`
  FileUtils.rm_rf(File.join(dir, ".git"))
end

vim_org_scripts.each do |name, script_id, script_type|
  puts "  Downloading #{name}"
  local_file = File.join(name, script_type, "#{name}.vim")
  FileUtils.mkdir_p(File.dirname(local_file))
  File.open(local_file, "w") do |file|
    file << open("http://www.vim.org/scripts/download_script.php?src_id=#{script_id}").read
  end
end

