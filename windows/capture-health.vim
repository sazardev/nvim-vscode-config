" Capture health check output
set verbosefile=health-verbose.txt
set verbose=15
redir! > health-output.txt
silent! checkhealth
redir END
wqall
