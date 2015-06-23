:: Call default cmder init.bat
@call %ConEmuDir%\..\init.bat

:: Move prompt to the bottom
@prompt $E[9999E$E[1;32;40m$P$S{git}{hg}$S$_$E[1;30;40m{lamb}$S$E[1;37;40m
