Function Invoke-Calculation{
    [CmdletBinding()]
    [PoshBot.BotCommand(
        CommandName = 'c'
    )]
    <#Param(
        [ValidatePattern('^[0-9\+\-\*\/\(\)\.]*$')] #string should only have numbers and the following symbols: + - * / ( ) .
        [string]$ToCalc
    )#>
    # If I do it this way with the $args variable, then I can accept () in the equation.
    # Otherwise it separates everything to different parameters, which breaks the function.
    $ToCalc = $args -join ''
    $regex = '[0-9\+\-\*\/\(\)\.]'
    $oppositeRegex = '[^0-9\+\-\*\/\(\)\.]'
    If($ToCalc -match "^$regex*$"){
        $scriptBlock = [ScriptBlock]::Create($ToCalc)
        Write-Output (Invoke-Command $scriptBlock)
    }Else{
        $illegalCharacters = $ToCalc -replace $regex, ''
        Write-Output "Illegal characters: '$illegalCharacters' were removed."
        $scriptBlock = [ScriptBlock]::Create(($ToCalc -replace $oppositeRegex, ''))
        Write-Output (Invoke-Command $scriptBlock)
    }
}

Export-ModuleMember -Function Invoke-Calculation