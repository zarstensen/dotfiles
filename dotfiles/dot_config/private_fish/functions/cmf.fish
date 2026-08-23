function cmf --wraps='chezmoi forget --prune' --description 'alias cmf=chezmoi forget --prune'
    chezmoi forget --prune $argv
end
