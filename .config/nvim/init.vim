" Specify a directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin(stdpath('data') . '/plugged')

	Plug 'preservim/nerdtree' |
            \ Plug 'Xuyuanp/nerdtree-git-plugin'
	
	Plug 'neoclide/coc.nvim', {'branch': 'master', 'do': 'yarn install --frozen-lockfile'}
	Plug 'mhinz/vim-startify' 
	Plug 'ryanoasis/vim-devicons'
	Plug 'vimlab/split-term.vim'
	Plug 'blankname/vim-fish'
	Plug 'vim-airline/vim-airline'
	Plug 'vim-airline/vim-airline-themes'

source ~/.config/nvim/coc.nvim.vim

set guifont=DroidSansMono\ Nerd\ Font\ 11

if &shell =~# 'fish$'
    set shell=sh
endif

let g:airline_theme='ayu_mirage'
nnoremap <C-S-`> :Term<CR>
" Read ~/.NERDTreeBookmarks file and takes its second column
function! s:nerdtreeBookmarks()
    let bookmarks = systemlist("cut -d' ' -f 2- ~/.NERDTreeBookmarks")
    let bookmarks = bookmarks[0:-2] " Slices an empty last line
    return map(bookmarks, "{'line': v:val, 'path': v:val}")
endfunction

let g:startify_lists = [
        \ { 'type': function('s:nerdtreeBookmarks'), 'header': ['   NERDTree Bookmarks']}
        \]

 let g:startify_custom_header = split(system('figlet -w 100 NEOVIM'), '\n')


set  number

" returns all modified files of the current git repoW
" `2>/dev/null` makes the command fail quietly, so that when we are not
" in a git repo, the list will be empty
function! s:gitModified()
    let files = systemlist('git ls-files -m 2>/dev/null')
    return map(files, "{'line': v:val, 'path': v:val}")
endfunction

" Same as above, show untracked files, honouring .gitignore
function! s:gitUntracked()
    let files = systemlist('git ls-files -o --exclude-standard 2>/dev/null')
    return map(files, "{'line': v:val, 'path': v:val}")
endfunction

let g:startify_lists = [
        \ { 'type': 'files',     'header': ['   MRU']            },
        \ { 'type': 'dir',       'header': ['   MRU '. getcwd()] },
        \ { 'type': 'sessions',  'header': ['   Sessions']       },
        \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
        \ { 'type': function('s:gitModified'),  'header': ['   git modified']},
        \ { 'type': function('s:gitUntracked'), 'header': ['   git untracked']},
        \ { 'type': 'commands',  'header': ['   Commands']       },
        \ ]

" Start NERDTree when Vim starts with a directory argument.
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists('s:std_in') |
    \ execute 'NERDTree' argv()[0] | wincmd p | enew | execute 'cd '.argv()[0] | endif

nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>

call plug#end()
