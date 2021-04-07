" Leader setup. {{{
let mapleader = " "
" }}}
" Files {{{
nmap <Leader>fs :w<CR>
nmap <Leader>fq :wq<CR>
" }}}
" Project level ops {{{
if isdirectory('.git')
  nmap <Leader>pf :Telescope git_files previewer=false<CR>
else
  nmap <Leader>pf :Telescope find_files previewer=false<CR>
endif
nmap <Leader>ps :Telescope live_grep<CR>
nmap <Leader>pc :make
" }}}
" Lists {{{
nmap ]q  :cnext<CR>
nnoremap [q  :cprev<CR>
nmap ]wq :cwindow<CR>
nmap ]wl :lwindow<CR>
nmap ]l  :lnext<CR>
nmap [l  :lprev<CR>
" }}}
" Jumps {{{
nmap <Leader>j=  gg=G<C-o>:echo "Indented buffer"<CR>
nmap <Leader>jp  <C-o>
nmap <Leader>jn  <C-i>
" }}}
" Buffers {{{
nmap <Leader>bb :Telescope buffers<CR>
" Switch to the last buffer and delete this one.
nmap <Leader>bd :bprevious\|bdelete #<CR>
nmap <Leader>bs :SC<CR>
nmap <Leader>br :e %<CR>
" }}}
" Windows {{{
nmap <Leader>w <C-w>
nmap <C-w>m <C-w>o
map <M-o> <C-w>w
" }}}
" Terminal {{{
nmap <Leader>'  :terminal<CR>
tnoremap fd     <C-\><C-n>
tmap <C-o> <C-\><C-n>
" }}}
" Tabs {{{
nmap ]t :tabnext<CR>
nmap [t :tabprev<CR>
tnoremap <M-j> <C-\><C-n>:tabnext<CR>
tnoremap <M-k> <C-\><C-n>:tabprev<CR>
nmap <Leader>tn :tabnext<CR>
nmap <Leader>tp :tabprev<CR>
nmap <Leader>to :tabnew<CR>
nmap <Leader>tc :tabclose<CR>
nmap <Leader>tw <C-w>T
nmap <Leader>t1 :tabn 1<CR>
nmap <Leader>t2 :tabn 2<CR>
nmap <Leader>t3 :tabn 3<CR>
nmap <Leader>t4 :tabn 4<CR>
nmap <Leader>t5 :tabn 5<CR>
" }}}
" Git {{{
nmap <Leader>gg  :Git
nmap <Leader>gs  :Git<CR>
nmap <Leader>gl  :Git log<CR>
nmap <Leader>gp  :Git push<CR>
nmap <Leader>gP  :Git pull --rebase<CR>
nmap <Leader>gri :Git rebase -i origin/master
nmap <Leader>gb  :Git blame<CR>
" }}}
" Utility {{{
imap fd <ESC>
" Copy file name to clipboard
nmap ,cs :let @*=expand("%")<CR>
nmap ,cl :let @*=expand("%:p")<CR>
" }}}
" System / Vim management {{{
nmap <Leader>spi :PlugInstall<CR>
nmap <Leader>spu :PlugUpdate<CR>
nmap <Leader>spg :PlugUpgrade<CR>
" }}}
" Linting {{{
nmap [a <Plug>(ale_previous_wrap)
nmap ]a <Plug>(ale_next_wrap)
" }}}
" Easy alignment {{{
vmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)
" }}}
" Testing {{{
noremap <Leader>mt :RunTest<CR>
" }}}
