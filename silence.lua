local CoreGui, TweenService, TextService, UIS, HttpService, Mouse = game:GetService("CoreGui"), game:GetService("TweenService"), game:GetService("TextService"), game:GetService("UserInputService"), game:GetService("HttpService"), game.Players.LocalPlayer:GetMouse()
local Library = {}

Library.Utils = {}
function Library.Utils:Tween(inst, info, props)
    inst = inst or nil; info = info or TweenInfo.new(1, Enum.EasingStyle.Linear); props = props or nil
    if (inst == nil or props == nil) then return warn("[silence library] - You must provide an instance or properties to tween.") end
    return TweenService:Create(inst, info, props)
end
function Library.Utils:Drag(Instance)
	local gui = Instance

	local dragging
	local dragInput
	local dragStart
	local startPos

	local function update(input)
		local delta = input.Position - dragStart
        gui:TweenPosition(UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y), 'Out', 'Linear', 0.05, true);
        --gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end

	gui.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = gui.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	gui.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)

	UIS.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			update(input)
		end
	end)
end
function Library.Utils:StringSize(string, fontSize, font)
    return TextService:GetTextSize(string, fontSize, font, Vector2.new(math.huge, math.huge))
end
function Library.Utils:ObjHasProperty(object, propertyName)
    local success, _ = pcall(function() 
        object[propertyName] = object[propertyName]
    end)
    return success
end

Library.Settings = {}
function Library.Settings:Save(settings)
    if (not syn) then return end
    if (not isfolder("silence")) then makefolder("silence") end
    if (not isfile("silence/settings_" ..tostring(game.PlaceId) .. ".syn")) then return false end
    --[[
        Basic checks because we want to make sure no fucky wukies are made UwU
    ]]

    local result = {}
    pcall(function() result = HttpService:JSONDecode(readfile("silence/settings_" ..tostring(game.PlaceId) .. ".syn")) end)
    return result
end
function Library.Settings:Load()
    if (not syn) then return end
    if (not isfolder("silence")) then makefolder("silence") end
    if (not isfile("silence/settings_" ..tostring(game.PlaceId) .. ".syn")) then return false end
    --[[
        Basic checks because we want to make sure no fucky wukies are made UwU
    ]]

    local result = {}
    pcall(function() result = HttpService:JSONDecode(readfile("silence/settings_" ..tostring(game.PlaceId) .. ".syn")) end)
    return result
end

Library.UI = {}
function Library.UI:Instance(instance, props)
    instance = instance or nil; props = props or {}
    if (instance == nil) then return warn("[silence library] - You must provide an instance type to create.") end
    local inst = Instance.new(instance)
    for i, v in pairs(props) do
        inst[i] = v
    end
    return inst
end
Library.UI.Display = Library.UI:Instance("ScreenGui", {Parent = CoreGui})
if (syn) then syn.protect_gui(Library.UI.Display) end

local tweenList = {}
function Library.UI:Toggle()
    if (self.Display.Enabled) then
        for i, v in pairs(self.Display:GetDescendants()) do
            if (Library.Utils:ObjHasProperty(v, "BackgroundTransparency")) then
                if (v.BackgroundTransparency ~= 0) then continue end
                table.insert(tweenList, {
                    Library.Utils:Tween(v, TweenInfo.new(0.25, Enum.EasingStyle.Linear), {BackgroundTransparency = 1}),
                    Library.Utils:Tween(v, TweenInfo.new(0.25, Enum.EasingStyle.Linear), {BackgroundTransparency = v.BackgroundTransparency})
                }); continue
            end
        end
        for i=1, #tweenList do
            tweenList[i][1]:Play(); continue
        end

        task.spawn(function()
            if (#tweenList == 0) then return end
            tweenList[#tweenList][1].Completed:Wait()
            self.Display.Enabled = false
        end)
    else
        for i=1, #tweenList do
            tweenList[i][2]:Play(); continue
        end

        task.spawn(function()
            if (#tweenList == 0) then return end
            self.Display.Enabled = true
            tweenList[#tweenList][2].Completed:Wait()
            table.clear(tweenList)
        end)
    end
end

function Library.UI:CreateWindow(wTitle)
    wTitle = wTitle or "SILENCE LIBRARY"
    if (CoreGui:FindFirstChild(wTitle)) then CoreGui:FindFirstChild(wTitle):Destroy() end
    Library.UI.Display.Name = wTitle

    local border = self:Instance("Frame", {
        Parent = self.Display,
        Name = "border",
        BackgroundColor3 = Color3.fromRGB(40, 40, 40),
        Position = UDim2.new(0, 125, 0, 169),
        Size = UDim2.new(0, 450, 0, 500)
    })
    local borderCorner = self:Instance("UICorner", {
        Parent = border,
        Name = "borderCorner",
        CornerRadius = UDim.new(0, 4)
    })
    Library.Utils:Drag(border)

    local main = self:Instance("Frame", {
        Parent = border,
        Name = "main",
        BackgroundColor3 = Color3.fromRGB(25, 25, 25),
        Position = UDim2.new(0, 1, 0, 1),
        Size = UDim2.new(0, 448, 0, 498)
    })
    local mainCorner = self:Instance("UICorner", {
        Parent = main,
        Name = "mainCorner",
        CornerRadius = UDim.new(0, 4)
    })

    local title = self:Instance("TextLabel", {
        Parent = main,
        Name = "title",
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 5),
        Size = UDim2.new(0, 448, 0, 25),
        Font = Enum.Font.SourceSansBold,
        Text = tostring(wTitle),
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 18,
        TextStrokeTransparency = 0
    })

    local tabs = self:Instance("Frame", {
        Parent = main,
        Name = "tabs",
        BackgroundColor3 = Color3.fromRGB(40, 40, 40),
        BorderSizePixel = 0,
        Position = UDim2.new(0, 5, 0, 68),
        Size = UDim2.new(0, 438, 0, 1)
    }) 
    local tabLayout = self:Instance("UIListLayout", {
        Parent = tabs,
        Name = "tabLayout",
        FillDirection = Enum.FillDirection.Horizontal,
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Bottom,
        Padding = UDim.new(0, 4)
    })
    local tabSpace = self:Instance("Frame", {
        Parent = tabs,
        Name = "tabSpace",
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 1, 0, 1)
    })

    local tooltip = self:Instance("Frame", {
        Parent = main,
        Name = "tooltip",
        BackgroundColor3 = Color3.fromRGB(40, 40, 40),
        BorderSizePixel = 0,
        Position = UDim2.new(0, 5, 0, 483),
        Size = UDim2.new(0, 438, 0, 1)
    })
    local tip = self:Instance("TextLabel", {
        Parent = tooltip,
        Name = "tip",
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, -13),
        Size = UDim2.new(0, 438, 0, 13),
        Font = Enum.Font.SourceSansItalic,
        Text = "inactive tooltip (hover over something :o)",
        TextColor3 = Color3.fromRGB(150, 150, 150),
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    local active = nil
    local tabList = {}
    function tabList:Tab(tTitle)
        tTitle = tTitle or "TAB"; local left = true

        local self = Library.UI -- 1. because im lazy and don't want to reference Library.UI, 2. because of localization!
        local tab = self:Instance("TextButton", {
            Parent = tabs,
            Name = "tab",
            BackgroundColor3 = Color3.fromRGB(30, 30, 30),
            BorderSizePixel = 0,
            Position = UDim2.new(0, 5, 0, -19),
            Size = UDim2.new(0, 55, 0, 20),
            AutoButtonColor = false,
            Font = Enum.Font.SourceSansBold,
            Text = tostring(tTitle),
            TextColor3 = Color3.fromRGB(150, 150, 150),
            TextSize = 14,
            TextStrokeTransparency = 0,
        })
        local tabCorner = self:Instance("UICorner", {
            Parent = tab,
            CornerRadius = UDim.new(0, 2)
        })
        local tabUnround = self:Instance("Frame", {
            Parent = tab,
            Name = "tabUnround",
            BackgroundColor3 = Color3.fromRGB(40, 40, 40),
            BorderSizePixel = 0,
            Position = UDim2.new(0, 0, 0, 19),
            Size = UDim2.new(0, 55, 0, 1)
        })
        local tabContent = self:Instance("ScrollingFrame", {
            Parent = main,
            Name = "tabContent_".. string.gsub(tTitle, "%s+", ""),
            Active = true,
            Visible = false,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 4, 0, 80),
            Size = UDim2.new(0, 440, 0, 383),
            ScrollBarThickness = 0
        })

        local contentLeft = self:Instance("Frame", {
            Parent = tabContent,
            Name = "contentLeft",
            Active = true,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Position = UDim2.new(0, 0, 0, 0),
            Size = UDim2.new(0, 217, 0, 1)
        })
        local contentLeftLayout = self:Instance("UIListLayout", {
            Parent = contentLeft,
            Name = "contentLeftLayout",
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 5)
        })

        local contentRight = self:Instance("Frame", {
            Parent = tabContent,
            Name = "contentRight",
            Active = true,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Position = UDim2.new(0, 222, 0, 0),
            Size = UDim2.new(0, 217, 0, 1)
        })
        local contentRightLayout = self:Instance("UIListLayout", {
            Parent = contentRight,
            Name = "contentRightLayout",
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 5)
        })

        local StringSize = Library.Utils:StringSize(tTitle, tab.TextSize, tab.Font)
        tab.Size = UDim2.new(0, StringSize.X + 4, 0, 20)
        tabUnround.Size = UDim2.new(0, StringSize.X + 4, 0, 1)

        if (activeTab == nil) then
            tab.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            tab.TextColor3 = Color3.fromRGB(255, 255, 255)
            tabContent.Visible = true
            activeTab = tab
        end

        tab.MouseEnter:Connect(function()
            if (activeTab == tab) then return end
            Library.Utils:Tween(tab, TweenInfo.new(0.25, Enum.EasingStyle.Linear), {
                BackgroundColor3 = Color3.fromRGB(40, 40, 40),
                TextColor3 = Color3.fromRGB(255, 255, 255)
            }):Play()
        end)
        tab.MouseLeave:Connect(function()
            if (activeTab == tab) then return end
            Library.Utils:Tween(tab, TweenInfo.new(0.25, Enum.EasingStyle.Linear), {
                BackgroundColor3 = Color3.fromRGB(30, 30, 30),
                TextColor3 = Color3.fromRGB(150, 150, 150)
            }):Play()
        end)

        tab.MouseButton1Click:Connect(function()
            if (activeTab == tab) then return end

            Library.Utils:Tween(activeTab, TweenInfo.new(0.25, Enum.EasingStyle.Linear), {
                BackgroundColor3 = Color3.fromRGB(30, 30, 30),
                TextColor3 = Color3.fromRGB(150, 150, 150)
            }):Play()
            for i, v in pairs(main:GetChildren()) do if (not string.match(v.Name, "tabContent_")) then continue end v.Visible = false end

            Library.Utils:Tween(tab, TweenInfo.new(0.25, Enum.EasingStyle.Linear), {
                BackgroundColor3 = Color3.fromRGB(40, 40, 40),
                TextColor3 = Color3.fromRGB(255, 255, 255)
            }):Play()
            tabContent.Visible = true

            activeTab = tab
        end)

        local sectionList = {}
        function sectionList:Section(sText)
            sText = sText or "Section"

            local self = Library.UI -- 1. because im lazy and don't want to reference Library.UI, 2. because of localization!
            local sectionBorder = self:Instance("Frame", {
                Parent = left and contentLeft or contentRight,
                Name = "sectionBorder",
                BackgroundColor3 = Color3.fromRGB(40, 40, 40),
                BorderSizePixel = 0,
                Size = UDim2.new(0, 217, 0, 21)
            })
            local sectionBorderCorner = self:Instance("UICorner", {
                Parent = sectionBorder,
                Name = "sectionBorderCorner",
                CornerRadius = UDim.new(0, 2)
            })
            local sectionBorderLayout = self:Instance("UIListLayout", {
                Parent = sectionBorder,
                Name = "sectionBorderLayout",
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                SortOrder = Enum.SortOrder.LayoutOrder,
            })
            local sectionBorderSpace = self:Instance("Frame", {
                Parent = sectionBorder,
                Name = "Space",
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BackgroundTransparency = 1,
                Size = UDim2.new(0, 1, 0, 1)
            }); left = not left

            local sectionTitle = self:Instance("TextLabel", {
                Parent = sectionBorder,
                Name = "sectionTitle",
                BackgroundColor3 = Color3.fromRGB(25, 25, 25),
                BorderSizePixel = 0,
                Position = UDim2.new(0, 1, 0, 1),
                Size = UDim2.new(0, 215, 0, 19),
                Font = Enum.Font.SourceSansBold,
                Text = tostring(sText),
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextSize = 14,
                TextStrokeTransparency = 0
            })
            local titleCorner = self:Instance("UICorner", {
                Parent = sectionTitle,
                Name = "sectionTitle",
                CornerRadius = UDim.new(0, 2)
            })
            local titleUnround = self:Instance("Frame", {
                Parent = sectionTitle,
                Name = "titleUnround",
                BackgroundColor3 = Color3.fromRGB(40, 40, 40),
                BorderSizePixel = 0,
                Position = UDim2.new(0, 0, 0, 18),
                Size = UDim2.new(0, 215, 0, 1)
            })

            local itemList, createItem, tooltipDebounce = {}, {}, false

            function createItem:Label(text)
                text = text or "Label"

                local self = Library.UI -- 1. because im lazy and don't want to reference Library.UI, 2. because of localization!
                local labelFrame = self:Instance("Frame", {
                    Parent = sectionBorder,
                    Name = "labelFrame",
                    BackgroundColor3 = Color3.fromRGB(25, 25, 25),
                    BorderSizePixel = 0,
                    Size = UDim2.new(0, 215, 0, 20)
                })
                local labelText = self:Instance("TextLabel", {
                    Parent = labelFrame,
                    Name = "labelText",
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    Size = UDim2.new(0, 215, 0, 20),
                    Font = Enum.Font.SourceSansSemibold,
                    Text = tostring(text),
                    TextColor3 = Color3.fromRGB(200, 200, 200),
                    TextSize = 15,
                    TextStrokeTransparency = 0,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                local labelTextPadding = self:Instance("UIPadding", {
                    Parent = labelText,
                    Name = "labelTextPadding",
                    PaddingLeft = UDim.new(0, 5)
                })
                sectionBorder.Size += UDim2.new(0, 0, 0, 20)

                local properties = {}
                function properties:UpdateText(nText)
                    nText = nText or text
                    labelText.Text = nText
                end
                return properties
            end
            function createItem:Button(text, tooltip, callback)
                text = text or "Button"; tooltip = tooltip or "no tooltip :("; callback = callback or function() end

                local self = Library.UI -- 1. because im lazy and don't want to reference Library.UI, 2. because of localization!
                local buttonFrame = self:Instance("Frame", {
                    Parent = sectionBorder,
                    Name = "buttonFrame",
                    BackgroundColor3 = Color3.fromRGB(25, 25, 25),
                    BorderSizePixel = 0,
                    Size = UDim2.new(0, 215, 0, 20),
                })
                local buttonClick = self:Instance("TextButton", {
                    Parent = buttonFrame,
                    Name = "buttonClick",
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 215, 0, 20),
                    Font = Enum.Font.SourceSansSemibold,
                    TextColor3 = Color3.fromRGB(180, 180, 180),
                    TextSize = 15,
                    TextStrokeTransparency = 0
                })
                sectionBorder.Size += UDim2.new(0, 0, 0, 20)

                buttonClick.MouseEnter:Connect(function()
                    Library.Utils:Tween(buttonClick, TweenInfo.new(0.25, Enum.EasingStyle.Linear), {
                        TextColor3 = Color3.fromRGB(255, 255, 255)
                    }):Play()
                    tip.Text = tooltip
                end)
                buttonClick.MouseLeave:Connect(function()
                    Library.Utils:Tween(buttonClick, TweenInfo.new(0.25, Enum.EasingStyle.Linear), {
                        TextColor3 = Color3.fromRGB(180, 180, 180)
                    }):Play()
                    tip.Text = "inactive tooltip (hover over something :o)"
                end)

                buttonClick.MouseButton1Click:Connect(function()
                    pcall(function() callback() end)
                end)

                local properties = {}
                function properties:UpdateText(nText)
                    nText = nText or text
                    buttonClick.Text = nText
                end
                function properties:UpdateTooltip(nTooltip)
                    nTooltip = nTooltip or tooltip
                    tooltip = nTooltip
                end
                function properties:UpdateCallback(nCallback)
                    nCallback = nCallback or callback
                    callback = nCallback
                end
                function properties:UpdateParams(nText, nTooltip, nCallback)
                    nText = nText or text; nTooltip = nTooltip or tooltip; nCallback = nCallback or callback
                    buttonClick.Text = nText; tooltip = nTooltip; callback = nCallback
                end
                return properties
            end
            function createItem:Toggle(text, tooltip, status, callback)
                text = text or "Toggle"; tooltip = tooltip or "no tooltip :("; status = status or false; callback = callback or function() print("no callback") end
                
                local self = Library.UI -- 1. because im lazy and don't want to reference Library.UI, 2. because of localization!
                local toggleFrame = self:Instance("Frame", {
                    Parent = sectionBorder,
                    Name = "toggleFrame",
                    BackgroundColor3 = Color3.fromRGB(25, 25, 25),
                    BorderSizePixel = 0,
                    Size = UDim2.new(0, 215, 0, 20)
                })
                local toggleClick = self:Instance("TextButton", {
                    Parent = toggleFrame,
                    Name = "toggleClick",
                    BackgroundColor3 = status and Color3.fromRGB(80, 80, 80) or Color3.fromRGB(40, 40, 40),
                    BorderSizePixel = 0,
                    Position = UDim2.new(0, 4, 0, 3),
                    Size = UDim2.new(0, 14, 0, 14),
                    AutoButtonColor = false,
                    Font = Enum.Font.SourceSansSemibold,
                    Text = "",
                    TextColor3 = Color3.fromRGB(255, 255, 255),
                    TextSize = 1,
                    TextStrokeTransparency = 0
                })
                local toggleClickCorner = self:Instance("UICorner", {
                    Parent = toggleClick,
                    Name = "toggleClickCorner",
                    CornerRadius = UDim.new(0, 2)
                })
                local toggleText = self:Instance("TextLabel", {
                    Parent = toggleFrame,
                    Name = "toggleText",
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BackgroundTransparency = 1.000,
                    Position = UDim2.new(0, 25, 0, 0),
                    Size = UDim2.new(0, 185, 0, 20),
                    Font = Enum.Font.SourceSansSemibold,
                    Text = text,
                    TextColor3 = Color3.fromRGB(200, 200, 200),
                    TextSize = 15.000,
                    TextStrokeTransparency = 0.000,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                sectionBorder.Size += UDim2.new(0, 0, 0, 20)

                toggleFrame.MouseEnter:Connect(function()
                    tip.Text = tooltip
                end)
                toggleFrame.MouseLeave:Connect(function()
                    tip.Text = "inactive tooltip (hover over something :o)"
                end)

                toggleClick.MouseEnter:Connect(function()
                    Library.Utils:Tween(toggleClick, TweenInfo.new(0.25, Enum.EasingStyle.Linear), {
                        BackgroundColor3 = status and Color3.fromRGB(40, 40, 40) or Color3.fromRGB(80, 80, 80)
                    }):Play()
                end)
                toggleClick.MouseLeave:Connect(function()
                    Library.Utils:Tween(toggleClick, TweenInfo.new(0.25, Enum.EasingStyle.Linear), {
                        BackgroundColor3 = status and Color3.fromRGB(80, 80, 80) or Color3.fromRGB(40, 40, 40)
                    }):Play()
                end)


                pcall(function() callback(status) end)
                toggleClick.MouseButton1Click:Connect(function()
                    status = not status
                    pcall(function() callback(status) end)
                    Library.Utils:Tween(toggleClick, TweenInfo.new(0.25, Enum.EasingStyle.Linear), {
                        BackgroundColor3 = status and Color3.fromRGB(80, 80, 80) or Color3.fromRGB(40, 40, 40)
                    }):Play()
                end)

                local properties = {}
                function properties:UpdateText(nText)
                    nText = nText or text
                    toggleClick.Text = nText
                end
                function properties:UpdateTooltip(nTooltip)
                    nTooltip = nTooltip or tooltip
                    tooltip = nTooltip
                end
                function properties:UpdateStatus(nStatus)
                    nStatus = nStatus or status
                    status = nStatus
                    Library.Utils:Tween(toggleClick, TweenInfo.new(0.25, Enum.EasingStyle.Linear), {
                        BackgroundColor3 = status and Color3.fromRGB(80, 80, 80) or Color3.fromRGB(40, 40, 40)
                    }):Play()                end
                function properties:UpdateCallback(nCallback)
                    nCallback = nCallback or callback
                    callback = nCallback
                end
                function properties:UpdateParams(nText, nTooltip, nStatus, nCallback)
                    nText = nText or text; nTooltip = nTooltip or tooltip; nStatus = nStatus or status; nCallback = nCallback or callback
                    toggleClick.Text = nText; tooltip = nTooltip; status = nStatus; callback = nCallback
                    Library.Utils:Tween(toggleClick, TweenInfo.new(0.25, Enum.EasingStyle.Linear), {
                        BackgroundColor3 = status and Color3.fromRGB(80, 80, 80) or Color3.fromRGB(40, 40, 40)
                    }):Play()
                end

                function properties:GetStatus()
                    return status
                end
                return properties
            end
            function createItem:Slider(text, tooltip, value, range, callback)
                text = text or "Slider"; tooltip = tooltip or "no tooltip :("; value = value or 0; range = range or {0, 10}; callback = callback or function() end
            
                if (value > range[2]) then value = range[2]
                elseif (value < range[1]) then value = range[1] end

                local valueSize = UDim2.new(value / range[2], 0, 0, 3)
                local self = Library.UI -- 1. because im lazy and don't want to reference Library.UI, 2. because of localization!
                local sliderFrame = self:Instance("Frame", {
                    Parent = sectionBorder,
                    Name = "sliderFrame",
                    BackgroundColor3 = Color3.fromRGB(25, 25, 25),
                    BorderSizePixel = 0,
                    Size = UDim2.new(0, 215, 0, 30)
                })
                local sliderText = self:Instance("TextLabel", {
                    Parent = sliderFrame,
                    Name = "sliderText",
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 175, 0, 20),
                    Font = Enum.Font.SourceSansSemibold,
                    LineHeight = 0.9,
                    Text = text,
                    TextColor3 = Color3.fromRGB(200, 200, 200),
                    TextSize = 15,
                    TextStrokeTransparency = 0,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                local sliderTextPadding = self:Instance("UIPadding", {
                    Parent = sliderText,
                    Name = "sliderTextPadding",
                    PaddingLeft = UDim.new(0, 5)
                })

                local slider = self:Instance("TextButton", {
                    Parent = sliderFrame,
                    Name = "slider",
                    BackgroundColor3 = Color3.fromRGB(40, 40, 40),
                    BorderSizePixel = 0,
                    Position = UDim2.new(0, 4, 0, 21),
                    Size = UDim2.new(0, 207, 0, 5),
                    AutoButtonColor = false,
                    Font = Enum.Font.SourceSansSemibold,
                    Text = "",
                    TextColor3 = Color3.fromRGB(255, 255, 255),
                    TextSize = 1,
                    TextStrokeTransparency = 0,
                })
                local sliderCorner = self:Instance("UICorner", {
                    Parent = slider,
                    Name = "sliderCorner",
                    CornerRadius = UDim.new(0, 2)
                })

                local sliderFill = self:Instance("Frame", {
                    Parent = slider,
                    Name = "sliderFill",
                    BackgroundColor3 = Color3.fromRGB(80, 80, 80),
                    BorderSizePixel = 0,
                    Position = UDim2.new(0, 1, 0, 1),
                    Size = UDim2.new(valueSize, 0, 0, 3)
                })
                local sliderFillCorner = self:Instance("UICorner", {
                    Parent = sliderFill,
                    Name = "sliderFillCorner",
                    CornerRadius = UDim.new(0, 2)
                })

                local sliderValue = self:Instance("TextLabel", {
                    Parent = sliderFrame,
                    Name = "sliderValue",
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    Position = UDim2.new(0, 174, 0, 0),
                    Size = UDim2.new(0, 36, 0, 20),
                    Font = Enum.Font.SourceSansSemibold,
                    LineHeight = 0.9,
                    Text = tostring(value),
                    TextColor3 = Color3.fromRGB(255, 255, 255),
                    TextSize = 15,
                    TextStrokeTransparency = 0,
                    TextWrapped = true,
                    TextXAlignment = Enum.TextXAlignment.Right
                })
                sectionBorder.Size += UDim2.new(0, 0, 0, 30)

                sliderFrame.MouseEnter:Connect(function()
                    tip.Text = tooltip
                end)
                sliderFrame.MouseLeave:Connect(function()
                    tip.Text = "inactive tooltip (hover over something :o)"
                end)
                
                pcall(function() callback(value) end)
                slider.MouseButton1Down:Connect(function()
                    MoveConnection = game:GetService('RunService').Heartbeat:Connect(function()
                        local scale = math.clamp(game.Players.LocalPlayer:GetMouse().X - slider.AbsolutePosition.X, 0, slider.AbsoluteSize.X) /  slider.AbsoluteSize.X
                        value = math.floor(range[1] + ((range[2] - range[1]) * scale))
                        sliderValue.Text = tostring(value)

                        sliderFill.Size = UDim2.new(scale, 0, 0, 3)
                        pcall(function() callback(value) end)
                    end)
                    game:GetService('UserInputService').InputEnded:Connect(function(Check)
                        if Check.UserInputType == Enum.UserInputType.MouseButton1 then
                            if MoveConnection then
                                MoveConnection:Disconnect()
                                MoveConnection = nil
                            end
                        end
                    end)
                end)

                local properties = {}
                function properties:UpdateText(nText)
                    nText = nText or text
                    sliderText.Text = nText
                end
                function properties:UpdateTooltip(nTooltip)
                    nTooltip = nTooltip or tooltip
                    tooltip = nTooltip
                end
                function properties:UpdateValue(nValue)
                    nValue = nValue or value
                    value = nValue

                    if (value > range[2]) then value = range[2]
                    elseif (value < range[1]) then value = range[1] end

                    local valueSize = UDim2.new(value / range[2], 0, 0, 3)
                    sliderFill.Size = valueSize
                end
                function properties:UpdateRange(nRange)
                    nRange = nRange or range
                    range = nRange

                    if (value > range[2]) then value = range[2]
                    elseif (value < range[1]) then value = range[1] end

                    local valueSize = UDim2.new(value / range[2], 0, 0, 3)
                    sliderFill.Size = valueSize
                end
                function properties:UpdateCallback(nCallback)
                    nCallback = nCallback or callback
                    callback = nCallback
                end
                function properties:UpdateParams(nText, nTooltip, nValue, nRange, nCallback)
                    nText = nText or text; nTooltip = nTooltip or tooltip; nValue = nValue or value; nRange = nRange or range; nCallback = nCallback or callback
                    sliderText.Text = nText; tooltip = nTooltip; value = nValue; range = nRange; callback = nCallback

                    if (value > range[2]) then value = range[2]
                    elseif (value < range[1]) then value = range[1] end

                    local valueSize = UDim2.new(value / range[2], 0, 0, 3)
                    sliderFill.Size = valueSize
                end

                function properties:GetValue()
                    return value
                end
                function properties:GetRange()
                    return range
                end
                return properties
            end
            function createItem:Editbox(text, preview, tooltip, callback)
                text = text or "Editbox"; preview = preview or "Editbox preview :)"; tooltip = tooltip or ""; callback = callback or function() end

                local self = Library.UI -- 1. because im lazy and don't want to reference Library.UI, 2. because of localization!
                local editboxFrame = self:Instance("Frame", {
                    Parent = sectionBorder,
                    Name = "editboxFrame",
                    BackgroundColor3 = Color3.fromRGB(25, 25, 25),
                    BorderSizePixel = 0,
                    Position = UDim2.new(0, 1, 0, 1),
                    Size = UDim2.new(0, 215, 0, 45)
                })
                local editboxText = self:Instance("TextLabel", {
                    Parent = editboxFrame,
                    Name = "editboxText",
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    Position = UDim2.new(0, 1, 0, 1),
                    Size = UDim2.new(0, 215, 0, 20),
                    Font = Enum.Font.SourceSansSemibold,
                    Text = text,
                    TextColor3 = Color3.fromRGB(200, 200, 200),
                    TextSize = 15,
                    TextStrokeTransparency = 0,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                local editboxTextPadding = self:Instance("UIPadding", {
                    Parent = editboxText,
                    Name = "editboxTextPadding",
                    PaddingLeft = UDim.new(0, 5)
                })

                local editboxSeparator = self:Instance("Frame", {
                    Parent = editboxFrame,
                    Name = "editboxSeparator",
                    BackgroundColor3 = Color3.fromRGB(40, 40, 40),
                    BorderSizePixel = 0,
                    Position = UDim2.new(0, 5, 0, 21),
                    Size = UDim2.new(0, 205, 0, 1)
                })

                local editboxEditor = self:Instance("TextBox", {
                    Parent = editboxFrame,
                    Name = "editboxEditor",
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BackgroundTransparency = 1.000,
                    BorderSizePixel = 0,
                    Position = UDim2.new(0, 1, 0, 24),
                    Size = UDim2.new(0, 215, 0, 20),
                    Font = Enum.Font.SourceSansSemibold,
                    PlaceholderColor3 = Color3.fromRGB(180, 180, 180),
                    PlaceholderText = preview,
                    Text = "",
                    TextColor3 = Color3.fromRGB(255, 255, 255),
                    TextSize = 15.000,
                    TextStrokeTransparency = 0.000,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                local editboxEditorPadding = self:Instance("UIPadding", {
                    Parent = editboxEditor,
                    Name = "editboxEditorPadding",
                    PaddingLeft = UDim.new(0, 5)
                })
                sectionBorder.Size += UDim2.new(0, 0, 0, 45)

                editboxFrame.MouseEnter:Connect(function()
                    tip.Text = tooltip
                end)
                editboxFrame.MouseLeave:Connect(function()
                    tip.Text = "inactive tooltip (hover over something :o)"
                end)

                editboxEditor.FocusLost:Connect(function()
                    pcall(function() callback(editboxEditor.Text) end)
                end)

                local properties = {}
                function properties:UpdateText(nText)
                    nText = nText or text
                    editboxText.Text = nText
                end
                function properties:UpdatePreview(nPreview)
                    nPreview = nPreview or preview
                    editboxEditor.Text = nPreview
                end
                function properties:UpdateTooltip(nTooltip)
                    nTooltip = nTooltip or tooltip
                    tooltip = nTooltip
                end
                function properties:UpdateCallback(nCallback)
                    nCallback = nCallback or callback
                    callback = nCallback
                end
                function properties:UpdateParams(nText, nPreview, nTooltip, nCallback)
                    nText = nText or text; nTooltip = nTooltip or tooltip; nPreview = nPreview or preview; nCallback = nCallback or callback
                    editboxEditor.Text = nText; tooltip = nTooltip; preview = nPreview; callback = nCallback
                end

                function properties:GetStatus()
                    return editboxEditor.Text
                end
                return properties
            end
            function createItem:Bind(text, tooltip, key, callback)
                text = text or "Bind"; tooltip = tooltip or "no tooltip :("; key = key or Enum.KeyCode.Escape; callback = callback or function() end
                if (key == Enum.KeyCode.Escape) then key = "None" end

                local self, editedRecently = Library.UI, false -- 1. because im lazy and don't want to reference Library.UI, 2. because of localization!
                local bindFrame = self:Instance("Frame", {
                    Parent = sectionBorder,
                    Name = "bindFrame",
                    BackgroundColor3 = Color3.fromRGB(25, 25, 25),
                    BorderSizePixel = 0,
                    Position = UDim2.new(0, 1, 0, 1),
                    Size = UDim2.new(0, 215, 0, 45)
                })
                local bindText = self:Instance("TextLabel", {
                    Parent = bindFrame,
                    Name = "bindText",
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    Position = UDim2.new(0, 1, 0, 1),
                    Size = UDim2.new(0, 215, 0, 20),
                    Font = Enum.Font.SourceSansSemibold,
                    Text = text,
                    TextColor3 = Color3.fromRGB(200, 200, 200),
                    TextSize = 15,
                    TextStrokeTransparency = 0,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                local bindTextPadding = self:Instance("UIPadding", {
                    Parent = bindText,
                    Name = "bindTextPadding",
                    PaddingLeft = UDim.new(0, 5)
                })

                local bindSeparator = self:Instance("Frame", {
                    Parent = bindFrame,
                    Name = "bindSeparator",
                    BackgroundColor3 = Color3.fromRGB(40, 40, 40),
                    BorderSizePixel = 0,
                    Position = UDim2.new(0, 5, 0, 21),
                    Size = UDim2.new(0, 205, 0, 1)
                })

                local bindEdit = self:Instance("TextButton", {
                    Parent = bindFrame,
                    Name = "bindEdit",
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    Position = UDim2.new(0, 1, 0, 24),
                    Size = UDim2.new(0, 215, 0, 20),
                    Font = Enum.Font.SourceSansSemibold,
                    Text = key.Name,
                    TextColor3 = Color3.fromRGB(255, 255, 255),
                    TextSize = 15,
                    TextStrokeTransparency = 0,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                local bindEditPadding = self:Instance("UIPadding", {
                    Parent = bindEdit,
                    Name = "bindEditPadding",
                    PaddingLeft = UDim.new(0, 5)
                })
                sectionBorder.Size += UDim2.new(0, 0, 0, 45)

                bindFrame.MouseEnter:Connect(function()
                    tip.Text = tooltip
                end)
                bindFrame.MouseLeave:Connect(function()
                    tip.Text = "inactive tooltip (hover over something :o)"
                end)

                bindEdit.MouseEnter:Connect(function()
                    Library.Utils:Tween(bindEdit, TweenInfo.new(0.25, Enum.EasingStyle.Linear), {
                        TextColor3 = Color3.fromRGB(255, 255, 255)
                    }):Play()
                end)
                bindEdit.MouseLeave:Connect(function()
                    Library.Utils:Tween(bindEdit, TweenInfo.new(0.25, Enum.EasingStyle.Linear), {
                        TextColor3 = Color3.fromRGB(200, 200, 200)
                    }):Play()
                end)

                bindEdit.MouseButton1Click:Connect(function()
                    bindEdit.Text = "..."
                    local v1, v2 = UIS.InputBegan:Wait();
                    if (v1.KeyCode.Name ~= "Unknown") then
                        bindEdit.Text = v1.KeyCode.Name
                        key = v1.KeyCode.Name; editedRecently =  true
                        if (key == Enum.KeyCode.Escape.Name) then 
                            bindEdit.Text = "None"; key = "None"; editedRecently = false
                        end
                    end
                end)

                local debounce, status = false, false
                UIS.InputBegan:Connect(function(input, gameProcessedEvent)
                    if (not gameProcessedEvent) then 
                        if (input.KeyCode.Name == key) then 
                            if (editedRecently) then editedRecently = false return end
                            if (not debounce) then
                                debounce = true
                                status = not status
                                callback(status, key)
                                Library.Utils:Tween(bindEdit, TweenInfo.new(0.25, Enum.EasingStyle.Linear), {
                                    TextColor3 = status and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 200, 200)
                                }):Play()
                                debounce = false
                            end
                        end
                    end
                end)
            end
            function createItem:Dropdown(text, tooltip, index, items, callback)
                text = text or "Dropdown"; tooltip = tooltip or "no tooltip :("; index = index or 1; items = items or {"No items :("}; callback = callback or function() end
                
                local self, toggled = Library.UI, false -- 1. because im lazy and don't want to reference Library.UI, 2. because of localization!
                local dropdownFrame = self:Instance("Frame", {
                    Parent = sectionBorder,
                    Name = "dropdownFrame",
                    BackgroundColor3 = Color3.fromRGB(25, 25, 25),
                    BorderSizePixel = 0,
                    Position = UDim2.new(0, 0, 0, 53),
                    Size = UDim2.new(0, 215, 0, 42),
                })

                local dropdownText = self:Instance("TextLabel", {
                    Parent = dropdownFrame,
                    Name = "dropdownText",
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 215, 0, 20),
                    Font = Enum.Font.SourceSansSemibold,
                    LineHeight = 0.900,
                    Text = text,
                    TextColor3 = Color3.fromRGB(200, 200, 200),
                    TextSize = 15,
                    TextStrokeTransparency = 0,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                local dropdownTextPadding = self:Instance("UIPadding", {
                    Parent = dropdownText,
                    Name = "dropdownTextPadding",
                    PaddingLeft = UDim.new(0, 5)
                })

                local dropdownBorder = self:Instance("Frame", {
                    Parent = dropdownFrame,
                    Name = "dropdownBorder",
                    BackgroundColor3 = Color3.fromRGB(40, 40, 40),
                    Position = UDim2.new(0, 4, 0, 21),
                    Size = UDim2.new(0, 207, 0, 17)
                })
                local dropdownBorderCorner = self:Instance("UICorner", {
                    Parent = dropdownBorder,
                    Name = "dropdownBorderCorner",
                    CornerRadius = UDim.new(0, 2)
                })

                local dropdownToggle = self:Instance("TextButton", {
                    Parent = dropdownBorder,
                    Name = "dropdownToggle",
                    BackgroundColor3 = Color3.fromRGB(25, 25, 25),
                    Position = UDim2.new(0, 1, 0, 1),
                    Size = UDim2.new(0, 205, 0, 15),
                    AutoButtonColor = false,
                    Font = Enum.Font.SourceSansSemibold,
                    LineHeight = 1.1,
                    Text = items[index],
                    TextColor3 = Color3.fromRGB(180, 180, 180),
                    TextSize = 15,
                    TextStrokeTransparency = 0,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                local dropdownToggleCorner = self:Instance("UICorner", {
                    Parent = dropdownToggle,
                    Name = "dropdownToggleCorner",
                    CornerRadius = UDim.new(0, 2)
                })
                local dropdownTogglePadding = self:Instance("UIPadding", {
                    Parent = dropdownToggle,
                    Name = "dropdownTogglePadding",
                    PaddingLeft = UDim.new(0, 5),
                })

                local dropdownUncorner = self:Instance("Frame", {
                    Parent = dropdownBorder,
                    Name = "dropdownUncorner",
                    BackgroundColor3 = Color3.fromRGB(40, 40, 40),
                    BorderSizePixel = 0,
                    Position = UDim2.new(0, 0, 0, 15),
                    Size = UDim2.new(0, 207, 0, 2),
                    Visible = false,
                    ZIndex = 2
                })
                local dropdownContent = self:Instance("Frame", {
                    Parent = dropdownUncorner,
                    Name = "dropdownContent",
                    BackgroundColor3 = Color3.fromRGB(40, 40, 40),
                    BorderSizePixel = 0,
                    Size = UDim2.new(0, 207, 0, 22),
                    ZIndex = 2
                })
                local dropdownContentCorner = self:Instance("UICorner", {
                    Parent = dropdownContent,
                    Name = "dropdownContent",
                    CornerRadius = UDim.new(0, 2)
                })
                local dropdownContentLayout = self:Instance("UIListLayout", {
                    Parent = dropdownContent,
                    Name = "dropdownContentLayout",
                    HorizontalAlignment = Enum.HorizontalAlignment.Center,
                    SortOrder = Enum.SortOrder.LayoutOrder,
                })
                local dropdownContentSpace = self:Instance("Frame", {
                    Parent = dropdownContent,
                    Name = "dropdownContentSpace",
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    Position = UDim2.new(0, 1, 0, 1),
                    Size = UDim2.new(0, 1, 0, 1)
                })
                sectionBorder.Size += UDim2.new(0, 0, 0, 42)

                dropdownFrame.MouseEnter:Connect(function()
                    tip.Text = tooltip
                end)
                dropdownFrame.MouseLeave:Connect(function()
                    tip.Text = "inactive tooltip (hover over something :o)"
                end)

                dropdownToggle.MouseEnter:Connect(function()
                    Library.Utils:Tween(dropdownToggle, TweenInfo.new(0.25, Enum.EasingStyle.Linear), {
                        BackgroundColor3 = Color3.fromRGB(80, 80, 80),
                        TextColor3 = Color3.fromRGB(255, 255, 255)
                    }):Play()
                end)
                dropdownToggle.MouseLeave:Connect(function()
                    Library.Utils:Tween(dropdownToggle, TweenInfo.new(0.25, Enum.EasingStyle.Linear), {
                        BackgroundColor3 = Color3.fromRGB(25, 25, 25),
                        TextColor3 = Color3.fromRGB(180, 180, 180)
                    }):Play()
                end)

                dropdownToggle.MouseButton1Click:Connect(function()
                    if (#items == 0) then return end
                    toggled = not toggled
                    dropdownUncorner.Visible = toggled
                    dropdownUncorner.Size = UDim2.new(0, 207, 0, (20*#items) + 2)
                end)

                local function createItem(name, pos)
                    name = name or "item"; pos = pos or 1

                    local self = Library.UI -- 1. because im lazy and don't want to reference Library.UI, 2. because of localization!
                    local dropdownItemFrame = self:Instance("Frame", {
                        Parent = dropdownContent,
                        Name = "dropdownItemFrame",
                        BackgroundColor3 = Color3.fromRGB(25, 25, 25),
                        BorderSizePixel = 0,
                        Size = UDim2.new(0, 205, 0, 20),
                        ZIndex = 3
                    })
                    local dropdownItemClick = self:Instance("TextButton", {
                        Name = pos,
                        Parent = dropdownItemFrame,
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        BackgroundTransparency = 1,
                        BorderSizePixel = 0,
                        Size = UDim2.new(0, 205, 0, 20),
                        AutoButtonColor = false,
                        Font = Enum.Font.SourceSansSemibold,
                        Text = name,
                        TextColor3 = index == pos and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 180, 180),
                        TextSize = 15,
                        TextStrokeTransparency = 0,
                        ZIndex = 3
                    })

                    dropdownItemClick.MouseEnter:Connect(function()
                        if (index == pos) then return end
                        Library.Utils:Tween(dropdownItemClick, TweenInfo.new(0.25, Enum.EasingStyle.Linear), {
                            TextColor3 = Color3.fromRGB(255, 255, 255)
                        }):Play()
                    end)
                    dropdownItemClick.MouseLeave:Connect(function()
                        if (index == pos) then return end
                        Library.Utils:Tween(dropdownItemClick, TweenInfo.new(0.25, Enum.EasingStyle.Linear), {
                            TextColor3 = Color3.fromRGB(180, 180, 180)
                        }):Play()
                    end)

                    dropdownItemClick.MouseButton1Click:Connect(function()
                        if (index == pos) then return end

                        if (dropdownContent:FindFirstChild(index)) then
                            Library.Utils:Tween(dropdownContent[index], TweenInfo.new(0.25, Enum.EasingStyle.Linear), {
                                TextColor3 = Color3.fromRGB(180, 180, 180)
                            }):Play()
                        end

                        Library.Utils:Tween(dropdownItemClick, TweenInfo.new(0.25, Enum.EasingStyle.Linear), {
                            TextColor3 = Color3.fromRGB(255, 255, 255)
                        }):Play()
                        
                        index = pos
                        dropdownToggle.Text = items[index]
                        dropdownUncorner.Visible = false
                        toggled = false
                        pcall(function() callback(index, items[index]) end)
                    end)
                end

                for i=1, #items do
                    createItem(items[i], i)
                end

                local properties = {}

                return properties
            end
            return createItem
        end
        return sectionList
    end
    return tabList
end

Library.Teleport = {}
Library.Teleport.TweenAnim = nil
Library.Teleport.TweenAnimFinished = true
Library.Teleport.Style = {
	Linear = 1,
	Instant = 2,
}
Library.Teleport.Type = {
	Regular = 1,
	Mouse = 2
}
Library.Teleport.Settings = {
	CustomStudSpeed = 200,
	MinimumInstantTeleport = 0,
	MaximumInstantTeleport = 500,
}

function Library.Teleport:Tween(part, info, props)
	if (Library.Teleport.TweenAnim ~= nil) then Library.Teleport.TweenAnim:Cancel(); Library.Teleport.TweenAnimFinished = true end 
	Library.Teleport.TweenAnim = TweenService:Create(part, info, props); Library.Teleport.TweenAnim:Play(); Library.Teleport.TweenAnimFinished = false
	Library.Teleport.TweenAnim.Completed:Wait(); Library.Teleport.TweenAnimFinished = true; Library.Teleport.TweenAnim = nil
end
function Library.Teleport:Fastcall(v) 
	local r = Vector3.new(0, 0, 0)
	if (typeof(v) == "CFrame") then       r = Vector3.new(v.X, v.Y, v.Z)
	elseif (typeof(v) == "Instance") then r = Vector3.new(v.CFrame.X, v.CFrame.Y, v.CFrame.Z) 
	elseif (typeof(v) == "Vector3") then  r = v 
	else Library.UI:CreateNotification("an obstruction has occured", "sorry, we have no current support for type ".. typeof(v).. " . We only support cframe, instance, and vector3 at this time.", 5)
	end	

	return r
end

function Library.Teleport:Distance(v)
	return (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - Library.Teleport:Fastcall(v)).Magnitude
end
function Library.Teleport:Advanced(...)
	local lp = game.Players.LocalPlayer
	local Mouse = lp:GetMouse()
	local params = {...}

	if (lp.Character == nil) then 
		Library.UI:CreateNotification("an obstruction has occured", "sorry, we cannot locate the localplayer try again", 5)
		return
	end
	if (params[1] == nil) then 
		Library.UI:CreateNotification("an obstruction has occured", "sorry, you need to provide teleport type", 5)
		return
	end
	if (params[1] == Library.Teleport.Type.Mouse) then
		local Hit = Mouse.Hit.p + Vector3.new(0, 5, 0)

		if (params[2] == Library.Teleport.Style.Instant) then 
			lp.Character.HumanoidRootPart.CFrame = CFrame.new(Hit)
		else
			local Speed = Library.Teleport:Distance(Hit) / Library.Teleport.Settings.CustomStudSpeed
			Library.Teleport:Tween(
				lp.Character.HumanoidRootPart,
				TweenInfo.new(Speed, Enum.EasingStyle.Linear),
				{ CFrame = CFrame.new(Hit) }
			)
		end
	else
		if (params[2] == nil) then 
			Library.UI:CreateNotification("an obstruction has occured", "sorry, you need to provide a cframe, instance, or a vector3 in paramater #2", 5)
			return
		end

		local t = Library.Teleport:Fastcall(params[2])

		if (params[2] == Library.Teleport.Style.Instant) then 
			lp.Character.HumanoidRootPart.CFrame = CFrame.new(t)
		else
			local Speed = Library.Teleport:Distance(t) / Library.Teleport.Settings.CustomStudSpeed
			Library.Teleport:Tween(
				lp.Character.HumanoidRootPart,
				TweenInfo.new(Speed, Enum.EasingStyle.Linear),
				{ CFrame = CFrame.new(t) }
			)
		end
	end
end
function Library.Teleport:Smart(...)
	local lp = game.Players.LocalPlayer
	local Mouse = lp:GetMouse()
	local params = {...}

	if (lp.Character == nil) then 
		Library.UI:CreateNotification("an obstruction has occured", "sorry, we cannot locate the localplayer try again", 5)
		return
	end
	if (params[1] == nil) then 
		Library.UI:CreateNotification("an obstruction has occured", "sorry, you need to provide teleport type", 1, 5)
		return
	end
	if (params[1] == Library.Teleport.Type.Mouse) then
		local Hit = Mouse.Hit.p + Vector3.new(0, 5, 0)

		if (Library.Teleport:Distance(Hit) >= Library.Teleport.Settings.MinimumInstantTeleport and Library.Teleport:Distance(Hit) <= Library.Teleport.Settings.MaximumInstantTeleport) then
			lp.Character.HumanoidRootPart.CFrame = CFrame.new(Hit)
			return
		end

		local Speed = Library.Teleport:Distance(Hit) / Library.Teleport.Settings.CustomStudSpeed
		Library.Teleport:Tween(
			lp.Character.HumanoidRootPart,
			TweenInfo.new(Speed, Enum.EasingStyle.Linear),
			{ CFrame = CFrame.new(Hit) }
		)
	else
		if (params[2] == nil) then 
			Library.UI:CreateNotification("an obstruction has occured", "sorry, you need to provide a cframe, instance, or a vector3 in paramater #2", 5)
			return
		end

		local t = Library.Teleport:Fastcall(params[2])

		if (Library.Teleport:Distance(t) >= Library.Teleport.Settings.MinimumInstantTeleport and Library.Teleport:Distance(t) <= Library.Teleport.Settings.MaximumInstantTeleport) then
			lp.Character.HumanoidRootPart.CFrame = CFrame.new(t)
			return
		end

		local Speed = Library.Teleport:Distance(t) / Library.Teleport.Settings.CustomStudSpeed
		Library.Teleport:Tween(
			lp.Character.HumanoidRootPart,
			TweenInfo.new(Speed, Enum.EasingStyle.Linear),
			{ CFrame = CFrame.new(t) }
		)
	end
end

return Library
