local convar_third_person = CreateClientConVar('third_person', 0, true, false)
CreateClientConVar('third_person_ud', 0, true, false, '', -15, 15)
CreateClientConVar('third_person_rl', 0, true, false, '', -20, 20)
CreateClientConVar('third_person_fb', -60, true, false, '', -120, 30)
CreateClientConVar('third_person_ang', 0, true, false, '', -45, 45)

hook.Add('ShouldDrawLocalPlayer', 'DarkFated.ThirdPerson', function()
    if GetConVar('third_person'):GetBool() then
        return !LocalPlayer():InVehicle()
    end
end)

hook.Add('CalcView', 'DarkFated.ThirdPerson', function(pl, origin, ang, fov)
    if GetConVar('third_person'):GetBool() and !pl:InVehicle() then
        return {
            origin = util.TraceLine({
                start = origin,
                endpos = origin + (ang:Up() * GetConVar('third_person_ud'):GetInt()) + (ang:Right() * GetConVar('third_person_rl'):GetInt()) + (ang:Forward() * GetConVar('third_person_fb'):GetInt()),
                filter = pl
            }).HitPos + (ang:Forward() * 16),
            angles = Vector(ang.x, ang.y, ang.z + GetConVar('third_person_ang'):GetInt()),
            fov = fov
        }
    end
end)

concommand.Add('third_person_toggle', function()
    RunConsoleCommand('third_person', convar_third_person:GetBool() and 0 or 1)
end)

local color_header = Color(61, 61, 61)
local color_background = Color(44, 44, 44)
local color_close = Color(253, 116, 92)

concommand.Add('third_person_menu', function()
    local menuThirdperson = vgui.Create(Mantle and 'MantleFrame' or 'DFrame')
    menuThirdperson:SetSize(300, Mantle and 224 or 175)
    menuThirdperson:Center()
    menuThirdperson:MakePopup()
    menuThirdperson:SetTitle('Third Person Settings')
    menuThirdperson:SetKeyBoardInputEnabled(false)

    local checkbox = vgui.Create(Mantle and 'MantleCheckBox' or 'DCheckBoxLabel', menuThirdperson)
    checkbox:Dock(TOP)
    checkbox:DockMargin(0, 2, 0, 2)

    local slider_ud = vgui.Create(Mantle and 'MantleSlideBox' or 'DNumSlider', menuThirdperson)
    slider_ud:Dock(TOP)
    slider_ud:DockMargin(2, 0, 0, 0)
    slider_ud:SetText('Up/down position')

    local slider_rl = vgui.Create(Mantle and 'MantleSlideBox' or 'DNumSlider', menuThirdperson)
    slider_rl:Dock(TOP)
    slider_rl:DockMargin(2, 0, 0, 0)
    slider_rl:SetText('Right/left position')

    local slider_fb = vgui.Create(Mantle and 'MantleSlideBox' or 'DNumSlider', menuThirdperson)
    slider_fb:Dock(TOP)
    slider_fb:DockMargin(2, 0, 0, 0)
    slider_fb:SetText('Forward/back position')

    local slider_ang = vgui.Create(Mantle and 'MantleSlideBox' or 'DNumSlider', menuThirdperson)
    slider_ang:Dock(TOP)
    slider_ang:DockMargin(2, 0, 0, 0)
    slider_ang:SetText('Camera rotation')

    if Mantle then
        checkbox:SetTxt('Enable the third person')
        checkbox:SetConvar('third_person')

        slider_ud:SetRange(-15, 15, 0)
        slider_ud:SetConvar('third_person_ud')

        slider_rl:SetRange(-20, 20, 0)
        slider_rl:SetConvar('third_person_rl')

        slider_fb:SetRange(-120, -30, 0)
        slider_fb:SetConvar('third_person_fb')

        slider_ang:SetRange(-45, 45, 0)
        slider_ang:SetConvar('third_person_ang')
    else
        menuThirdperson:ShowCloseButton(false)
        menuThirdperson.Paint = function(_, w, h)
            draw.RoundedBox(8, 0, 0, w, h, color_background)
            draw.RoundedBoxEx(8, 0, 0, w, 24, color_header, true, true, false, false)
        end
        
        local cls = vgui.Create('DButton', menuThirdperson)
        cls:SetSize(16, 16)
        cls:SetPos(menuThirdperson:GetWide() - cls:GetWide() - 4, 4)
        cls:SetText('')
        cls.DoClick = function()
            menuThirdperson:Close()
        end
        cls.Paint = function(_, w, h)
            draw.RoundedBox(6, 0, 0, w, h, color_close)
        end

        checkbox:SetText('Enable the third person')
        checkbox:SetConVar('third_person')

        slider_ud:SetMin(-15)
        slider_ud:SetMax(15)
        slider_ud:SetDecimals(0)
        slider_ud:SetConVar('third_person_ud')

        slider_rl:SetMin(-20)
        slider_rl:SetMax(20)
        slider_rl:SetDecimals(0)
        slider_rl:SetConVar('third_person_rl')

        slider_fb:SetMin(-120)
        slider_fb:SetMax(-30)
        slider_fb:SetDecimals(0)
        slider_fb:SetConVar('third_person_fb')

        slider_ang:SetMin(-45)
        slider_ang:SetMax(45)
        slider_ang:SetDecimals(0)
        slider_ang:SetConVar('third_person_ang')
    end
end)

// For Sandbox
list.Set('DesktopWindows', 'ThirdPersonMenu', {
    title = 'Third Person',
    icon = 'icon16/cake.png',
    onewindow = false,
    init = function()
        RunConsoleCommand('third_person_menu')
    end,
})
