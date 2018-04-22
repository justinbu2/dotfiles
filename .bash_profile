# ----------------------------------------------------
# BASH Configuration File
# ----------------------------------------------------

# Load the shell dotfiles
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit.
for file in ~/.{aliases,bash_prompt,exports,functions,path,extra}; do
    [ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

# Ruby stuff
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

# Misc
shopt -s cdspell                # Ignore minor spelling mistakes when using 'cd'
export HISTCONTROL=ignoredups   # Remove duplicate history commands in terminal

. /usr/local/etc/profile.d/z.sh # Configure z

