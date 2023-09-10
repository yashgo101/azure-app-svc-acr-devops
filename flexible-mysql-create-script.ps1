$invoc = az account show -o table;
$invoc;

Write-Host "`n ------------------------------------- `n"

$loc = "eastus";
$rgp_name = "Resgrp3";
$srv_name = "yashserver2";
$db_name = "node_js_crud";
$admin_user = "host";
$admin_passwd = "player";
$srv_sku = "Standard_B1ms";


if ($(az group exists -n $rgp_name) -eq $false) {
    $rgp_create = az group create --location $loc --name $rgp_name;
    $rgp_create;
}

else {
    Write-Host "Resource group exists!!";
    $ans = Read-Host -Prompt "Do you want to create a new resource group? (Yes/No)";
    if ($ans -eq "Yes"){
        Write-Host "";
        $rgp_name = Read-Host -Prompt "Enter the name of the new resource group";
        $loc = Read-Host -Prompt "Enter the name of the location";
        
        $rgp_create = az group create --location $loc --name $rgp_name;
        $rgp_create;
    }
    elseif ($ans -eq "No") {
        Write-Host "The MySQL Server will be created in the existing '$rgp_name' Resource Group";
    }
}

Write-Host "`n ------------------------------------- `n"

az mysql flexible-server create --resource-group $rgp_name --name $srv_name --location $loc --admin-user $admin_user --admin-password $admin_passwd --sku-name $srv_sku --public-access All;
Write-Host "`n ------------------------------------- `n"

az mysql flexible-server db create --resource-group $rgp_name --server-name $srv_name --database-name $db_name;
Write-Host "`n ------------------------------------- `n"

az mysql flexible-server show --resource-group $rgp_name --name $srv_name;
Write-Host "`n ------------------------------------- `n"

az mysql flexible-server execute -n $srv_name -u $admin_user -p $admin_passwd -d $db_name --file-path "C:\Users\vm1\Downloads\users.sql"