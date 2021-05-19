$code = @()
$hash = @{}
Function Random-Start
{
    $a = Get-Random -min 0 -max 9
    $b, $c, $d = $a, $a, $a
    While ($b -eq $a)
    {
        $b = Get-Random -min 0 -max 9
    }
    While ($c -eq $a -or $c -eq $b)
    {
        $c = Get-Random -min 0 -max 9
    
    }
    While ($d -eq $c -or $d -eq $b -or $d -eq $a)
    {
        $d = Get-Random -min 0 -max 9
    }

    $code = ($a, $b, $c, $d)
    return $code
}
Function Check-Guess ($userguess, $code)
{
    #"This is the guess"
    #$userguess
    $temphash = @{cheese = 0; mac = 0}
    For ($j = 0; $j -lt 4; $j++)
    {
      For ($i = 0; $i -lt 4; $i++)
      {
        IF ($userguess[$i] -eq $code[$j])
        {
            # Found a number in the code!

            IF ($i -eq $j)
            {
                # Found a number in the correct spot
                $temphash['cheese']++
            }
            ELSE
            {
                $temphash['mac']++
            }
        }
      }
    } 
    return $temphash
}

Function Get-Code
{
    #get 4 int code from user and store as an array
    Write-Host "Enter four digit code. Only integers 0-9"
    $guess_array = @()
    $i = 1
    While ($guess_array.length -lt 4)
    {
        switch ($i)
        {
            1{[int]$inputguess = Read-Host "Input first number"}
            2{[int]$inputguess = Read-Host "Input second number"}
            3{[int]$inputguess = Read-Host "Input third number"}
            4{[int]$inputguess = Read-Host "Input fourth number"}
        }

        # Input validation
        If (($inputguess.length -eq 1) -and ($inputguess -ge 0) -and ($inputguess -le 9) -and ($guess_array -notcontains $inputguess))
        {
            $guess_array += $inputguess
            $i++
        }
        ELSE
        {
            Write-Host "Please enter a unique integer 0-9"
        }
    }
    return $guess_array

}

Function Display-Game ($userguess, $mnchash)
{
    # Display game screen
    $guess0 = $userguess[0]
    $guess1 = $userguess[1]
    $guess2 = $userguess[2]
    $guess3 = $userguess[3]
    $code_table = "
            +-------+-------+-------+-------+
    Code    |   X   |   X   |   X   |   X   |
            +-------+-------+-------+-------+
    Guess   |   $guess0   |   $guess1   |   $guess2    |   $guess3  |
            +-------+-------+-------+-------+
    "
    # Display score in a table
    $mac = $mnchash.mac
    $che = $mnchash.cheese
    $user_score = "
    ┌───────┬────────┐
    │  Mac  │ Cheese │
    ├───────┼────────┤
    │   $mac   │    $che   │
    └───────┴────────┘
    "

    #Write-Host "game border"
    #$code

    #Display user's score
    $code_table
    $user_score
    "`n"
}

Function Get-Title
{
    $title_string = "
             ___ ___   ____    __      ____          __  __ __    ___    ___  _____   ___     
            |   T   T /    T  /  ]    |    \        /  ]|  T  T  /  _]  /  _]/ ___/  /  _]    
            | _   _ |Y  o  | /  /     |  _  Y      /  / |  l  | /  [_  /  [_(   \_  /  [_     
            |  \_/  ||     |/  /      |  |  |     /  /  |  _  |Y    _]Y    _]\__  TY    _]    
            |   |   ||  _  /   \_     |  |  |    /   \_ |  |  ||   [_ |   [_ /  \ ||   [_     
            |   |   ||  |  \     |    |  |  |    \     ||  |  ||     T|     T\    ||     T    
            l___j___jl__j__j\____j    l__j__j     \____jl__j__jl_____jl_____j \___jl_____j    
    "
    $welcome_string = "
                                    Discover the hidden code!
                 Enter a 4 digit code.  Digits must be 0-9 and not repeated.
                                Mac = correct code, wrong position
                                Cheese = correct code, correct position"
    # Print out strings
    $title_string
    $welcome_string
    "`n"
}

# Global variables
$mnchash = @{"mac" = 0; "cheese" = 0}
$code = Random-Start
$attempts_array = @()

# Clear screen
cls

# Title screen
Get-Title

# Main event loop
Do 
{
    # Show previous guesses
    #Foreach ($a in $attempts_array)
    #{
    #    Write-Host $a
    #}

    $userguess = Get-Code
    $attempts_array += $userguess
    $mnchash = Check-Guess $userguess $code
    Display-Game $userguess $mnchash

}
While ($mnchash.cheese -lt 4)  # Game ends at 4 cheeses
Write-Host "`n
 __ __   ___   __ __      __    __  ____  ____  
|  T  T /   \ |  T  T    |  T__T  Tl    j|    \ 
|  |  |Y     Y|  |  |    |  |  |  | |  T |  _  Y
|  ~  ||  O  ||  |  |    |  |  |  | |  | |  |  |
l___, ||     ||  :  |    l  `  '  ! |  | |  |  |
|     !l     !l     |     \      /  j  l |  |  |
l____/  \___/  \__,_j      \_/\_/  |____jl__j__j
                                               `n"
