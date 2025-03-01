ESX = exports["es_extended"]:getSharedObject()

local ox_inventory = exports.ox_inventory

local pma = exports["pma-voice"]
local currentChannel = 0
local optionmenuradio = {}

local radioON = false
local radioBruitage = false


RegisterNetEvent('kotonier:radio:toggleStatus', function()
    radioON = not radioON
    if radioON == true then 
        pma:setVoiceProperty("radioEnabled", true)
        ESX.ShowNotification("Radio Allumé !")
    else
        pma:setRadioChannel(0)
        pma:setVoiceProperty("radioEnabled", false)
        ESX.ShowNotification("Radio Eteinte !")
    end
    OpenMenuRadio()
end)

RegisterNetEvent('kotonier:radio:toggleBruitage', function()
    radioBruitage = not radioBruitage
    if radioBruitage == true then 
        ESX.ShowNotification("Bruitages radio activés")
        pma:setVoiceProperty("micClicks", true)
    else
        pma:setVoiceProperty("micClicks", false)
        ESX.ShowNotification("Bruitages radio désactivés")
    end
    OpenMenuRadio()
end)


RegisterNetEvent('kotonier:radio:disconnectfromchannel', function()
    currentChannel = tostring(0)
    pma:setRadioChannel(0)
    ESX.ShowNotification("Vous vous êtes déconnecté de la fréquence")
    OpenMenuRadio()
end)

RegisterNetEvent('kotonier:radio:reopenmenu', function()
    OpenMenuRadio()
end)

local keybind = lib.addKeybind({
    name = 'radiomenu',
    description = 'Ouvrir le menu radio',
    defaultKey = 'F11',
    onPressed = function(self)
        local radiocount = ox_inventory:GetItemCount("radio")
        if radiocount > 0 then 
            OpenMenuRadio()
        end
    end,
})



RegisterNetEvent('kotonier:radio:SelectChannel', function()
    local input = lib.inputDialog('Radio', {
        {type = 'slider', label = 'Fréquence',  required = true, default = 1, min = 1, max = 999, step = 1},
    })
    if not input then return end
    currentChannel = tonumber(input[1])
    pma:setRadioChannel(tonumber(input[1]))
    OpenMenuRadio()
end)

RegisterNetEvent('kotonier:radio:SetVolume', function()
    local input = lib.inputDialog('Radio', {
        {type = 'slider', label = 'Volume',  required = true, default = 1, min = 1, max = 100, step = 1},
    })
    if not input then return end
    pma:setRadioVolume(tonumber(input[1]))
    OpenMenuRadio()
end)



function OpenMenuRadio()
    if lib.getOpenContextMenu() ~= nil then 
        lib.hideContext(true)
        Wait(10)
    end
    optionmenuradio = {}
    optionmenuradio[#optionmenuradio+1] = {
        title = radioON and 'Eteindre la radio' or 'Allumée la radio',
        icon = radioON and "fa-solid fa-power-off" or "fa-solid fa-power-off",
        iconColor = radioON and 'red' or 'green',
        event = 'kotonier:radio:toggleStatus',

    }
    if radioON == true then
        optionmenuradio[#optionmenuradio+1] = {
            title = radioBruitage and 'Désactiver les bruitages' or 'Activer les bruitages',
            icon = radioBruitage and 'fa-solid fa-toggle-off' or 'fa-solid fa-toggle-on',
            iconColor = radioBruitage and 'red' or 'green',
            event = 'kotonier:radio:toggleBruitage',   
        }

        optionmenuradio[#optionmenuradio+1] = {
            title = "Se connecter à une fréquence",
            icon = "fa-solid fa-tower-broadcast",
            iconColor = "#40e0d0",
            event = "kotonier:radio:SelectChannel",
        }
        optionmenuradio[#optionmenuradio+1] = {
            title = "Volume de la Radio",
            icon = "fa-solid fa-volume-low",
            iconColor = "yellow",
            event = "kotonier:radio:SetVolume",
        }

        if tonumber(currentChannel) ~= 0 then
            optionmenuradio[#optionmenuradio+1] = {
                title = "Se déconnecter de la Radio",
                icon = "fa-solid fa-volume-xmark",
                iconColor = "orange",
                event = "kotonier:radio:disconnectfromchannel"
            }
        end
    end

    lib.registerContext({
        id = 'kotonier:radio:menu1',
        title = 'Radio',
        options = optionmenuradio,
    })
    lib.showContext('kotonier:radio:menu1')
end



CreateThread(function()
    while true do 
        if radioON == true then 
            if currentChannel ~= nil and tonumber(currentChannel) ~= 0 then
                if ox_inventory:GetItemCount("radio") < 1 then
                    radioON = false
                    pma:setRadioChannel(0)
                    pma:setVoiceProperty("radioEnabled", false)
                    currentChannel = 0
                end
            end
        end
        Wait(5000)
    end
end)
