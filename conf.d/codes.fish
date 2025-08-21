# ~/.config/fish/conf.d/code_management.fish
# ------------------------------------------------------------
# Manage a local code workspace in Fish shell
# Requirements: git, fzf, **fd** (command name `fd` or `fdfind` on Ubuntu)
# ------------------------------------------------------------

# 1. Persistent workspace variable (universal)
if not set -q CODE_BASE
    set -Ux CODE_BASE $HOME/codes
    set -Ux PYTHONPYCACHEPREFIX $HOME/.cache/pycache
end

# Ensure workspace directory exists
if not test -d $CODE_BASE
    mkdir -p $CODE_BASE
end

# ------------------------------------------------------------
# Helper: return the available fd command name (fd or fdfind)
function __fd_cmd --description "Return fd or fdfind if present"
    if type -q fd
        echo fd
    else if type -q fdfind
        echo fdfind
    end
end

# ------------------------------------------------------------
# Helper: list all Git repo roots under $CODE_BASE, one‑per‑line
function __list_git_roots --description "Print newline‑separated git repo roots"
    set -l roots
    set -l _fd (__fd_cmd)

    if test -n "$_fd"
        set roots ($_fd --hidden --follow --type f 'HEAD' $CODE_BASE 2>/dev/null \
            | sed "s|^$CODE_BASE/||" \
            | string match -r '.+/.git/HEAD$' \
            | while read -l f
                dirname (dirname $f)
            end \
            | sort -u)
    end

    if test (count $roots) -eq 0
        set roots (find $CODE_BASE -type f -name HEAD -path '*/.git/HEAD' 2>/dev/null \
            | while read -l f
                dirname (dirname $f)
            end \
            | sort -u)
    end

    # Output each root on its own line so downstream commands (fzf) read correctly
    if test (count $roots) -gt 0
        printf '%s\n' $roots
    end
end

# ------------------------------------------------------------
# gcll: clone repo preserving host/user path into $CODE_BASE
function gcll --description "Clone git repo into $CODE_BASE preserving path"
    if test (count $argv) -ne 1
        echo "usage: gcll <git-url>"; return 1
    end
    set -l url $argv[1]

    set -l path
    if string match -qr '^git@' $url
        # git@host:user/repo(.git)
        set -l tmp (string replace -r '^git@' '' $url)   # host:user/repo.git
        set tmp (string replace ':' '/' $tmp)             # host/user/repo.git
        set path $tmp
    else if string match -qr '^[a-z]+://' $url
        # https://host/user/repo.git  or git://host/user/repo.git
        set path (string replace -r '^[a-z]+://([^/]+)/(.*)' '$1/$2' $url)
    else
        echo "Unrecognized URL format"; return 1
    end

    # strip trailing .git suffix
    set path (string replace -r '\\.git$' '' $path)

    set -l dest "$CODE_BASE/$path"
    if test -d $dest
        echo "Already exists: $dest"; return 0
    end

    mkdir -p (dirname $dest)
    git clone $url $dest
end

# ------------------------------------------------------------
# code-switch: fzf pick & cd
function code-switch --description "fzf-select git repo under $CODE_BASE and cd into it"
    set -l repos (__list_git_roots)
    if test -z "$repos"
        echo "No Git projects found under $CODE_BASE"; return 1
    end

    set -l target $CODE_BASE/(printf '%s\n' $repos | fzf --prompt 'Select project> ')
    if test -n "$target"
        cd "$target"
    end
end

# ------------------------------------------------------------
# Key binding: Alt/Option + c  (Esc c)
bind \ec code-switch
