# Abridge

> Abridge is your bridge to abbreviate code snippets that you often use.

Easily create custom context-aware snippets automatically expanded when recognized, or use the default ones provided. 

The snippets are only expanded when writing code, not in comments, strings.

![Animated screenshot](http://www.justindomingue.com/public/screenshot.gif)

## Installation

Either copy plugin/abridge.vim to ~/.vim/plugin/ or use pathogen :

    cd ~/.vim/bundle/
    git clone https://github.com/justindomingue/Abridge.git
    
## Usage

Abridge comes with some default snippets. The goal is not to be exahaustive, but rather to define commonly use snippets. 

For example, in a C file, Abridge defines useful snippets like `for`.

    for.<space>
        |
        |
        V
    for (<#int i = 0#>; <#i < 9#>; <#i++#>) {
      <#-#>
    }

Then use `,,` to loop through the *placeholders* (code defined between `<#...#>`). If the placeholder is `-`, Abridge enters insert mode automatically. Otherwise, it will simply select the placeholder. If you want to keep the placeholder, hit `,,` again. If not, hit `c` to change the visual selection and then `,,` again to select the next placeholder.

### Custom Snippets

You can define your own very easily. Add the command in your `.vimrc` :

    call Abridge("snippet", "expansion", "filetype")

- snippet: expanded expression
- expansion: abbreviation (contains <1> - see note below)
- filetype : file type on which to apply the abbreviation ('*' for all file types)

This command will create an abbreviation for `snippet+suffix` which will expand to `expansion` in file with type `filetype`.

**Note** suffix is a key used to better detect the user intent. A snippet will be expanded when the snippet is followed by the defined suffix. This defaults to '.'( see FAQ for how to modify suffix or remove it)

For example, 

    call Abridge("for", "for(<#int i = 0#>; <#i < 9#>; <#i++#>) {<CR><#-#><CR>}", "c,cpp")

Note that `suffix` is added automatically.

#### Placeholders

- `<#placeholder#>` visually selects `placeholder` when `,,` is hit
- `<#-#>` enters insert mode

### Mapping

- `,,` : go to next placeholder
  - if placeholder is `-`, enter insert mode
  - otherwise, visually select placeholder (hit `,,` again to keep it or `c` to change it)

## FAQ

### Change Mappings

#### Select Next Placeholder

`,,` is the default value. Overwrite the variable to change it

    let g:abridge_map_keys = "new_key"

#### Suffix

`.` is the default value. "" (empty string) will remove the suffix.

    let g:abridge_suffix_key = 'new_key'

### Disable Mapping

To overwrite the mapping keys, set `g:abridge_map_keys` to your preferred keys. For example,

    let g:abridge_map_keys = "<tab>"

### Disable Default Snippets

Add `let abridge_default_abb = 0` to your `vimrc`.

### Snippets are not expanded : 

`<SPACE>` might be mapped in insert mode by another plugin like AutoPairs. Run `:verbose imap <space>` to check. For now, you'll have to **disable autopairs**.
## Todo

- Add default snippets for more language (pull requests are welcomed!)
