function IsEmacsOpen() {
    emacsclient -n -a false -e 't' 2> $null
}

$IsOpen = IsEmacsOpen
if (!($LASTEXITCODE -eq 0) -or !($IsOpen -eq 't')) {
    echo 'Starting Emacs Daemon...'
    Start-Process -NoNewWindow -RedirectStandardOutput "C:\NUL" -RedirectStandardError ".\NUL" emacs -ArgumentList --daemon
    sleep 3
}

bg -RedirectStandardOutput ".\NUL" -RedirectStandardError "C:\NUL" emacsclient.exe @args
