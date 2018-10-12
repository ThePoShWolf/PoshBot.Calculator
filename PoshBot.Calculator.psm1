Function Invoke-Calculation{
    [CmdletBinding()]
    [PoshBot.BotCommand(
        CommandName = 'c'
    )]
    Param(
        [ValidatePattern('^[0-9\+\-\*\/]*$')] #string should only have numbers and the following symbols: + - * /
        [string]$ToCalc
    )
    $scriptBlock = [ScriptBlock]::Create($ToCalc)
    Write-Output (Invoke-Command $scriptBlock)
}

Export-ModuleMember -Function Invoke-Calculation