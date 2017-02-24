let SessionLoad = 1
let s:so_save = &so | let s:siso_save = &siso | set so=0 siso=0
let v:this_session=expand("<sfile>:p")
silent only
cd ~/projects/flamingo/ex2
if expand('%') == '' && !&modified && line('$') <= 1 && getline(1) == ''
  let s:wipebuf = bufnr('%')
endif
set shortmess=aoO
badd +1 recovery.acts
badd +1 recovery.goals
badd +1 recovery.info
badd +40 common.acts
badd +1 common.info
badd +21 ~/.vim/bundle/vim-obsession/doc/obsession.txt
badd +289 ~/.vimrc
argglobal
silent! argdel *
argadd recovery.acts
set stal=2
edit common.info
set splitbelow splitright
wincmd _ | wincmd |
vsplit
wincmd _ | wincmd |
vsplit
2wincmd h
wincmd _ | wincmd |
split
1wincmd k
wincmd w
wincmd w
wincmd _ | wincmd |
split
1wincmd k
wincmd w
wincmd w
set nosplitbelow
set nosplitright
wincmd t
set winminheight=1 winminwidth=1 winheight=1 winwidth=1
exe '1resize ' . ((&lines * 21 + 27) / 55)
exe 'vert 1resize ' . ((&columns * 57 + 87) / 175)
exe '2resize ' . ((&lines * 30 + 27) / 55)
exe 'vert 2resize ' . ((&columns * 57 + 87) / 175)
exe '3resize ' . ((&lines * 21 + 27) / 55)
exe 'vert 3resize ' . ((&columns * 53 + 87) / 175)
exe '4resize ' . ((&lines * 30 + 27) / 55)
exe 'vert 4resize ' . ((&columns * 53 + 87) / 175)
exe 'vert 5resize ' . ((&columns * 63 + 87) / 175)
argglobal
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
silent! normal! zE
let s:l = 32 - ((5 * winheight(0) + 10) / 21)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
32
normal! 011|
wincmd w
argglobal
edit recovery.info
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
silent! normal! zE
let s:l = 90 - ((29 * winheight(0) + 15) / 30)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
90
normal! 013|
wincmd w
argglobal
edit common.acts
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
silent! normal! zE
let s:l = 9 - ((8 * winheight(0) + 10) / 21)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
9
normal! 08|
wincmd w
argglobal
edit recovery.acts
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
silent! normal! zE
let s:l = 58 - ((3 * winheight(0) + 15) / 30)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
58
normal! 06|
wincmd w
argglobal
edit recovery.goals
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
silent! normal! zE
let s:l = 2 - ((1 * winheight(0) + 26) / 52)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
2
normal! 0
wincmd w
5wincmd w
exe '1resize ' . ((&lines * 21 + 27) / 55)
exe 'vert 1resize ' . ((&columns * 57 + 87) / 175)
exe '2resize ' . ((&lines * 30 + 27) / 55)
exe 'vert 2resize ' . ((&columns * 57 + 87) / 175)
exe '3resize ' . ((&lines * 21 + 27) / 55)
exe 'vert 3resize ' . ((&columns * 53 + 87) / 175)
exe '4resize ' . ((&lines * 30 + 27) / 55)
exe 'vert 4resize ' . ((&columns * 53 + 87) / 175)
exe 'vert 5resize ' . ((&columns * 63 + 87) / 175)
tabedit recovery.acts
set splitbelow splitright
set nosplitbelow
set nosplitright
wincmd t
set winminheight=1 winminwidth=1 winheight=1 winwidth=1
argglobal
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
silent! normal! zE
let s:l = 39 - ((38 * winheight(0) + 19) / 39)
if s:l < 1 | let s:l = 1 | endif
exe s:l
normal! zt
39
normal! 09|
tabnext 1
set stal=1
if exists('s:wipebuf') && getbufvar(s:wipebuf, '&buftype') isnot# 'terminal'
  silent exe 'bwipe ' . s:wipebuf
endif
unlet! s:wipebuf
set winheight=1 winwidth=20 winminheight=1 winminwidth=1 shortmess=filnxtToO
let s:sx = expand("<sfile>:p:r")."x.vim"
if file_readable(s:sx)
  exe "source " . fnameescape(s:sx)
endif
let &so = s:so_save | let &siso = s:siso_save
let g:this_session = v:this_session
let g:this_obsession = v:this_session
let g:this_obsession_status = 2
doautoall SessionLoadPost
unlet SessionLoad
" vim: set ft=vim :
