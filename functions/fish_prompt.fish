set __fish_git_prompt_showuntrackedfiles 'yes'
set __fish_git_prompt_showdirtystate 'yes'
set __fish_git_prompt_showstashstate ''
set __fish_git_prompt_showupstream 'none'

function print_pwd
	echo -n (pwd | sed "s,$HOME,~,")
end

function fish_prompt
	set_color brblack
    print_pwd
	set_color 00ff00
	printf '%s ' (__fish_git_prompt)
	set_color ffffff
	echo -n '$ '
	set_color normal
end

