
# Install Pester (Run Once)
# Install-Module Pester -Scope CurrentUser -Force

Describe "Get-Example" {

    It "Returns greeting with provided name" {
        $result = Get-Example -Name "John"
        $result | Should Be "Hello John"
    }

    It "Does not return empty string" {
        $result = Get-Example -Name "Test"
        $result | Should Not -BeNullOrEmpty
    }
}

# Run tests
# Invoke-Pester