" Vim syntax file for Technique language
" Language: Technique
" Maintainer: Andrew Cowie
" Latest Revision: 2025

if exists("b:current_syntax")
  finish
endif

" Keywords - must be whole words (only in code contexts)
syn keyword techniqueKeyword foreach in repeat contained

" Header metadata - anchored at start of line with optional whitespace
syn match techniqueHeader "^\s*%.*$"
syn match techniqueSPDX "^\s*!.*$"
syn match techniqueTemplate "^\s*&.*$"

" Titles - anchored at start with optional whitespace
syn match techniqueTitle "^\s*#.*$" contains=techniqueTitleMarker
syn match techniqueTitleMarker "^\s*#" contained

" Sections - uppercase roman numerals with period
syn match techniqueSection "^\s*[IVX]\+\."

" Steps - note the required space after period
syn match techniqueStepNumber "^\s*\d\+\.\s"
syn match techniqueSubstepLetter "^\s*[a-hj-uw-z]\.\s"
syn match techniqueSubsubstepRoman "^\s*[ivx]\+\.\s"
syn match techniqueParallelStep "^\s*-\s"

" Procedure declarations - must be at start of line
" Match the entire declaration line to prevent false matches
syn match techniqueProcedureDecl "^\s*[a-z][a-z0-9_]*\s*\(([^)]*)\)\?\s*:.*$" contains=techniqueProcedureName,techniqueProcedureParams,techniqueProcedureColon,techniqueSignature transparent
syn match techniqueProcedureName "^\s*\zs[a-z][a-z0-9_]*\ze\s*\(([^)]*)\)\?\s*:" contained
syn match techniqueProcedureParams "([^)]*)" contained contains=techniqueParameter
syn match techniqueParameter "[a-z][a-z0-9_]*" contained
syn match techniqueProcedureColon ":" contained

" Signatures (after the colon in procedure declarations)  
syn region techniqueSignature start=":\s*" end="$" contained contains=techniqueProcedureColon,techniqueForma,techniqueGenusList,techniqueGenusUnit,techniqueSignatureArrow,techniqueGenusTuple,techniqueComma transparent keepend

" Forma and Genus - only in signatures
syn match techniqueForma "\<[A-Z][A-Za-z0-9]*\>" contained
syn match techniqueGenusList "\[\s*[A-Z][A-Za-z0-9]*\s*\]" contained contains=techniqueForma,techniqueStructure
syn match techniqueGenusTuple "([^)]*)" contained contains=techniqueForma,techniqueComma,techniqueStructure
syn match techniqueGenusUnit "()" contained
syn match techniqueSignatureArrow "->" contained
syn match techniqueComma "," contained

" Role assignments (Attributes) - anchored at start of line
syn match techniqueAttribute "^\s*[@^][a-z][a-z0-9_]*\(\s*+\s*[@^][a-z][a-z0-9_]*\)*" contains=techniqueRole,techniquePlace,techniqueAttributeOperator
syn match techniqueRole "@[a-z][a-z0-9_]*" contained
syn match techniquePlace "[^][a-z][a-z0-9_]*" contained
syn match techniqueAttributeOperator "+" contained

" Basic structural elements - define first as they're used everywhere  
syn match techniqueStructure "[{}]" contained
syn match techniqueParameterParens "[()]" contained
syn match techniqueFunctionParens "[()]" contained
syn match techniqueBindingOperator "\~" contained

" Invocations <name>(params) - define before other patterns for precedence  
syn region techniqueInvocation matchgroup=techniqueInvocationBracket start="<" end=">" contains=techniqueTarget oneline keepend nextgroup=techniqueParameters

" Target and function patterns - define before regions that contain them
syn match techniqueTarget "\<[a-z][a-z0-9_]*\>" contained
syn match techniqueFunction "\<[a-z][a-z0-9_]*\>\ze\s*(" contained
syn match techniqueVariable "\<[a-z][a-z0-9_]*\>\ze\(\_s*(\)\@!" contained
syn match techniqueExpression "[a-z][a-z0-9_]*" contained
syn match techniqueIdentifier "[a-z][a-z0-9_]*" contained

" Binding patterns  
syn match techniqueBinding "\~\s\+[a-z][a-z0-9_]*" contained contains=techniqueBindingOperator,techniqueIdentifier
syn region techniqueParameters start="(" end=")" contained contains=techniqueParameterParens,techniqueExpression,techniqueComma,techniqueMultiline,techniqueString,techniqueNumeric

" Code blocks (Scopes) - function must be listed before variable for priority
syn region techniqueCodeBlock start="{" end="}" contains=techniqueStructure,techniqueKeyword,techniqueFunction,techniqueFunctionParens,techniqueBinding,techniqueInvocation,techniqueTablet,techniqueString,techniqueNumeric,techniqueMultiline,techniqueVariable keepend

" Bindings outside of code blocks (in Descriptives)
syn match techniqueDescriptiveBinding "\~\s\+[a-z][a-z0-9_]*" contains=techniqueBindingOperator,techniqueIdentifier
syn match techniqueDescriptiveBindingTuple "\~\s\+([^)]*)" contains=techniqueBindingOperator

" Strings - only in code/parameter/tablet contexts, not in descriptive text
syn region techniqueString start=+"+ skip=+\\"+ end=+"+ contained

" Tablet components - define before tablet region for proper containment
syn match techniqueTabletStructure "[\[\]]" contained
syn match techniqueTabletLabel +"[^"]*"\ze\s*=+ contained contains=techniqueTabletLabelText,techniqueTabletQuote
syn match techniqueTabletLabelText +[^"]\++ contained
syn match techniqueTabletQuote +"+ contained
syn match techniqueTabletEquals "=" contained

" Tablets (data structures with Pairs) - function before variable for priority
syn region techniqueTablet start="\[" end="\]" contains=techniqueTabletLabel,techniqueTabletEquals,techniqueTabletStructure,techniqueFunction,techniqueFunctionParens,techniqueComma,techniqueString,techniqueNumeric,techniqueVariable keepend

" Multiline strings with triple backticks
syn region techniqueMultiline matchgroup=techniqueMultilineDelimiter start=+```\w*+ end=+```+ contains=techniqueMultilineLanguage keepend
syn match techniqueMultilineLanguage +```\zs\w\++ contained

" Numeric literals (only in code/tablet/parameter contexts to avoid matching in text)
syn match techniqueNumeric "-\?\<\d\+\>" contained
syn match techniqueNumeric "-\?\<\d\+\.\d\+\>" contained

" Responses (enum values) - single quotes, no further parsing inside
syn match techniqueResponse "'[^']*'"
syn match techniqueResponseSeparator "|"


" Color definitions for Technique syntax elements
hi techniqueHeader guifg=#75507b ctermfg=96
hi techniqueSPDX guifg=#75507b ctermfg=96
hi techniqueTemplate guifg=#75507b ctermfg=96
hi techniqueProcedureName guifg=#3465a4 gui=bold ctermfg=25 cterm=bold
hi link techniqueProcedureParams techniqueStructure
hi techniqueParameter guifg=#729fcf gui=bold ctermfg=74 cterm=bold
hi link techniqueProcedureColon techniqueStructure
hi techniqueForma guifg=#8f5902 gui=bold ctermfg=94 cterm=bold
hi techniqueGenusList guifg=#8f5902 gui=bold ctermfg=94 cterm=bold
hi techniqueGenusTuple guifg=#8f5902 gui=bold ctermfg=94 cterm=bold
hi techniqueGenusUnit guifg=#8f5902 gui=bold ctermfg=94 cterm=bold
hi link techniqueSignatureArrow techniqueStructure
hi link techniqueComma techniqueStructure
hi techniqueTitle guifg=#ffffff gui=bold ctermfg=15 cterm=bold
hi techniqueTitleMarker guifg=#75507b ctermfg=96
hi techniqueSection guifg=#ffffff gui=bold ctermfg=15 cterm=bold
hi techniqueStepNumber guifg=#ffffff gui=bold ctermfg=15 cterm=bold
hi techniqueSubstepLetter guifg=#ffffff gui=bold ctermfg=15 cterm=bold
hi techniqueSubsubstepRoman guifg=#ffffff gui=bold ctermfg=15 cterm=bold
hi techniqueParallelStep guifg=#ffffff gui=bold ctermfg=15 cterm=bold
hi techniqueAttribute guifg=#ffffff gui=bold ctermfg=15 cterm=bold
hi techniqueRole guifg=#ffffff gui=bold ctermfg=15 cterm=bold
hi link techniqueAttributeOperator techniqueStructure
hi link techniqueInvocationBracket techniqueStructure
hi link techniqueParameterParens techniqueStructure
hi link techniqueFunctionParens techniqueStructure
hi techniqueTarget guifg=#3b5d7d gui=bold ctermfg=67 cterm=bold
hi link techniqueInvocationTarget techniqueTarget
hi link techniqueInvocationBrackets techniqueStructure
hi link techniqueInvocationName techniqueTarget
hi link techniqueParameters techniqueStructure
hi techniqueExpression guifg=#729fcf gui=bold ctermfg=74 cterm=bold
hi techniqueStructure guifg=#999999 gui=bold ctermfg=246 cterm=bold
hi link techniqueBindingOperator techniqueStructure
hi link techniqueDescriptiveBinding techniqueStructure
hi link techniqueDescriptiveBindingTuple techniqueStructure
hi link techniqueTabletStructure techniqueStructure
hi link techniqueTabletQuote techniqueStructure
hi link techniqueTabletEquals techniqueStructure
hi link techniqueMultilineDelimiter techniqueStructure
hi link techniqueResponseSeparator techniqueStructure
hi techniqueFunction guifg=#3465a4 gui=bold ctermfg=25 cterm=bold
hi techniqueIdentifier guifg=#729fcf gui=bold ctermfg=74 cterm=bold
hi techniqueVariable guifg=#729fcf gui=bold ctermfg=74 cterm=bold
hi techniqueTabletLabel guifg=#60989a gui=bold ctermfg=73 cterm=bold
hi techniqueTabletLabelText guifg=#60989a gui=bold ctermfg=73 cterm=bold
hi techniqueString guifg=#4e9a06 gui=bold ctermfg=28 cterm=bold
hi techniqueMultiline guifg=#4e9a06 gui=bold ctermfg=28 cterm=bold
hi techniqueMultilineLanguage guifg=#c4a000 gui=bold ctermfg=178 cterm=bold
hi techniqueResponse guifg=#f57900 gui=bold ctermfg=208 cterm=bold
hi techniqueNumeric guifg=#ad7fa8 gui=bold ctermfg=139 cterm=bold
hi techniqueKeyword guifg=#75507b gui=bold ctermfg=96 cterm=bold

" Syntax synchronization to fix highlighting when paging
" Look back up to 100 lines to find a good sync point
syn sync minlines=100

" Sync at procedure declarations (identifier followed by colon)
syn sync match techniqueSync grouphere NONE "^\s*[a-z][a-z0-9_]*\s*\(([^)]*)\)\?\s*:"

" Also sync at section headers and metadata lines
syn sync match techniqueSync grouphere NONE "^\s*[IVX]\+\."
syn sync match techniqueSync grouphere NONE "^\s*%"
syn sync match techniqueSync grouphere NONE "^\s*!"
syn sync match techniqueSync grouphere NONE "^\s*&"

" Clear sync on code blocks to prevent runaway regions
syn sync match techniqueSync grouphere techniqueCodeBlock "{"
syn sync match techniqueSync groupthere techniqueCodeBlock "}"

let b:current_syntax = "technique"
