ESX = nil
TriggerEvent(Config.Shop.ESX..'esx:getSharedObject', function(obj) ESX = obj end)

Citizen.CreateThread(function()
    while true do
        local interval = 1000
        for k, v in pairs(Config.Shop.Position) do
            local playerPos = GetEntityCoords(PlayerPedId())
            local distance = #(playerPos - v)
            if distance <= 9 then
                interval = 0
                DrawMarker(22, v.x, v.y, v.z + 0.98, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.45, 0.45, 0.45, 255, 0, 0, 150, 55555, false, true, 2, false, false, false, false)
                if distance <= 1.5 then
                    RageUI.Text({ message = "Appuyez sur ~b~[E]~s~ pour accéder au magasin", time_display = 1 })
                    if IsControlJustPressed(0, 51) then
                        OpenMenuShop()
                    end
                end
            end
        end
        Wait(interval)
    end
end)

Citizen.CreateThread(function()
    for k, v in pairs(Config.Shop.Position) do
        local blip = AddBlipForCoord(v)
        SetBlipSprite(blip, 52)
        SetBlipScale (blip, 0.65)
        SetBlipColour(blip, 18)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentSubstringPlayerName('Supérette')
        EndTextCommandSetBlipName(blip)
    end
end)

AllItem = {}
RegisterNetEvent('getAllItems')
AddEventHandler('getAllItems', function(allItem)
    AllItem = allItem
end)

AllFood = {}
RegisterNetEvent('getAllFood')
AddEventHandler('getAllFood', function(allFood)
    AllFood = allFood
end)

AllDrink = {}
RegisterNetEvent('getAllDrink')
AddEventHandler('getAllDrink', function(allDrink)
    AllDrink = allDrink
end)

function OpenMenuShop()
    local main = RageUI.CreateMenu(Config.Shop.Title, Config.Shop.SubTitle)
    local submenu = RageUI.CreateSubMenu(main, Config.Shop.Title, Config.Shop.SubTitle)
    local submenu_food = RageUI.CreateSubMenu(main, Config.Shop.Title, Config.Shop.SubTitle)
    local submenu_drink = RageUI.CreateSubMenu(main, Config.Shop.Title, Config.Shop.SubTitle)

        RageUI.Visible(main, not RageUI.Visible(main))
            while main do

            Wait(0)
            RageUI.IsVisible(main, true, false, true, function()

                RageUI.Separator("~b~Produits")

                for k, v in pairs(Config.Shop.Food) do

                RageUI.ButtonWithStyle("Acheter un(e) "..v.label, nil, {RightBadge = RageUI.BadgeStyle.Star}, true, function(Hovered, Active, Selected)
                    if (Selected) then
                        TriggerServerEvent('buy:food', v.label, v.name, v.category, v.price)
                    end
                end)
            end
            RageUI.Separator("~b~Boissons")

            for k, v in pairs(Config.Shop.Drink) do
                    
                RageUI.ButtonWithStyle("Acheter un(e) "..v.label, nil, {RightBadge = RageUI.BadgeStyle.Star}, true, function(Hovered, Active, Selected)
                    if (Selected) then
                        TriggerServerEvent('buy:drink', v.label, v.name, v.category, v.price)
                    end
                end)
            end
                
            RageUI.Separator("~b~Autres")

            RageUI.ButtonWithStyle("Accéder au magasin", nil, {}, true, function(Hovered, Active, Selected)
                if Selected then
                    TriggerServerEvent('getAllItems')
                end
            end, submenu)

            RageUI.Separator("Liste de nourriture")
            
            RageUI.ButtonWithStyle("Nourriture en stock", nil, {}, true, function(Hovered, Active, Selected)
                if Selected then
                    TriggerServerEvent('getAllFood')
                end
            end, submenu_food)

            RageUI.Separator("Liste des boissons")

            RageUI.ButtonWithStyle("Boissons en stock", nil, {}, true, function(Hovered, Active, Selected)
                if Selected then
                    TriggerServerEvent('getAllDrink')
                end
            end, submenu_drink)
            
            end, function()
            end)

            RageUI.IsVisible(submenu, true, false, true, function()

                RageUI.Separator("~o~Nombre de produit dispo "..#AllItem.." :")
                for k, v in pairs(AllItem) do
                    RageUI.ButtonWithStyle(v.label, v.name, {RightLabel = v.price}, true, function(Hovered, Active, Selected)
                        if Selected then
                            TriggerServerEvent('buy:item', v.id, v.category, v.label, v.name, v.price)
                            RageUI.GoBack()
                        end
                    end)
                end

            end, function()
            end)

            RageUI.IsVisible(submenu_food, true, false, true, function()

                RageUI.Separator("~o~Nombre d'aliments dispo "..#AllFood.." :")
                for k, v in pairs(AllFood) do
                    RageUI.ButtonWithStyle(v.label, v.name, {RightLabel = v.price}, true, function(Hovered, Active, Selected)
                        if Selected then
                            print(v.category)
                        end
                    end)
                end

            end, function()
            end)

            RageUI.IsVisible(submenu_drink, true, false, true, function()

                RageUI.Separator("~o~Nombre de produit dispo "..#AllDrink.." :")
                for k, v in pairs(AllDrink) do
                    RageUI.ButtonWithStyle(v.label, v.name, {RightLabel = v.price}, true, function(Hovered, Active, Selected)
                        if Selected then
                            print(v.category)
                        end
                    end)
                end

            end, function()
            end)

        if not RageUI.Visible(main) and not RageUI.Visible(submenu) and not RageUI.Visible(submenu_drink) and not RageUI.Visible(submenu_food) then
            main = RMenu:DeleteType("main", true)
            FreezeEntityPosition((PlayerPedId()), false)
        end
    end
end

