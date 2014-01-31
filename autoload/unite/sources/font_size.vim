let s:save_cpo = &cpo
set cpo&vim

let s:unite_source = {
      \ 'name': 'font/size',
      \ 'hooks': {},
      \ 'action_table': {'*': {}}
      \ }

function! s:unite_source.hooks.on_init(args, context)
  let s:initial_guifont = &guifont
endfunction

function! s:unite_source.hooks.on_close(args, context)
  if s:initial_guifont == &guifont
    unlet s:initial_guifont
    return
  endif

  let &guifont = s:initial_guifont
  unlet s:initial_guifont
endfunction

function! s:unite_source.gather_candidates(args, context)
  let current_guifont_name = split(s:initial_guifont, ':')[0]
  let sizes = [8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20]

  let template = "let &guifont='%s:h%s'"
  return map(sizes, '{
        \ "word": string(v:val),
        \ "source": "font/size",
        \ "kind": "command",
        \ "action__command": printf(template, current_guifont_name, string(v:val))
        \}')
endfunction

let s:unite_source.action_table['*'].preview = {
\ 'description' : 'preview this font',
\ 'is_quit' : 0,
\ }

function! s:unite_source.action_table['*'].preview.func(candidate)
  execute a:candidate.action__command
endfunction

function! unite#sources#font_size#define()
  return has('gui_running') ? s:unite_source : []
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

