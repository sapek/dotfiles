" Vim syntax file
" Language: Bond
" Maintainer: Martin Smith <martin@facebook.com>
" Last Change: $Date: $
"
" $Id: $
"
" Licensed to the Apache Software Foundation (ASF) under one
" or more contributor license agreements. See the NOTICE file
" distributed with this work for additional information
" regarding copyright ownership. The ASF licenses this file
" to you under the Apache License, Version 2.0 (the
" "License"); you may not use this file except in compliance
" with the License. You may obtain a copy of the License at
"
"   http://www.apache.org/licenses/LICENSE-2.0
"
" Unless required by applicable law or agreed to in writing,
" software distributed under the License is distributed on an
" "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
" KIND, either express or implied. See the License for the
" specific language governing permissions and limitations
" under the License.
"

if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

" Todo
syn keyword bondTodo TODO todo FIXME fixme XXX xxx contained

" Comments
syn match bondComment "//.*" contains=bondTodo,@Spell
syn region bondComment start="/\*" end="\*/" contains=bondTodo,@Spell

" Keywords
syn keyword bondStatement namespace
syn keyword bondInclude import
syn keyword bondValues nothing true false
syn keyword bondKeyword optional required required_optional
syn keyword bondStatement using
syn keyword bondBasicTypes bool string wstring blob
syn keyword bondBasicTypes int8 int16 int32 int64 
syn keyword bondBasicTypes uint8 uint16 uint32 uint64 float double
syn keyword bondType map list set vector bonded nullable
syn keyword bondClass struct enum
syn region  bondString start=+"+ end=+"+
syn region  bondAttributeVal start=+"+ end=+"+ contained
syn region bondAttribute start="\[" end="\]" contains=bondAttributeName,bondAttributeVal
syn match bondAttributeName "[0-9A-Za-z_]\+" contained

" Special
syn match bondNumber "\d\+:"

if version >= 508 || !exists("did_bond_syn_inits")
  if version < 508
    let did_bond_syn_inits = 1
    command! -nargs=+ HiLink hi link <args>
  else
    command! -nargs=+ HiLink hi def link <args>
  endif

  HiLink   bondComment      Comment
  HiLink   bondKeyword      Keyword
  HiLink   bondValues       Keyword
  HiLink   bondBasicTypes   Type
  HiLink   bondType         Type
  HiLink   bondTodo         Todo
  HiLink   bondString       String
  HiLink   bondNumber       Number
  HiLink   bondAttributeName Identifier
  HiLink   bondAttributeVal String
  HiLink   bondStatement    Statement
  HiLink   bondInclude      Include
  HiLink   bondClass        Type

  delcommand HiLink
endif

let b:current_syntax = "bond"

