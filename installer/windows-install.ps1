# Install Scoop if not already installed
if (!(Get-Command scoop -ErrorAction SilentlyContinue)) {
    Write-Host "Scoop not found. Installing Scoop..."
    Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
    iwr -useb get.scoop.sh | iex
} else {
    Write-Host "Scoop is already installed."
}

# Check if Git is installed
if (!(Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "Git not found. Installing Git via Scoop..."
    scoop install git
} else {
    Write-Host "Git is already installed."
}

# Check if Python is installed
if (!(Get-Command python -ErrorAction SilentlyContinue)) {
    Write-Host "Python not found. Installing Python via Scoop..."
    scoop install python
} else {
    Write-Host "Python is already installed."

    # Get Python version
    $pythonVersionString = (python --version 2>&1)
    $versionMatch = [regex]::Match($pythonVersionString, '\d+\.\d+\.\d+')
    $pythonVersionNumber = $versionMatch.Value

    # Split version number into major, minor, and patch
    $versionParts = $pythonVersionNumber.Split('.')
    $major = [int]$versionParts[0]
    $minor = [int]$versionParts[1]
    $patch = [int]$versionParts[2]

    # Check if version meets the requirements (>=3.10 and <4.0)
    if ($major -eq 3) {
        if ($minor -ge 10) {
            Write-Host "Python version $pythonVersionNumber meets the requirements."
        } else {
            Write-Error "Python version $pythonVersionNumber is less than 3.10. Please upgrade Python to meet the version requirements (>=3.10 and <4.0)."
            exit 1
        }
    } elseif ($major -ge 4) {
        Write-Error "Python version $pythonVersionNumber is greater than or equal to 4.0. Please downgrade Python to meet the version requirements (>=3.10 and <4.0)."
        exit 1
    } else {
        Write-Error "Python version $pythonVersionNumber is less than 3.10. Please upgrade Python to meet the version requirements (>=3.10 and <4.0)."
        exit 1
    }
}

# Check if Poetry is installed
if (!(Get-Command poetry -ErrorAction SilentlyContinue)) {
    Write-Host "Poetry not found. Installing Poetry via Scoop..."
    scoop install poetry
} else {
    Write-Host "Poetry is already installed."
}

# Check if pipx is installed
if (!(Get-Command pipx -ErrorAction SilentlyContinue)) {
    Write-Host "pipx not found. Installing pipx via Scoop..."
    scoop install pipx
} else {
    Write-Host "pipx is already installed."
}

