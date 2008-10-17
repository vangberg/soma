function ToSomaBuffer(text)
  let name = substitute(system("whoami"), "\n", "", "") 
  call writefile(split(a:text, '\n'), "/tmp/". name . "_somarepl_buffer")
endfunction
  
vmap <C-c><C-c> "ry :call ToSomaBuffer(@r)<CR>
