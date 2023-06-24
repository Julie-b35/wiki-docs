
Import-Module ActiveDirectory

# Message de lancement
Write-Host `
" _____________________________________
|                                     |
| Script Supression d'utilisateur AD  |
|      depuis un fichier .csv         |
|                                     |
 �������������������������������������" `
-ForegroundColor Yellow
#
#
# Avertissements
Write-Host "Assurez-vous de bien lancer le script depuis votre contr�leur de domaine.
Attention, le fichier .csv doit �tre au m�me emplacement que votre script. " -ForegroundColor Red
#
#
# Variables

Write-Host `
" _____________________________________
|                                     |
|             Suppression             |
|       des Unit� d'organisation      |
|                                     |
 �������������������������������������" `
-ForegroundColor Green

$LignesCsv = @()

import-csv  -Delimiter ";" -Path .\ou.csv | ForEach-Object {
    $LignesCsv+=@{
        'Name' = $_.Name
        'Path' =  'OU={0},{1}' -f $_.Name, $_.Path
    }
}

[array]::Reverse($LignesCsv)

foreach ($Ligne in $LignesCsv) {
    
    $cmd = Get-ADOrganizationalUnit -Identity $Ligne.Path
    Write-Host $Ligne.Name $Ligne.Path   $cmd
    <#$
    if ( $cmd ) {
        try {
            #New-ADOrganizationalUnit -Name $Name -Path $_.Path
            Get-ADOrganizationalUnit -Identity $_.Path | Set-ADObject -ProtectedFromAccidentalDeletion:$false -PassThru | Remove-ADOrganizationalUnit -Confirm:$false
            $noErreur = 1
        }
        catch {
            Write-Host "La commande New-ADOrganizationalUnit c'est mal d�roul�."
            $noErreur = 0
            $_
        }
        if ($noErreur) {
            Write-Host "La commande New-ADOrganizationalUnit -Name ""$($_.Name)"" -Path ""$($_.Path)"" � �t� faite"
        }
    } else {
        Write-Host "La commande New-ADOrganizationalUnit -Name ""$($_.Name)"" -Path ""$($_.Path)"" � d�j� �t� faite"
    }
    #>
}
