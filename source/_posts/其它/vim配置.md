
---
title:
  - vim配置 
date:
  - 2020-05-24 23:53:00
tags:
  - vim
  - linux
  - 终端
categories:
  - 其它
---
### neovim

增强版vim

安装[neovim](https://neovim.io/)

[导入vim的配置文件](https://neovim.io/doc/user/nvim.html#nvim-from-vim)

<!-- more -->
### vim-plug
vim插件管理[vim-plug](https://github.com/junegunn/vim-plug)

执行`vim -c 'PlugInstall|q'`会安装.vimrc中的所有插件

### 文件树
[nerdtree](https://github.com/preservim/nerdtree)

默认配置下的常用快捷键

|快捷键|效果|
|------|----------------------|
|`Ctrl+n`|打开文件树|
|`m`|打开选项菜单(可在菜单中选择进行创建、删除操作)|

### 底部状态栏
[lightline](https://github.com/itchyny/lightline.vim)

### markdown预览
[markdown-preview.nvim](https://github.com/iamcco/markdown-preview.nvim)

vim中运行`:PreviewMarkdown`后会在浏览器中打开markdown实时预览

### 代码提示、补全、跳转
[coc.nvim](https://github.com/neoclide/coc.nvim)

这个需要安装对应的language
server才能进行补全，除了代码补全，还可以通过安装coc插件实现很多其他功能，但我这里只用作代码提示、补全、跳转

可选的插件可以通过[npmjs.com](https://www.npmjs.com/search?q=keywords%3Acoc.nvim&page=0&perPage=20&ranking=popularity)查看

推荐通过[coc-marketplace](https://github.com/fannheyward/coc-marketplace)安装coc插件/Language Server

[官方文档](https://github.com/neoclide/coc.nvim/wiki/Using-coc-extensions#implemented-coc-extensions)给出了部分插件列表

官方文档默认配置中的快捷键

|快捷键|说明|
|--------------------|-----------------|
|插入模式：`tab`|在候选补全项目间切换|
|普通模式：`Ctrl+space`|显示代码补全提示|
|普通模式：`K` |显示函数文档|
|普通模式：`[g`|代码诊断-上一条|
|普通模式：`]g`|代码诊断-下一条|
|普通模式：`space a`|显示所有代码诊断信息|
|普通模式：`gd`|跳转到函数定义 go definition|
|普通模式：`gy`|跳转到类型定义 go type definition|
|普通模式：`gi`|go implementation|
|普通模式：`gr`|跳转到函数调用位置 go references|
|普通模式：`rn`|重命名变量 rename|
|可视模式 或 普通模式：`\f`|格式化代码 formatting selected code|
|普通模式：`\qf`|快速（自动）修复代码问题 quick fix|
|操作等待 或 可视模式：`if`|选定function内的代码块 in function|
|操作等待 或 可视模式：`ic`|选定class内的代码块 in class|
|操作等待 或 可视模式：`af`|选定整个function的代码 all of function|
|操作等待 或 可视模式：`ac`|选定整个class的代码 all of class|
|普通模式：`zO`|递归展开代码块|
|普通模式：`zo`|展开一级代码块|
|普通模式：`zC`|递归折叠代码块|
|普通模式：`zc`|折叠一级代码块|
|普通模式：`space o`|显示当前文件中所有的变量、函数|

常用命令

|命令|说明|
|-------------|-------------|
|`:Format`|格式化当前文档|
|`:OR`|整理import语句 organize imports|
|`:Fold`|折叠代码|

### .vimrc
```.vimrc
    "快捷键映射
    map R     :source ~/.vimrc<CR>
    map S     :w<CR>
    map <C-n> :NERDTreeToggle<CR>

    """"""""""""""""""""""""""""""""""""""""""
    """"""""""""插件
    call plug#begin('~/.vim/plugged')
    "提供各种语言的语法分析支持
    "Plug 'sheerun/vim-polyglot'
    "文件树
    Plug 'preservim/nerdtree'
    "代码补全
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    "打开文件时自动打开文件树
    "autocmd vimenter * NERDTree
    "markdown自动折叠
    "Plug 'godlygeek/tabular'
    "Plug 'plasticboy/vim-markdown'
    "markdown预览
    Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install'  }
    "底部状态栏
    Plug 'itchyny/lightline.vim'
    "自动打开markdown预览窗口
    "let g:mkdp_auto_start = 1
    call plug#end()
    """"""""""""""""""""""""""""""""""""""""""

    """"""""""""""""""""""""""""""""""""""""""
    """"""""自动补全插件coc.nvim相关配置
    """"""""https://github.com/neoclide/coc.nvim
    "使vim能够解析coc.nvim的json配置文件的注释语法
    autocmd FileType json syntax match Comment +\/\/.\+$+
    "如果不设置这一项，可能会影响自动补全工作
    set hidden

    "不创建备份文件
    "自动补全的部分language server可能会受到备份文件的影响
    set nobackup
    set nowritebackup

    "为自动补全消息提供更大的显示空间
    set cmdheight=2

    "自动补全更新延时 默认是4000ms
    set updatetime=300

    "Don't pass messages to |ins-completion-menu|
    set shortmess+=c

    " Always show the signcolumn, otherwise it would shift the text each time
    " diagnostics appear/become resolved.
    if has("patch-8.1.1564")
      " Recently vim can merge signcolumn and number column into one
      set signcolumn=number
    else
      set signcolumn=yes
    endif

    " 使用tab键来选择首个候选项
    " NOTE: 使用命令':verbose imap <tab>' 查看tab键是否被其它插件使用
    inoremap <silent><expr> <TAB>
          \ pumvisible() ? "\<C-n>" :
          \ <SID>check_back_space() ? "\<TAB>" :
          \ coc#refresh()
    inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

    function! s:check_back_space() abort
      let col = col('.') - 1
      return !col || getline('.')[col - 1]  =~# '\s'
    endfunction

    " 使用 <c-space> 触发代码补全提示
    inoremap <silent><expr> <c-space> coc#refresh()

    " 使用<cr> 确认代码补全选项, `<C-g>u` means break undo chain at current
    " position. Coc only does snippet and additional edit on confirm.
    " <cr> could be remapped by other vim plugin, try `:verbose imap <CR>`.
    if exists('*complete_info')
      inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
    else
      inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
    endif

    " Use `[g` and `]g` to navigate diagnostics
    nmap <silent> [g <Plug>(coc-diagnostic-prev)
    nmap <silent> ]g <Plug>(coc-diagnostic-next)

    " GoTo code navigation.
    nmap <silent> gd <Plug>(coc-definition)
    nmap <silent> gy <Plug>(coc-type-definition)
    nmap <silent> gi <Plug>(coc-implementation)
    nmap <silent> gr <Plug>(coc-references)

    " Use K to show documentation in preview window.
    nnoremap <silent> K :call <SID>show_documentation()<CR>

    function! s:show_documentation()
      if (index(['vim','help'], &filetype) >= 0)
        execute 'h '.expand('<cword>')
      else
        call CocAction('doHover')
      endif
    endfunction

    " Highlight the symbol and its references when holding the cursor.
    autocmd CursorHold * silent call CocActionAsync('highlight')

    " Symbol renaming.
    nmap <leader>rn <Plug>(coc-rename)

    " Formatting selected code.
    xmap <leader>f  <Plug>(coc-format-selected)
    nmap <leader>f  <Plug>(coc-format-selected)

    augroup mygroup
      autocmd!
      " Setup formatexpr specified filetype(s).
      autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
      " Update signature help on jump placeholder.
      autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
    augroup end
    " Applying codeAction to the selected region.
    " Example: `<leader>aap` for current paragraph
    xmap <leader>a  <Plug>(coc-codeaction-selected)
    nmap <leader>a  <Plug>(coc-codeaction-selected)

    " Remap keys for applying codeAction to the current buffer.
    nmap <leader>ac  <Plug>(coc-codeaction)
    " Apply AutoFix to problem on the current line.
    nmap <leader>qf  <Plug>(coc-fix-current)

    " Map function and class text objects
    " NOTE: Requires 'textDocument.documentSymbol' support from the language server.
    xmap if <Plug>(coc-funcobj-i)
    omap if <Plug>(coc-funcobj-i)
    xmap af <Plug>(coc-funcobj-a)
    omap af <Plug>(coc-funcobj-a)
    xmap ic <Plug>(coc-classobj-i)
    omap ic <Plug>(coc-classobj-i)
    xmap ac <Plug>(coc-classobj-a)
    omap ac <Plug>(coc-classobj-a)

    " Use CTRL-S for selections ranges.
    " Requires 'textDocument/selectionRange' support of LS, ex: coc-tsserver
    nmap <silent> <C-s> <Plug>(coc-range-select)
    xmap <silent> <C-s> <Plug>(coc-range-select)

    " Add `:Format` command to format current buffer.
    command! -nargs=0 Format :call CocAction('format')

    " Add `:Fold` command to fold current buffer.
    command! -nargs=? Fold :call     CocAction('fold', <f-args>)

    " Add `:OR` command for organize imports of the current buffer.
    command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

    " Add (Neo)Vim's native statusline support.
    " NOTE: Please see `:h coc-status` for integrations with external plugins that
    " provide custom statusline: lightline.vim, vim-airline.
    "set statusline=%{coc#status()}

    " Mappings using CoCList:
    " Show all diagnostics.
    nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
    " Manage extensions.
    nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
    " Show commands.
    nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
    " Find symbol of current document.
    nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
    " Search workspace symbols.
    nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
    " Do default action for next item.
    nnoremap <silent> <space>j  :<C-u>CocNext<CR>
    " Do default action for previous item.
    nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
    " Resume latest coc list.
    nnoremap <silent> <space>p  :<C-u>CocListResume<CR>
    " coc-highlight，高亮显示当前变量
    autocmd CursorHold * silent call CocActionAsync('highlight')
    """"""""""""""""""""""""""""""""""""""""""
    "代码高亮
    syntax on
    "不与vi兼容
    set nocompatible
    "在底部显示，当前处于命令模式还是插入模式
    set showmode
    ""命令模式下，在底部显示当前键入的命令
    set showcmd
    "支持使用鼠标
    "set mouse=a
    ""使用utf-8编码
    set encoding=utf-8
    "启用256色
    set t_Co=256
    "开启文件类型检查，并且载入与该类型对应的缩进规则。
    filetype indent on
    "按下回车键后，下一行的缩进会自动跟上一行的缩进保持一致
    set autoindent
    ""按下Tab键后vim显示的空格数
    set tabstop=2
    "在文本上按下>>（增加一级缩进）、<<（取消一级缩进）或者==（取消全部缩进）时，每一级的字符数
    set shiftwidth=4
    "由于Tab键在不同的编辑器缩进不一致，该设置自动将Tab转为空格
    set expandtab
    "Tab转为多少个空格
    set softtabstop=2
    "显示行号
    set number
    "显示光标所在的当前行的行号，其他行都为相对于该行的相对行号
    set relativenumber
    "光标所在的当前行高亮
    set cursorline
    "设置行宽，即一行显示多少个字符
    set textwidth=80
    "自动折行，即太长的行分成几行显示
    set wrap
    "关闭自动折行
    "set nowrap
    "制定折行处与编辑窗口的右边缘之间空出的字符数
    set wrapmargin=2
    "垂直滚动时，光标距离顶部/底部的位置（单位：行）
    set scrolloff=5
    "水平滚动时，光标距离行首或行尾的位置（单位：字符）。该配置在不折行时比较有用
    set sidescrolloff=15
    "是否显示状态栏。0 表示不显示，1 表示只在多窗口时显示， 2 表示显示
    set laststatus=2
    "在状态栏显示光标当前位置（位于哪一行哪一列）
    set ruler
    "光标遇到圆括号、方括号、大括号时，自动高亮对应的另一个圆括号、方括号和大括号。
    set showmatch
    "搜索时高亮匹配结果
    set hlsearch
    "输入搜索模式时，每输入一个字符，就自动跳到第一个匹配的结果。
    set incsearch
    "搜索时忽略大小写
    set ignorecase
    "如果同事打开了ignorecase，那么对于只有一个大写字母的搜索词，将大小写敏感；其他情况都是大小写不敏感。比如，搜索Test时，将不匹配test；搜索test时，将匹配Test
    "set smartcase
    "打开英语单词的拼写检查
    "set spell spelllang=en_us

    "不创建交换文件，交换文件主要用于系统崩溃时恢复文件，文件名的开头是".",结尾是".swp"
    "set noswapfile
    "保留撤销历史
    "Vim 会在编辑时保存操作历史，用来供用户撤消更改。默认情况下，操作记录只在本次编辑时有效，一旦编辑结束、文件关闭，操作历史就消失了。
    "打开这个设置，可以在文件关闭后，操作记录保留在一个文件里面，继续存在。这意味着，重新打开一个文件，可以撤销上一次编辑时的操作。撤消文件是跟原文件保存在一起的隐藏文件，文件名以.un~开头。
    "set undofile
    "设置备份文件、交换文件、操作历史文件的保存位置。
    "结尾的//表示生成的文件名带有绝对路径，路径中用%替换目录分隔符，这样可以防止文件重名。
    set backupdir=~/.vim/.backup//
    set directory=~/.vim/.swp//
    set undodir=~/.vim/.undo//
    "自动切换工作目录。这主要用在一个 Vim 会话之中打开多个文件的情况，默认的工作目录是打开的第一个文件的目录。该配置可以将工作目录自动切换到，正在编辑的文件的目录。
    set autochdir
    "出错时，不要发出响声
    "set noerrorbells
    "出错时，发出视觉提示，通常是屏幕闪烁
    "set visualbell
    "vim需要记住多少次历史操作
    set history=1000
    "打开文件监视，如果在编辑过程中文件发生外部改变（比如被别的编辑器编辑了），就会发出提示
    set autoread
    "命令模式下，底部操作指令按下 Tab 键自动补全。第一次按下 Tab，会显示所有匹配的操作指令的清单；第二次按下 Tab，会依次选择各个指令。
    set wildmenu
    set wildmode=longest:list,full

```
