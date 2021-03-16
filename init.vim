" 获取当前init.vim所在目录
let s:home = fnamemodify(resolve(expand('<sfile>:p')), ':h')

" 设置leader键
let g:mapleader="\<space>"

" --------------------
" -----加载插件
" -----
call plug#begin(get(g:, 'bundle_home', s:home . '/bundles'))
" 启动界面
Plug 'mhinz/vim-startify'
" 状态栏的滚动条
Plug 'ojroques/vim-scrollstatus'
" 显示symbols和tags
Plug 'liuchengxu/vista.vim'
" 快速选择
Plug 'gcmt/wildfire.vim'
" undotree
Plug 'mbbill/undotree'
" 自动补全插件(支持LSP)
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" jsx高亮，解决tsx文件没有高亮的问题
Plug 'leafgarland/typescript-vim'
Plug 'maxmellon/vim-jsx-pretty'
" 代码片段snippets
Plug 'honza/vim-snippets'
" 注释插件
Plug 'scrooloose/nerdcommenter'
" 显示缩进线
Plug 'yggdroot/indentline'
" 调试插件
Plug 'puremourning/vimspector'
" vimspector配置文件模板生成
Plug 'lmissou/vimspector-template'
" 主题
Plug 'mhartington/oceanic-next'
Plug 'nanotech/jellybeans.vim'
Plug 'rakr/vim-one'
" 美化底部状态栏
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" icon支持
Plug 'ryanoasis/vim-devicons'
" 热键提示插件
Plug 'liuchengxu/vim-which-key'
" editorconfig插件
Plug 'editorconfig/editorconfig-vim'
" 光标快速跳转插件
Plug 'easymotion/vim-easymotion'
" 多光标插件
Plug 'mg979/vim-visual-multi'
" 自动切换工作目录
Plug 'airblade/vim-rooter'
" 包围，括号，引号插件
Plug 'tpope/vim-surround'
" rainbow彩虹括号插件
Plug 'kien/rainbow_parentheses.vim'
" 格式化插件
Plug 'chiel92/vim-autoformat'
" 自定义文本对象textobj
Plug 'kana/vim-textobj-user'
" markdown
Plug 'suan/vim-instant-markdown', {'for': 'markdown'}
" org-mode
Plug 'jceb/vim-orgmode'
call plug#end()

" --------------------
" -----优化默认配置
" -----
" 设置主题
set t_Co=256
syntax enable
set background=dark
colorscheme OceanicNext
" 开启powerline字体
let g:airline_powerline_fonts = 1
" 开启行号显示
set number
" 缓冲区未保存时也可以切换到后台
set hidden
set updatetime=300
" 设置utf8编码
set encoding=UTF-8
" 开启鼠标
set mouse=a
" 设置4空格缩进
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
" 设置空白字符的视觉提示
set list listchars=extends:❯,precedes:❮,tab:▸-,trail:˽
" 高亮当前行和当前列
set cursorline
set cursorcolumn
" 不生成备份文件
set nobackup
set nowritebackup
" 查找时忽略大小写
set ic
" Don't pass messages to |ins-completion-menu|.
set shortmess+=c
" 一直启用彩虹括号
au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces
" scrollbar
let g:airline_section_x = '%{ScrollStatus()}'
" vimspector
let g:vimspector_enable_mappings = 'HUMAN'
" markdown关闭自动预览
let g:instant_markdown_autostart = 0
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
" -----自定义文本对象textobj配置
" -----
function! CurrentLineA()
  normal! 0
  let head_pos = getpos('.')
  normal! $
  let tail_pos = getpos('.')
  return ['v', head_pos, tail_pos]
endfunction

function! CurrentLineI()
  normal! ^
  let head_pos = getpos('.')
  normal! g_
  let tail_pos = getpos('.')
  let non_blank_char_exists_p = getline('.')[head_pos[2] - 1] !~# '\s'
  return
  \ non_blank_char_exists_p
  \ ? ['v', head_pos, tail_pos]
  \ : 0
endfunction
call textobj#user#plugin('datetime', {
\   'date': {
\     'pattern': '\<\d\d\d\d-\d\d-\d\d\>',
\     'select': ['ad', 'id'],
\   },
\   'time': {
\     'pattern': '\<\d\d:\d\d:\d\d\>',
\     'select': ['at', 'it'],
\   },
\ })
call textobj#user#plugin('line', {
\   '-': {
\     'select-a-function': 'CurrentLineA',
\     'select-a': 'al',
\     'select-i-function': 'CurrentLineI',
\     'select-i': 'il',
\   },
\ })
" coc定义的函数以及类的textobj
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" --------------------
" -----coc配置
" -----
let g:coc_global_extensions = [
    \ 'coc-postfix',
    \ 'coc-floatinput',
    \ 'coc-calc',
    \ 'coc-highlight',
    \ 'coc-tabnine',
    \ 'coc-git',
    \ 'coc-pairs',
    \ 'coc-omnisharp',
    \ 'coc-go',
    \ 'coc-clangd',
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
    \ 'coc-eslint',
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

" --------------------
" -----快捷键
" -----
" 翻译
vnoremap <silent> <C-T> :<C-u>CocCommand translator.popup<CR>
nnoremap <silent> <C-T> :<C-u>CocCommand translator.popup<CR>
" 模糊搜索文件
noremap <C-p> :CocList files<CR>
" undotree
nnoremap <leader>u :UndotreeToggle<CR>
" vista
nnoremap <leader>t :Vista!!<CR>

" 开启vim-which-key热键提示
let g:which_key_map = {}

" 设置快捷键
inoremap jk <Esc>
nnoremap <leader>q :q<CR>
let g:which_key_map['q'] = '退出'
" 模糊搜索vim命令
nnoremap <leader>: :CocList vimcommands<CR>
let g:which_key_map[':'] = 'vim命令'
let g:which_key_map['w'] = {
    \ 'name': '+窗口',
    \ 's': [':Startify', '打开开始界面'],
    \ 'h': [':vsplit', '横向分割窗口'],
    \ 'v': [':split', '纵向分割窗口'],
    \ 'o': [':only', '仅保留当前窗口'],
    \ 'q': [':wq', '保存并退出'],
    \ }
let g:which_key_map['b'] = {
    \ 'name' : '+缓冲区',
    \ 'b': [':CocList buffers', '显示所有'],
    \ 'd': [':bdelete', '关闭'],
    \ 'n': [':bnext', '下一个'],
    \ 'p': [':bprevious', '上一个'],
    \ }
let g:which_key_map['f'] = {
    \ 'name': '+文件',
    \ 'f': [':CocList files', '文件列表'],
    \ 'r': [':CocList mru', '历史文件列表'],
    \ 't': [':CocCommand explorer', '打开目录树'],
    \ 's': [':CocList grep', '全局搜索'],
    \ }
let g:which_key_map['l'] = {
    \ 'name': '+编程语言',
    \ 'a': ['<Plug>(coc-codeaction-selected)', 'CodeAction'],
    \ 'r': ['<Plug>(coc-rename)', '重命名symbol'],
    \ 'f': ['<Plug>(coc-format-selected)', '格式化代码'],
    \ 'F': ['<Plug>(coc-fix-current)', '修复错误'],
    \ }
" 注册which-key按键映射
call which_key#register(g:mapleader, "g:which_key_map")
nnoremap <silent> <leader> :<c-u>WhichKey '<leader>'<CR>
vnoremap <silent> <leader> :<c-u>WhichKeyVisual '<leader>'<CR>

