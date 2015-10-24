set guifont=Ricty\ Regular\ for\ Powerline:h14
colorscheme lucius

".gvimrc カラー設定
""カラー設定した後にCursorIMを定義する方法
if has('multi_byte_ime')
  highlight Cursor guifg=NONE guibg=Green
  highlight CursorIM guifg=NONE guibg=Purple
endif
