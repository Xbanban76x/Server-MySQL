ESX = nil
TriggerEvent(Config.Shop.ESX..'esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent('buy:food')
AddEventHandler('buy:food', function(label, name, category, price)
    local _src = source
    local xPlayer = ESX.GetPlayerFromId(_src)
    
    MySQL.Async.execute("INSERT INTO shop (label, name, category, price) VALUES (@label, @name, @category, @price)",
    {
        ['@label'] = label,
        ['@name'] = name,
        ['@category'] = category,
        ['@price'] = price
    }, function(rowsChanged)
        
    end)
end)

RegisterNetEvent('buy:drink')
AddEventHandler('buy:drink', function(label, name, category, price)
    local _src = source
    local xPlayer = ESX.GetPlayerFromId(_src)
    
    MySQL.Async.execute("INSERT INTO shop (label, name, category, price) VALUES (@label, @name, @category, @price)",
    {
        ['@label'] = label,
        ['@name'] = name,
        ['@category'] = category,
        ['@price'] = price
    }, function(rowsChanged)
        
    end)
end)

RegisterServerEvent('getAllItems')
AddEventHandler('getAllItems', function()
    local _src = source
    local xPlayer = ESX.GetPlayerFromId(_src)
    local allItem = {}

    MySQL.Async.fetchAll("SELECT * FROM shop", {}, function(result)
        for _,v in pairs(result) do
            table.insert(allItem, {id = v.id, label = v.label, name = v.name, category = v.category, price = v.price})
        end
        TriggerClientEvent('getAllItems', _src, allItem)
    end)
end)

RegisterServerEvent('getAllFood')
AddEventHandler('getAllFood', function()
    local _src = source
    local xPlayer = ESX.GetPlayerFromId(_src)
    local allFood = {}

    MySQL.Async.fetchAll("SELECT * FROM shop WHERE category = 'food'", {}, function(result)
        for _,v in pairs(result) do
            table.insert(allFood, {id = v.id, label = v.label, name = v.name, category = v.category, price = v.price})
        end
        TriggerClientEvent('getAllFood', _src, allFood)
    end)
end)

RegisterServerEvent('getAllDrink')
AddEventHandler('getAllDrink', function()
    local _src = source
    local xPlayer = ESX.GetPlayerFromId(_src)
    local allDrink = {}

    MySQL.Async.fetchAll("SELECT * FROM shop WHERE category = 'drink'", {}, function(result)
        for _,v in pairs(result) do
            table.insert(allDrink, {id = v.id, label = v.label, name = v.name, category = v.category, price = v.price})
        end
        TriggerClientEvent('getAllDrink', _src, allDrink)
    end)
end)

RegisterServerEvent('buy:item')
AddEventHandler('buy:item', function(id, category, label, name, price)
    local _src = source
    local xPlayer = ESX.GetPlayerFromId(_src)
    -- local money = xPlayer.getMoney() Pour base normale
    local money = xPlayer.getAccount('cash').money
    local price = tonumber(price)
    if money >= price then
        xPlayer.removeAccountMoney('cash', price)
        xPlayer.addInventoryItem(name, 1)
        TriggerClientEvent(Config.Shop.ESX..'esx:showNotification', _src, "Vous avez acheté ~g~"..label.."~w~ pour ~g~$"..price.."~w~.")
    else
        TriggerClientEvent(Config.Shop.ESX..'esx:showNotification', _src, 'Vous n\'avez pas assez d\'argent, il vous manque ~r~$'..price-money..'~w~.')
    end
    MySQL.Async.execute("DELETE FROM shop WHERE id = @id",
    {
        ['@id'] = id
    }, function(rowsChanged)
        
    end)
end)