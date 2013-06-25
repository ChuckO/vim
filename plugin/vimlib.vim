function! vimlib#testFunct()
  echo 'hello world3'
endfunction

function! vimlib#gitDir()

  let origcurdir = getcwd()
  let curdir = origcurdir
  let prevdir = ""
  let gitdir = ""

  while curdir != prevdir
    if isdirectory(".git")
      let gitdir = getcwd()
      break
    endif
    cd ..
    let prevdir = curdir
    let curdir = getcwd()
  endwhile
  if curdir == '/'
    let curdir = origcurdir
    exe 'cd ' curdir
  end
  "echo 'CURDIR='.curdir
endfunction

function! vimlib#projectFuzzyFind()
  call vimlib#gitDir()
  let curdir = getcwd()
  let files = []
  let files += split(glob(curdir . "/**/*"), "\n")
  call fuf#givenfile#launch('', 0, '>', files)
  " call fuf#givendir#launch('', 0, '>', split(&runtimepath, ','))
  "  :FufFileWithCurrentBufferDir 
endfunction

function! vimlib#search(query)
  call vimlib#gitDir()
  let curdir = getcwd()

  let grep_cmd = "cd ".curdir."; search \"".a:query."\""
  let vim_func = "VimlibSearchResults"

  echo grep_cmd
  call AsyncCommand(grep_cmd, vim_func)
endfunction

function! VimlibSearchResults(temp_file_name)
  let &errorformat = &grepformat
  call OnCompleteLoadErrorFile(a:temp_file_name)
endfunction

command! -nargs=1 VimlibSearch call vimlib#search(<q-args>)

function! DoPrettyXML()
  " save the filetype so we can restore it later
  let l:origft = &ft
  set ft=
  " delete the xml header if it exists. This will
  " permit us to surround the document with fake tags
  " without creating invalid xml.
  1s/<?xml .*?>//e
  " insert fake tags around the entire document.
  " This will permit us to pretty-format excerpts of
  " XML that may contain multiple top-level elements.
  0put ='<PrettyXML>'
  $put ='</PrettyXML>'
  silent %!xmllint --format -
  " xmllint will insert an <?xml?> header. it's easy enough to delete
  " if you don't want it.
  " delete the fake tags
  2d
  $d
  " restore the 'normal' indentation, which is one extra level
  " too deep due to the extra tags we wrapped around the document.
  silent %<
  " back to home
  1
  " restore the filetype
  exe "set ft=" . l:origft
endfunction
command! PrettyXML call DoPrettyXML()


let g:gitgrepprg="~/bin/search "

function! Search(args)
    call vimlib#gitDir()
    let curdir = getcwd()
    let grepprg_bak=&grepprg
    exec "set grepprg=" . g:gitgrepprg
    execute "silent! grep " . a:args 
    belowright copen
    let &grepprg=grepprg_bak
    exec "redraw!"
endfunction

command! -nargs=* -complete=file Search call Search(<q-args>)

command! -nargs=* -complete=file SearchCurrentWord call Search(expand("<cword>"))
