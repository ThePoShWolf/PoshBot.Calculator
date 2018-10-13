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
    $regex = '[0-9\+\-\*\/\(\)\.\^]'
    $oppositeRegex = '[^0-9\+\-\*\/\(\)\.\^]'
    If($ToCalc -match $oppositeRegex){
        $illegalCharacters = $ToCalc -replace $regex, ''
        Write-Output "Illegal characters: '$illegalCharacters' were removed."
        $ToCalc = $ToCalc -replace $oppositeRegex, ''
    }

    While($ToCalc -match '\^'){
        $mathstring = '[math]::pow('
        $x = ($ToCalc.IndexOf('^') - 1)
        $y = $x + 2 + $mathstring.Length
        While($ToCalc[$x] -match '\d' -and $x -gt -1){
            $x--
        }
        If($x -eq -1){
            $newString = $mathstring + $ToCalc.Replace('^',',')
        }Elseif(($x -gt -1) -and ($x -lt $ToCalc.length-1)){
            $newString = ($ToCalc[0..$x] -join '') + $mathstring + ($ToCalc[($x+1)..$ToCalc.length] -join '').Replace('^',',')
        }Else{ # Invalid usage of '^'

        }
        While(($newstring[$y] -match '\d') -and ($y -lt $newstring.Length-1)){
            $y++
        }
        If($y -lt $newstring.Length){
            $ToCalc = ($newString[0..$y] -join '') + ')' + ($newString[($y+1)..$newstring.length] -join '')
        }
    }
    $Scriptblock = [scriptblock]::Create($ToCalc)
    Write-Output (Invoke-Command $Scriptblock)
}

Function Get-SquareRoot{
    [CmdletBinding()]
    [PoshBot.BotCommand(
        CommandName = 'sqrt'
    )]
    Param(
        [int]$num
    )
    Write-Output ([math]::Sqrt($num))
}

Export-ModuleMember -Function Invoke-Calculation, Get-SquareRoot