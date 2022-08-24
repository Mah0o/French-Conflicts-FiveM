-- SUGGESTION COMMANDE --
TriggerEvent("chat:addSuggestion", "/sk_kick", "Kick un joueur",{
    {name = "PlayerId", help = "ID Joueur"}
})
TriggerEvent("chat:addSuggestion", "/sk_private", "Envoyer un message a un joueur",{
    {name = "PlayerId", help = "ID Joueur"},
    {name = "Message", help = "Contenu du message"}
})
TriggerEvent("chat:addSuggestion", "/sk_revive", "Revive un joueur",{
    {name = "PlayerId", help = "ID Joueur"}
})
TriggerEvent("chat:addSuggestion", "/sk_heal", "Heal un joueur",{
    {name = "PlayerId", help = "ID Joueur"}
})
TriggerEvent("chat:addSuggestion", "/sk_setfaction", "Modifier la faction d'un joueur",{
    {name = "PlayerId", help = "ID Joueur"},
    {name = "Faction", help = "Nom de la faction"},
    {name = "Grade", help = "Grade de la faction"}
})
TriggerEvent("chat:addSuggestion", "/sk_setmoney", "Définir la somme d'argent d'un joueur",{
    {name = "PlayerId", help = "ID Joueur"},
    {name = "Type", help = "Type d'argent (money, black_money, bank)"},
    {name = "Montant", help = "Quantité d'argent à définir"}
})
TriggerEvent("chat:addSuggestion", "/sk_addmoney", "Ajouter une somme d'argent à un joueur",{
    {name = "PlayerId", help = "ID Joueur"},
    {name = "Type", help = "Type d'argent (money, black_money, bank)"},
    {name = "Montant", help = "Quantité d'argent à ajouter"}
})
TriggerEvent("chat:addSuggestion", "/sk_giveitem", "Donenr un item à un joueur",{
    {name = "PlayerId", help = "ID Joueur"},
    {name = "Item", help = "Nom de l'item"},
    {name = "Nombre", help = "Quantité de l'item"}
})
TriggerEvent("chat:addSuggestion", "/sk_giveweapon", "Donner une arme à un joueur",{
    {name = "PlayerId", help = "ID Joueur"},
    {name = "Arme", help = "Nom de l'arme"},
    {name = "Munitions", help = "Quantité de munitions"}
})
TriggerEvent("chat:addSuggestion", "/sk_slay", "Tuer un joueur",{
    {name = "PlayerId", help = "ID Joueur"}
})
TriggerEvent("chat:addSuggestion", "/sk_setgroup", "Définir le group d'un joueur", {
    {name = "PlayerId", help = "ID Joueur"},
    {name = "Group", help = "Le group à définir"}
})
TriggerEvent("chat:addSuggestion", "/sk_bring", "Téléporter un joueur sur soit",{
    {name = "PlayerId", help = "ID Joueur"}
})
TriggerEvent("chat:addSuggestion", "/sk_goto", "Se téléporter sur un joueur", {
    {name = "PlayerId", help = "ID Joueur"}
})
TriggerEvent("chat:addSuggestion", "/sk_freeze", "Freeze un joueur",{
    {name = "PlayerId", help = "ID Joueur"}
})
TriggerEvent("chat:addSuggestion", "/sk_car", "Spawn un véhicule",{
    {name = "Car", help = "Nom du véhicule"}
})
TriggerEvent("chat:addSuggestion", "/sk_spec", "Regarder un joueur",{
    {name = "PlayerId", help = "ID Joueur"}
})
TriggerEvent("chat:addSuggestion", "/sk_report", "Envoyer un report au staff",{
    {name = "Message", help = "La raison de votre report"}
})
TriggerEvent("chat:addSuggestion", "/me", "Affiche une action au dessus de votre tête",{
    {name = "Action", help = "L'action que vous souhaitez afficher"}
})
TriggerEvent("chat:addSuggestion", "/givecar", "Give un véhicule",{
    {name = "PlayerId", help = "ID Joueur"},
    {name = "Car", help = "Nom du véhicule"}
})
TriggerEvent("chat:addSuggestion", "/sk_dv", "Supprimer un véhicule",{})
TriggerEvent("chat:addSuggestion", "/sk_delgun", "Activer/Désactiver le delgun",{})
TriggerEvent("chat:addSuggestion", "/sk_rz", "Réanimer une zone",{})
TriggerEvent("chat:addSuggestion", "/doorsbuilder", "Acceder au menu Door Builder", {})
TriggerEvent("chat:addSuggestion", "/itembuilder", "Acceder au menu Item Builder",{})
-------------------------