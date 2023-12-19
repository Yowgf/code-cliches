function Get-PS($psargs) {
    if (! [string]::IsNullOrEmpty($psargs)) {
        ps $psargs | sort -des cpu | select -f 15 | ft -a
    } else {
        ps | sort -des cpu | select -f 15 | ft -a
    }
}

While(1) {
    $top = Get-PS($args)
    cls
    echo $top
    sleep 1
}
