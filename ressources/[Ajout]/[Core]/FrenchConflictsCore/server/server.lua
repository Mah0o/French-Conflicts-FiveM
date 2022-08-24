RegisterCommand("me", function(source,args)
    local text = "* " .."La personne ".. table.concat(args, " ") .. " *"
    TriggerClientEvent('3dme:shareDisplay', -1, text, source)
end)