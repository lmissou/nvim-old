" 获取当前init.vim所在目录
let s:home = fnamemodify(resolve(expand('<sfile>:p')), ':h')
" 将当前初始化目录加入runtimepath
exec 'set rtp+='.s:home

" 设置leader键
let g:mapleader="\<Space>"

" 定义一个命令用来加载文件
command! -nargs=1 LoadScript exec 'so '.s:home.'/'.'<args>'

" --------------------
" -----加载插件
" -----
call plug#begin(get(g:, 'bundle_home', s:home . '/bundles'))
" 启动界面
Plug 'mhinz/vim-startify'
" 自动补全插件(支持LSP)
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" 调试插件
Plug 'puremourning/vimspector'
" 主题
Plug 'tomasr/molokai'
Plug 'morhetz/gruvbox'
" 美化底部状态栏
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" 热键提示插件
Plug 'liuchengxu/vim-which-key'
" 全局搜索ctrlp插件
Plug 'kien/ctrlp.vim'
" editorconfig插件
Plug 'editorconfig/editorconfig-vim'
" 光标快速跳转插件
Plug 'easymotion/vim-easymotion'
call plug#end()

" --------------------
" -----优化默认配置
" -----
" 设置主题
set t_Co=256
colorscheme gruvbox
set background=dark
" 开启行号显示
set number
" 缓冲区未保存时也可以切换到后台
set hidden
" 开启鼠标
set mouse=a
" 设置4空格缩进
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
" 显示控制字符
" set list listchars=tab:▸-,eol:↩︎,extends:❯,precedes:❮,trail:˽
" 设置空白字符的视觉提示
set list listchars=extends:❯,precedes:❮,tab:▸-,trail:˽
" 高亮当前行和当前列
set cursorline
set cursorcolumn
" ctrlp设置默认查找路径
let g:ctrlp_working_path_mode = 'cr'
" 不生成备份文件
set nobackup
set nowritebackup
" Don't pass messages to |ins-completion-menu|.
set shortmess+=c
" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
" 左侧行号和错误提示共用
if has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

" --------------------
" -----coc配置
" -----
let g:coc_global_extensions = [
    \ 'coc-actions',
    \ 'coc-css',
    \ 'coc-explorer',
    \ 'coc-gitignore',
    \ 'coc-html',
    \ 'coc-json',
    \ 'coc-lists',
    \ 'coc-python',
    \ 'coc-snippets',
    \ 'coc-stylelint',
    \ 'coc-syntax',
    \ 'coc-tasks',
    \ 'coc-translator',
    \ 'coc-tslint-plugin',
    \ 'coc-tsserver',
    \ 'coc-vimlsp',
    \ 'coc-vetur',
    \ 'coc-yaml',
    \ 'coc-yank']
" 高亮当前光标所在的symbol
autocmd CursorHold * silent call CocActionAsync('highlight')
" 使用TAB补全
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction
" Enter键确认补全
if exists('*complete_info')
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif
" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" --------------------
" -----快捷键
" -----
" insert模式自由移动
" 移动到行首和行尾
noremap <C-A> <Esc>^i
noremap <C-E> <Esc>$a
" 移动光标
noremap <C-L> <Right>
noremap <C-H> <Left>
noremap <C-J> <Down>
noremap <C-K> <Up>

" 开启vim-which-key热键提示
let g:which_key_map = {}

" 设置快捷键
nnoremap <leader>q :q<CR>
let g:which_key_map['q'] = '退出'
let g:which_key_map['w'] = {
    \ 'name': '+窗口',
    \ 'o': ['only', '仅保留当前窗口'],
    \ 'q': ['wq', '保存并退出'],
    \ }
let g:which_key_map['b'] = {
    \ 'name' : '+缓冲区',
    \ 'a': ['buffers', '显示所有'],
    \ 'd': ['bd', '关闭'],
    \ 'n': ['bnext', '下一个'],
    \ 'p': ['bprevious', '下一个'],
    \ }
let g:which_key_map['f'] = {
    \ 'name': '+文件',
    \ 't': [':CocCommand explorer', '打开目录树'],
    \ }
" 注册which-key按键映射
call which_key#register('<Space>', "g:which_key_map")
nnoremap <silent> <leader> :<c-u>WhichKey '<Space>'<CR>
vnoremap <silent> <leader> :<c-u>WhichKeyVisual '<Space>'<CR>
nnoremap <silent> <localleader> :<c-u>WhichKey '<M-Space>'<CR>
vnoremap <silent> <localleader> :<c-u>WhichKeyVisual '<M-Space>'<CR>

