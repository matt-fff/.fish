export BROWSER=/usr/bin/firefox

if status is-interactive
    # Commands to run in interactive sessions can go here

    function fish_greeting
        #echo Hey $USER - don\'t (set_color green)fuck(set_color normal) shit up\ (set_color yellow)
    end

    export VISUAL=nvim
    export EDITOR=nvim

    
    ### Kitty Start #########################
    
    # Completion for kitty
    function __kitty_completions
        # Send all words up to the one before the cursor
        commandline -cop | kitty +complete fish
    end
    
    # complete -f -c kitty -a "(__kitty_completions)"
    
    ### Kitty End #########################
    
    
    ### Desk Start #########################
    # Hook for desk activation
    [ -n "$DESK_ENV" ] && source "$DESK_ENV" || true
    
    set -q TMUX && set tsession (tmux display-message -p "#S")
    
    
    # strip suffixes so that you can make
    # multiple instances of the same desk
    # by using deskname-1, deskname-2, etc
    set desk (echo "$tsession" | sed -E "s/-[0-9]+\$//g")
    
    if [ "x$tsession" != "x" ] && [ "$tsession" != "$WITHIN_DESK" ]
    	export WITHIN_DESK="$tsession"
    	desk . "$desk"
    end
    
    ### Desk End #########################

    ### AWS stuff #########################
    #export AWS_ACCOUNT=
    #export AWS_REGION=
    #export AWS_ECR="$AWS_ACCOUNT.dkr.ecr.$AWS_REGION.amazonaws.com"
    
    alias docker-aws-auth="aws ecr get-login-password | docker login --username AWS --password-stdin $AWS_ECR"
    
    
    ### Aliases/Functions Start #########################
    
    function nuke -d 'Aggressively kill a process.'
      ps -aux | grep -i $argv | grep -v 'grep ' | sed -E 's/[^0-9]*([0-9]+)\b.*/\1/g' | xargs sudo kill -s 9
    end
    
    function tm -d 'tmux create session or attach if it exists.'
      tmux attach -t $argv || tmux new-session -s $argv
    end
    
    alias term-obs="i3-msg -q exec 'kitty -c ~/.config/kitty/obs.conf'"
    
    alias clear-docker="docker ps -a -q | xargs docker stop && docker ps -a -q | xargs docker rm"
    alias chrome="chromium"
    alias push-notes="git add -A && git cim 'notes' && git push"
    alias rg="rg --hidden"
    
    ### Aliases/Functions End #########################
    
    export PYTHONBREAKPOINT=pdb.set_trace
    
    # PATH setup
    fish_add_path ~/.local/bin
    fish_add_path ~/.local/bin/dynamic
    fish_add_path ~/.local/bin/common
    fish_add_path ~/.cargo/bin
    fish_add_path /opt/resolve/bin
    fish_add_path ~/.rye/shims
    fish_add_path /opt/google-cloud-cli/bin
    fish_add_path /home/matt/.pulumi/bin
    fish_add_path /var/lib/flatpak/exports/bin
   

    if type -q direnv
      set -l direnv_hook (direnv hook fish)
      eval $direnv_hook
    end
    
    # For clipmenu
    export CM_LAUNCHER=rofi
 
    # Tell node version manager to use the most local .nvmrc configuration
    if type -q nvm
        nvm use > /dev/null
    end

    # vscode
    if type -q code
      string match -q "$TERM_PROGRAM" "vscode" and . (code --locate-shell-integration-path fish)
    end

    [ -n "$DESK_ENV" ] && source "$DESK_ENV" || true
end

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH

# pnpm
set -gx PNPM_HOME "/home/mattwhite/.local/share/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end
