scriptencoding utf-8
set encoding=utf-8
set number
set ruler
set laststatus=2
set hlsearch
set ts=2 sw=2 et
highlight StatusLine term=bold cterm=bold ctermfg=black ctermbg=white
" highlight LineNr ctermfg=grey
highlight LineNr ctermfg=DarkCyan
" ステータスラインに日時を表示する
function! g:Date()
return strftime("%x %H:%M")
endfunction
set statusline=%F%m%r%h%w\%=\ %Y\ \%{&ff}\ \%{&fileencoding}\ \%l/%L

""""""""""""""""""""""""""""""
"全角スペースを表示
""""""""""""""""""""""""""""""
"コメント以外で全角スペースを指定しているので scriptencodingと、
"このファイルのエンコードが一致するよう注意！
"全角スペースが強調表示されない場合、ここでscriptencodingを指定すると良い。
"scriptencoding cp932

"デフォルトのZenkakuSpaceを定義
function! ZenkakuSpace()
highlight ZenkakuSpace cterm=underline ctermfg=darkgrey gui=underline guifg=darkgrey
endfunction

if has('syntax')
augroup ZenkakuSpace
autocmd!
" ZenkakuSpaceをカラーファイルで設定するなら次の行は削除
autocmd ColorScheme * call ZenkakuSpace()
" 全角スペースのハイライト指定
autocmd VimEnter,WinEnter * match ZenkakuSpace /　/
augroup END
call ZenkakuSpace()
endif


" 挿入モード時の色指定
" https://github.com/fuenor/vim-statusline/blob/master/insert-statusline.vim
if !exists('g:hi_insert')
let g:hi_insert = 'highlight StatusLine guifg=White guibg=DarkCyan gui=none ctermfg=Black ctermbg=DarkCyan cterm=none'
endif

if has('unix') && !has('gui_running')
inoremap <silent> <ESC> <ESC>
inoremap <silent> <C-[> <ESC>
endif

if has('syntax')
augroup InsertHook
autocmd!
autocmd InsertEnter * call s:StatusLine('Enter')
autocmd InsertLeave * call s:StatusLine('Leave')
augroup END
endif

let s:slhlcmd = ''
function! s:StatusLine(mode)
if a:mode == 'Enter'
silent! let s:slhlcmd = 'highlight ' . s:GetHighlight('StatusLine')
silent exec g:hi_insert
else
highlight clear StatusLine
silent exec s:slhlcmd
endif
endfunction

function! s:GetHighlight(hi)
redir => hl
exec 'highlight '.a:hi
redir END
let hl = substitute(hl, '[\r\n]', '', 'g')
let hl = substitute(hl, 'xxx', '', '')
return hl
endfunction


" http://www.kawaz.jp/pukiwiki/?vim#a7f8c70e

" 文字コードの自動認識
if &encoding !=# 'utf-8'
  set encoding=japan
  set fileencoding=japan
endif
if has('iconv')
  let s:enc_euc = 'euc-jp'
  let s:enc_jis = 'iso-2022-jp'
  " iconvがeucJP-msに対応しているかをチェック
  if iconv("\x87\x64\x87\x6a", 'cp932', 'eucjp-ms') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'eucjp-ms'
    let s:enc_jis = 'iso-2022-jp-3'
  " iconvがJISX0213に対応しているかをチェック
  elseif iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'euc-jisx0213'
    let s:enc_jis = 'iso-2022-jp-3'
  endif
  " fileencodingsを構築
  if &encoding ==# 'utf-8'
    let s:fileencodings_default = &fileencodings
    let &fileencodings = s:enc_jis .','. s:enc_euc .',cp932'
    let &fileencodings = &fileencodings .','. s:fileencodings_default
    unlet s:fileencodings_default
  else
    let &fileencodings = &fileencodings .','. s:enc_jis
    set fileencodings+=utf-8,ucs-2le,ucs-2
    if &encoding =~# '^\(euc-jp\|euc-jisx0213\|eucjp-ms\)$'
      set fileencodings+=cp932
      set fileencodings-=euc-jp
      set fileencodings-=euc-jisx0213
      set fileencodings-=eucjp-ms
      let &encoding = s:enc_euc
      let &fileencoding = s:enc_euc
    else
      let &fileencodings = &fileencodings .','. s:enc_euc
    endif
  endif
  " 定数を処分
  unlet s:enc_euc
  unlet s:enc_jis
endif
" 日本語を含まない場合は fileencoding に encoding を使うようにする
if has('autocmd')
  function! AU_ReCheck_FENC()
    if &fileencoding =~# 'iso-2022-jp' && search("[^\x01-\x7e]", 'n') == 0
      let &fileencoding=&encoding
    endif
  endfunction
  autocmd BufReadPost * call AU_ReCheck_FENC()
endif
" 改行コードの自動認識
set fileformats=unix,dos,mac
" □とか○の文字があってもカーソル位置がずれないようにする
if exists('&ambiwidth')
  set ambiwidth=double
endif

set nocompatible " be iMproved
filetype off

filetype plugin indent on " required!
filetype indent on
syntax on


set tabstop=2
set shiftwidth=2
set expandtab
map <C-M> :buffers<CR>
map <C-I> :vertical diffsplit


"vim tab

" Anywhere SID.
function! s:SID_PREFIX()
  return matchstr(expand('<sfile>'), '<SNR>\d\+_\zeSID_PREFIX$')
endfunction

" Set tabline.
function! s:my_tabline()  "{{{
  let s = ''
  for i in range(1, tabpagenr('$'))
    let bufnrs = tabpagebuflist(i)
    let bufnr = bufnrs[tabpagewinnr(i) - 1]  " first window, first appears

    let no = i  " display 0-origin tabpagenr.
    let mod = getbufvar(bufnr, '&modified') ? '!' : ' '
    let title = fnamemodify(bufname(bufnr), ':t')
    let title = '[' . title . ']'
    let s .= '%'.i.'T'
    let s .= '%#' . (i == tabpagenr() ? 'TabLineSel' : 'TabLine') . '#'
    let s .= no . ':' . title
    let s .= mod
    let s .= '%#TabLineFill# '
  endfor
  let s .= '%#TabLineFill#%T%=%#TabLine#'
  return s
endfunction "}}}
let &tabline = '%!'. s:SID_PREFIX() . 'my_tabline()'
set showtabline=2 " 常にタブラインを表示

" The prefix key.
nnoremap    [Tag]   <Nop>
nmap    t [Tag]
" Tab jump
for n in range(1, 9)
  execute 'nnoremap <silent> [Tag]'.n  ':<C-u>tabnext'.n.'<CR>'
endfor
" t1 で1番左のタブ、t2 で1番左から2番目のタブにジャンプ

map <silent> [Tag]c :tablast <bar> tabnew<CR>
" tc 新しいタブを一番右に作る
map <silent> [Tag]x :tabclose<CR>
" tx タブを閉じる
map <silent> [Tag]n :tabnext<CR>
" tn 次のタブ
map <silent> [Tag]p :tabprevious<CR>
" tp 前のタブ


" taglist
:set tags=tags

" markdown
" http://www.key-p.com/blog/staff/archives/9032
au BufRead,BufNewFile *.md set filetype=markdown

" colorscheme lucius


" 80行で折り返さないようにする
noremap <Plug>(ToggleColorColumn)
            \ :<c-u>let &colorcolumn = len(&colorcolumn) > 0 ? '' :
            \   join(range(81, 9999), ',')<CR>
" ノーマルモードの 'cc' に割り当てる
nmap cc <Plug>(ToggleColorColumn)
" 上記は日本語では効かないっぽい?
set formatoptions=q 

" バックアップとテンポラリファイルを$HOME/.vim/tmpに保存
set backup
set backupdir=$HOME/.vim/tmp
set swapfile
set directory=$HOME/.vim/tmp

" require brew install cmigemo
let g:ctrlp_use_migemo = 1
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/](\.(git|hg|svn)|vendor\/bundle)$',
  \ 'file': '\v\.(exe|so|dll)$',
  \ 'link': 'some_bad_symbolic_links',
  \ }

map <C-k> :Bufferlist<CR>
command Bd Buffetdelete
command Bot Buffetopentab
command Boh Buffetopenh

let g:unite_source_file_mru_limit = 100

let g:quickrun_config = {}
let g:quickrun_config.markdown = {
      \ 'outputter' : 'null',
      \ 'command'   : 'open',
      \ 'cmdopt'    : '-a',
      \ 'args'      : '/Application/Marked\ 2.app',
      \ 'exec'      : '%c %o %a %s:p',
      \ }


nnoremap <silent> ,uf :<C-u>Unite file_mru buffer<CR>
nnoremap <silent> ,ub :<C-u>Unite buffer<CR>
nnoremap <silent> ,ul :<C-u>Unite file<CR>

colorscheme desert

autocmd! FileType markdown hi! def link markdownItalic LineNr

vnoremap * "zy:let @/ = @z<CR>n

set undodir=$HOME/.vim/undo
set undodir=$HOME/.vim/tmp

" vim-indent-guides
let g:indent_guides_enable_on_vim_startup=1
let g:indent_guides_start_level=2
let g:indent_guides_guide_size = 1
set background=dark
hi IndentGuidesOdd  ctermbg=black
hi IndentGuidesEven ctermbg=darkgrey
" set background=light
" hi IndentGuidesOdd  ctermbg=white
" hi IndentGuidesEven ctermbg=lightgrey

" NERDTree
nnoremap <silent> ,ne :<C-u>NERDTreeToggle<CR>

" gundo.vim
nnoremap <silent> ,gu :<C-u>GundoToggle<CR>

" vim-markdown
let g:vim_markdown_folding_disabled=1

" to edit crontab
set backupskip=/tmp/*,/private/tmp/*

" vim-tags
let g:vim_tags_auto_generate = 1

" 検索時に該当行が画面中央に来るようにする
map n nzz
map N Nzz

" Railsのprivate以下はインデント付ける
let g:ruby_indent_access_modifier_style="indent"

" Python
autocmd FileType python setl autoindent
autocmd FileType python setl smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class
autocmd FileType python setl tabstop=8 expandtab shiftwidth=4 softtabstop=4

" unite-outline display right side
let g:unite_split_rule = 'botright'
noremap ,uo <ESC>:Unite -vertical -winwidth=40 outline<Return>

" flake8-vim
let g:PyFlakeOnWrite = 1

" quickrun
let g:quickrun_config={'*': {'split': ''}}
set splitbelow
set list
set listchars=tab:»-,trail:-,nbsp:%,eol:$

" 現在開いているファイルを実行 (only php|ruby|go)
function! ExecuteCurrentFile()
  if &filetype == 'php' || &filetype == 'ruby'
    exe '!' . &filetype . ' %'
  endif
  if &filetype == 'go'
    exe '!go run *.go'
  endif
endfunction
nnoremap <Space> :call ExecuteCurrentFile()<CR>
