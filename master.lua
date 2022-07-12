local CoreGui, TweenService, TextService, UIS, Mouse = game:GetService("CoreGui"), game:GetService("TweenService"), game:GetService("TextService"), game:GetService("UserInputService"), game.Players.LocalPlayer:GetMouse()
local Library = {}

Library.Utils = {}
function Library.Utils:Drag(Instance)
	local gui = Instance

	local dragging
	local dragInput
	local dragStart
	local startPos

	local function update(input)
		local delta = input.Position - dragStart
		gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
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

Library.UI = {}
Library.UI.ScreenGui = Instance.new("ScreenGui")
Library.UI.ScreenGui.Name = "Synapense"
Library.UI.ScreenGui.Parent = game.CoreGui

function Library.UI:CreateNotification(title, message, duration)
    title = title or "title"; message = message or "message"; duration = duration or 2.5
    if (not Library.UI.ScreenGui:FindFirstChild("notificationList")) then 
        local notificationList = Instance.new("Frame")
        local notificationListLayout = Instance.new("UIListLayout")

        notificationList.Name = "notificationList"
        notificationList.Parent = game.StarterGui.Synapense
        notificationList.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        notificationList.BackgroundTransparency = 1.000
        notificationList.Size = UDim2.new(0, 300, 1, 0)
    
        notificationListLayout.Parent = notificationList
        notificationListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        notificationListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        notificationListLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
    end

    local notificationMain = Instance.new("Frame")
    notificationMain.Name = "notificationMain"
    notificationMain.Parent = Library.UI.ScreenGui:FindFirstChild("notificationList")
    notificationMain.BackgroundColor3 = Color3.fromRGB(38, 34, 36)
    notificationMain.BorderColor3 = Color3.fromRGB(0, 0, 0)
    notificationMain.Size = UDim2.new(0, 250, 0, 200)

    local notificationspace = Instance.new("Frame")
    notificationspace.Name = "notificationspace"
    notificationspace.Parent = Library.UI.ScreenGui:FindFirstChild("notificationList")
    notificationspace.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    notificationspace.BackgroundTransparency = 1.000
    notificationspace.Size = UDim2.new(1, 0, 0, 5)

    local notificationMainBorder = Instance.new("Frame")
    notificationMainBorder.Name = "notificationMainBorder"
    notificationMainBorder.Parent = notificationMain
    notificationMainBorder.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
    notificationMainBorder.BorderColor3 = Color3.fromRGB(58, 58, 58)
    notificationMainBorder.Position = UDim2.new(0.0140000004, 0, 0.0179999992, 0)
    notificationMainBorder.Size = UDim2.new(1, -8, 1, -8)

    local notificationAccent = Instance.new("Frame")
    notificationAccent.Name = "notificationAccent"
    notificationAccent.Parent = notificationMainBorder
    notificationAccent.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    notificationAccent.BorderSizePixel = 0
    notificationAccent.Position = UDim2.new(0, 1, 0, 1)
    notificationAccent.Size = UDim2.new(1, -2, 0, 2)

    local notificationAccentGradient = Instance.new("UIGradient")
    notificationAccentGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(55, 157, 187)), ColorSequenceKeypoint.new(0.50, Color3.fromRGB(175, 73, 160)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(184, 197, 64))}
    notificationAccentGradient.Name = "notificationAccentGradient"
    notificationAccentGradient.Parent = notificationAccent

    local notificationBox = Instance.new("Frame")
    notificationBox.Name = "notificationBox"
    notificationBox.Parent = notificationMainBorder
    notificationBox.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    notificationBox.BorderColor3 = Color3.fromRGB(47, 47, 47)
    notificationBox.Position = UDim2.new(0, 8, 0, 11)
    notificationBox.Size = UDim2.new(0, 226, 0, 173)

    local notificationTitle = Instance.new("TextLabel")
    notificationTitle.Name = "notificationTitle"
    notificationTitle.Parent = notificationBox
    notificationTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    notificationTitle.BackgroundTransparency = 1.000
    notificationTitle.BorderSizePixel = 0
    notificationTitle.Position = UDim2.new(0, 5, 0, -8)
    notificationTitle.Size = UDim2.new(0, 60, 0, 13)
    notificationTitle.ZIndex = 2
    notificationTitle.Font = Enum.Font.SourceSansBold
    notificationTitle.Text = title
    notificationTitle.TextColor3 = Color3.fromRGB(150, 150, 150)
    notificationTitle.TextSize = 13.000

    local notificationTitleClear = Instance.new("Frame")
    notificationTitleClear.Name = "notificationTitleClear"
    notificationTitleClear.Parent = notificationBox
    notificationTitleClear.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
    notificationTitleClear.BorderSizePixel = 0
    notificationTitleClear.Position = UDim2.new(0, 5, 0, -1)
    notificationTitleClear.Size = UDim2.new(0, 60, 0, 1)

    local notificationMessage = Instance.new("TextLabel")
    notificationMessage.Name = "notificationMessage"
    notificationMessage.Parent = notificationBox
    notificationMessage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    notificationMessage.BackgroundTransparency = 1.000
    notificationMessage.Position = UDim2.new(0, 0, 0.0289017335, 0)
    notificationMessage.Size = UDim2.new(1, 0, 1, -5)
    notificationMessage.Font = Enum.Font.SourceSans
    notificationMessage.Text = message
    notificationMessage.TextColor3 = Color3.fromRGB(150, 150, 150)
    notificationMessage.TextSize = 14.000
    notificationMessage.TextWrapped = true
    notificationMessage.TextXAlignment = Enum.TextXAlignment.Left
    notificationMessage.TextYAlignment = Enum.TextYAlignment.Top

    local notificationMessagePadding = Instance.new("UIPadding")
    notificationMessagePadding.Parent = notificationMessage
    notificationMessagePadding.PaddingLeft = UDim.new(0, 8)

    local debounce = false
    task.spawn(function()
        if (not debounce) then 
            debounce = true
            task.wait(duration)
            notificationMain:Destroy()
            debounce = false
        end
    end)
end

function Library.UI:CreateWindow()
    if (CoreGui:FindFirstChild("Synapense") and CoreGui:FindFirstChild("Synapense") ~= Library.UI.ScreenGui) then CoreGui:FindFirstChild("Synapense"):Destroy() end

    local main = Instance.new("Frame")
    main.Name = "main"
    main.Parent = Library.UI.ScreenGui
    main.Active = true
    main.BackgroundColor3 = Color3.fromRGB(38, 34, 36)
    main.BorderColor3 = Color3.fromRGB(0, 0, 0)
    main.Position = UDim2.new(0.154228851, 0, 0.187864646, 0)
    main.Selectable = true
    main.Size = UDim2.new(0, 650, 0, 498)
    
    local border = Instance.new("Frame")
    border.Name = "border"
    border.Parent = main
    border.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
    border.BorderColor3 = Color3.fromRGB(58, 58, 58)
    border.Position = UDim2.new(0.00615384616, 0, 0.00803212821, 0)
    border.Size = UDim2.new(1, -8, 1, -8)
    
    local accent = Instance.new("Frame")
    accent.Name = "accent"
    accent.Parent = border
    accent.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    accent.BorderSizePixel = 0
    accent.Position = UDim2.new(0, 1, 0, 1)
    accent.Size = UDim2.new(1, -2, 0, 2)
    
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(55, 157, 187)), ColorSequenceKeypoint.new(0.50, Color3.fromRGB(175, 73, 160)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(184, 197, 64))}
    gradient.Name = "gradient"
    gradient.Parent = accent
    
    local sections = Instance.new("Frame")
    sections.Name = "sections"
    sections.Parent = border
    sections.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    sections.BorderColor3 = Color3.fromRGB(47, 47, 47)
    sections.Position = UDim2.new(0, 8, 0, 11)
    sections.Size = UDim2.new(0, 122, 0, 471)

    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Parent = sections
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

    local groupboxes = Instance.new("Frame")
    groupboxes.Name = "groupboxes"
    groupboxes.Parent = border
    groupboxes.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    groupboxes.BackgroundTransparency = 1.000
    groupboxes.BorderSizePixel = 0
    groupboxes.Position = UDim2.new(0.215096548, 0, 0, 11)
    groupboxes.Size = UDim2.new(0, 497, 0, 471)    

    Library.Utils:Drag(main)

    local sectionsCreate = {}
    local activeSection = nil
    
    function sectionsCreate:Section(sText)
        sText = sText or "section"
        local tween = nil

        local sectionFrame = Instance.new("Frame")
        sectionFrame.Name = "sectionFrame"
        sectionFrame.Parent = sections
        sectionFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        sectionFrame.BackgroundTransparency = 1.000
        sectionFrame.Size = UDim2.new(0, 122, 0, 15)
    
        local sectionClick = Instance.new("TextButton")
        sectionClick.Name = "sectionClick"
        sectionClick.Parent = sectionFrame
        sectionClick.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        sectionClick.BackgroundTransparency = 1.000
        sectionClick.BorderSizePixel = 0
        sectionClick.Size = UDim2.new(0, 122, 0, 15)
        sectionClick.Font = Enum.Font.SourceSans
        sectionClick.Text = sText
        sectionClick.TextColor3 = Color3.fromRGB(150, 150, 150)
        sectionClick.TextSize = 14.000
        sectionClick.TextXAlignment = Enum.TextXAlignment.Left
    
        local sectionClickPadding = Instance.new("UIPadding")
        sectionClickPadding.Parent = sectionClick
        sectionClickPadding.PaddingLeft = UDim.new(0, 5)

        local folder = Instance.new("Folder")
        folder.Name = sText
        folder.Parent = groupboxes

        local folderLayout = Instance.new("UIGridLayout")
        folderLayout.Parent = folder
        folderLayout.SortOrder = Enum.SortOrder.LayoutOrder
        folderLayout.CellPadding = UDim2.new(0, 8, 0, 8)
        folderLayout.CellSize = UDim2.new(0, 244, 0, 231)
        folderLayout.FillDirectionMaxCells = 2

        if (activeSection == nil) then 
            sectionClick.TextColor3 = Color3.fromRGB(124, 193, 21)
            activeSection = sectionFrame
        end

        sectionClick.MouseEnter:Connect(function()
            if (activeSection == sectionFrame) then return end
            tween = TweenService:Create(sectionClick, TweenInfo.new(0.25, Enum.EasingStyle.Linear), {TextColor3 = Color3.fromRGB(124, 193, 21)}); tween:Play()
        end)

        sectionClick.MouseLeave:Connect(function()
            if (activeSection == sectionFrame) then return end
            tween = TweenService:Create(sectionClick, TweenInfo.new(0.25, Enum.EasingStyle.Linear), {TextColor3 = Color3.fromRGB(150, 150, 150)}); tween:Play()
        end)

        sectionClick.MouseButton1Click:Connect(function()
            if (activeSection == sectionFrame) then return end
            tween = TweenService:Create(activeSection.sectionClick, TweenInfo.new(0.25, Enum.EasingStyle.Linear), {TextColor3 = Color3.fromRGB(150, 150, 150)}); tween:Play()
            for i, v in pairs(groupboxes:GetDescendants()) do
                if (v.Parent == sectionFrame and v.Name == "groupbox") then 
                    v.Visible = true
                elseif (v.Parent ~= sectionFrame and v.Name == "groupbox") then 
                    v.Visible = false
                end
            end
            activeSection = sectionFrame
        end)

        local groupboxCreate = {}
        local pGroupboxCount = 0
        function groupboxCreate:Groupbox(gText)
            gText = gText or "groupbox"
            pGroupboxCount += 1
            print(pGroupboxCount)

            local groupbox = Instance.new("Frame")
            groupbox.Name = "groupbox"
            groupbox.Parent = folder
            groupbox.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
            groupbox.BorderColor3 = Color3.fromRGB(47, 47, 47)
            groupbox.Size = UDim2.new(0, 100, 0, 100)
        
            local gTextSize = Library.Utils:StringSize(gText, 13, Enum.Font.SourceSansBold)
            local groupboxTitle = Instance.new("TextLabel")
            groupboxTitle.Name = "groupboxTitle"
            groupboxTitle.Parent = groupbox
            groupboxTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            groupboxTitle.BackgroundTransparency = 1.000
            groupboxTitle.BorderSizePixel = 0
            groupboxTitle.Position = UDim2.new(0, 5, 0, -8)
            groupboxTitle.Size = UDim2.new(0, gTextSize.X + 5, 0, 13)
            groupboxTitle.ZIndex = 2
            groupboxTitle.Font = Enum.Font.SourceSansBold
            groupboxTitle.Text = gText
            groupboxTitle.TextColor3 = Color3.fromRGB(150, 150, 150)
            groupboxTitle.TextSize = 13.000

            local groupboxTitleClear = Instance.new("Frame")
            groupboxTitleClear.Name = "groupboxTitleClear"
            groupboxTitleClear.Parent = groupbox
            groupboxTitleClear.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
            groupboxTitleClear.BorderSizePixel = 0
            groupboxTitleClear.Position = UDim2.new(0, 5, 0, -1)
            groupboxTitleClear.Size = UDim2.new(0, gTextSize.X + 6, 0, 1)
        
            local groupboxItems = Instance.new("ScrollingFrame")
            groupboxItems.Name = "groupboxItems"
            groupboxItems.Parent = groupbox
            groupboxItems.Active = true
            groupboxItems.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            groupboxItems.BackgroundTransparency = 1.000
            groupboxItems.BorderSizePixel = 0
            groupboxItems.Size = UDim2.new(1, 0, 1, 0)
            groupboxItems.ScrollBarThickness = 0
        
            local groupboxItemsLayout = Instance.new("UIListLayout")
            groupboxItemsLayout.Parent = groupboxItems
            groupboxItemsLayout.SortOrder = Enum.SortOrder.LayoutOrder
            groupboxItemsLayout.Padding = UDim.new(0, 3)
        
            local groupboxItemsSpacer = Instance.new("Frame")
            groupboxItemsSpacer.Name = "groupboxItemsSpacer"
            groupboxItemsSpacer.Parent = groupboxItems
            groupboxItemsSpacer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            groupboxItemsSpacer.BackgroundTransparency = 1.000
            groupboxItemsSpacer.BorderSizePixel = 0
            groupboxItemsSpacer.Size = UDim2.new(0, 244, 0, 5)

            local itemsCreate = {}

            function itemsCreate:Label(text)
                text = text or "label"

                local labelFrame = Instance.new("Frame")
                labelFrame.Name = "labelFrame"
                labelFrame.Parent = groupboxItems
                labelFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                labelFrame.BackgroundTransparency = 1.000
                labelFrame.Size = UDim2.new(0, 244, 0, 15)
            
                local label = Instance.new("TextLabel")
                label.Name = "label"
                label.Parent = labelFrame
                label.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                label.BackgroundTransparency = 1.000
                label.BorderSizePixel = 0
                label.Position = UDim2.new(0, 27, 0, 0)
                label.Size = UDim2.new(0, 216, 0, 15)
                label.Font = Enum.Font.SourceSans
                label.Text = text
                label.TextColor3 = Color3.fromRGB(150, 150, 150)
                label.TextSize = 14.000
                label.TextXAlignment = Enum.TextXAlignment.Left

                local props = {}
                function props:SetText(nText)
                    nText = nText or text; text = nText; label.Text = text
                end
                return props
            end

            function itemsCreate:Button(text, callback)
                text = text or "button"; callback = callback or function() end

                local buttonFrame = Instance.new("Frame")
                buttonFrame.Name = "button"
                buttonFrame.Parent = groupboxItems
                buttonFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                buttonFrame.BackgroundTransparency = 1.000
                buttonFrame.Size = UDim2.new(0, 244, 0, 22)
            
                local button = Instance.new("TextButton")
                button.Name = "button"
                button.Parent = buttonFrame
                button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                button.BorderColor3 = Color3.fromRGB(0, 0, 0)
                button.Position = UDim2.new(0, 27, 0, 2)
                button.Size = UDim2.new(0, 184, 0, 20)
                button.AutoButtonColor = false
                button.Font = Enum.Font.SourceSans
                button.Text = text
                button.TextColor3 = Color3.fromRGB(150, 150, 150)
                button.TextSize = 14.000

                button.MouseEnter:Connect(function()
                    tween = TweenService:Create(button, TweenInfo.new(0.25, Enum.EasingStyle.Linear), {TextColor3 = Color3.fromRGB(124, 193, 21)}); tween:Play()
                end)
        
                button.MouseLeave:Connect(function()
                    tween = TweenService:Create(button, TweenInfo.new(0.25, Enum.EasingStyle.Linear), {TextColor3 = Color3.fromRGB(150, 150, 150)}); tween:Play()
                end)

                button.MouseButton1Click:Connect(function()
                    pcall(function() callback() end)
                end)

                local props = {}
                function props:SetText(nText)
                    nText = nText or text; text = nText; button.Text = text
                end
                function props:Update(nText, nCallback)
                    nText = nText or text; nCallback = nCallback or callback
                    button.Text = text; callback = nCallback
                end
                return props
            end

            function itemsCreate:Toggle(text, state, callback)
                text = text or "toggle"; state = state or false; callback = callback or function() end
                local value = state

                local toggleFrame = Instance.new("Frame")
                toggleFrame.Name = "toggleFrame"
                toggleFrame.Parent = groupboxItems
                toggleFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                toggleFrame.BackgroundTransparency = 1.000
                toggleFrame.Size = UDim2.new(0, 244, 0, 15)
            
                local toggleClick = Instance.new("TextButton")
                toggleClick.Name = "toggleClick"
                toggleClick.Parent = toggleFrame
                toggleClick.BackgroundColor3 = value and Color3.fromRGB(124, 193, 21) or Color3.fromRGB(40, 40, 40)
                toggleClick.BorderColor3 = Color3.fromRGB(0, 0, 0)
                toggleClick.Position = UDim2.new(0, 11, 0, 3)
                toggleClick.Size = UDim2.new(0, 9, 0, 9)
                toggleClick.Font = Enum.Font.SourceSans
                toggleClick.Text = ""
                toggleClick.TextColor3 = Color3.fromRGB(0, 0, 0)
                toggleClick.TextSize = 14.000
            
                local toggleLabel = Instance.new("TextLabel")
                toggleLabel.Name = "toggleLabel"
                toggleLabel.Parent = toggleFrame
                toggleLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                toggleLabel.BackgroundTransparency = 1.000
                toggleLabel.BorderSizePixel = 0
                toggleLabel.Position = UDim2.new(0, 27, 0, 0)
                toggleLabel.Size = UDim2.new(0, 216, 0, 15)
                toggleLabel.Font = Enum.Font.SourceSans
                toggleLabel.Text = text
                toggleLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
                toggleLabel.TextSize = 14.000
                toggleLabel.TextXAlignment = Enum.TextXAlignment.Left

                
                pcall(function() callback(value) end)

                toggleClick.MouseEnter:Connect(function()
                    tween = TweenService:Create(toggleClick, TweenInfo.new(0.25, Enum.EasingStyle.Linear), {BackgroundColor3 = value and Color3.fromRGB(124, 193, 21) or Color3.fromRGB(40, 40, 40)}); tween:Play()
                end)
        
                toggleClick.MouseLeave:Connect(function()
                    tween = TweenService:Create(toggleClick, TweenInfo.new(0.25, Enum.EasingStyle.Linear), {BackgroundColor3 = value and Color3.fromRGB(124, 193, 21) or Color3.fromRGB(40, 40, 40)}); tween:Play()
                end)

                toggleClick.MouseButton1Click:Connect(function()
                    value = not value
                    pcall(function() callback(value) end)
                    tween = TweenService:Create(toggleClick, TweenInfo.new(0.25, Enum.EasingStyle.Linear), {BackgroundColor3 = value and Color3.fromRGB(124, 193, 21) or Color3.fromRGB(40, 40, 40)}); tween:Play()
                end)
                
                local props = {}
                function props:SetText(nText)
                    nText = nText or text; text = nText
                    toggleLabel.Text = text
                end
                function props:SetValue(nValue)
                    nValue = nValue or value
                    value = nValue

                    pcall(function() callback(value) end)
                    tween = TweenService:Create(toggleClick, TweenInfo.new(0.25, Enum.EasingStyle.Linear), {BackgroundColor3 = value and Color3.fromRGB(124, 193, 21) or Color3.fromRGB(40, 40, 40)}); tween:Play()
                end
                function props:Update(nText, nValue)
                    nText = nText or text; nValue = nValue or value
                    text = nText; value = nValue

                    pcall(function() callback(value) end)
                    toggleLabel.Text = text
                    tween = TweenService:Create(toggleClick, TweenInfo.new(0.25, Enum.EasingStyle.Linear), {BackgroundColor3 = value and Color3.fromRGB(124, 193, 21) or Color3.fromRGB(40, 40, 40)}); tween:Play()
                end
                return props
            end

            function itemsCreate:Slider(text, start, range, callback)
                text = text or "slider"; start = start or 0; range = range or {0,10}; callback = callback or function() end
                local value = start
                if (value > range[2]) then 
                    value =  range[2]
                elseif (value < range[1]) then 
                    value =  range[1]
                end

                local sliderFrame = Instance.new("Frame")
                sliderFrame.Name = "sliderFrame"
                sliderFrame.Parent = groupboxItems
                sliderFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                sliderFrame.BackgroundTransparency = 1.000
                sliderFrame.Size = UDim2.new(0, 244, 0, 30)
            
                local sliderLabel = Instance.new("TextLabel")
                sliderLabel.Name = "sliderLabel"
                sliderLabel.Parent = sliderFrame
                sliderLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                sliderLabel.BackgroundTransparency = 1.000
                sliderLabel.BorderSizePixel = 0
                sliderLabel.Position = UDim2.new(0, 27, 0, 0)
                sliderLabel.Size = UDim2.new(0, 216, 0, 15)
                sliderLabel.Font = Enum.Font.SourceSans
                sliderLabel.Text = text
                sliderLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
                sliderLabel.TextSize = 14.000
                sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
            
                local slide = Instance.new("TextButton")
                slide.Name = "slide"
                slide.Parent = sliderFrame
                slide.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                slide.BorderColor3 = Color3.fromRGB(0, 0, 0)
                slide.Position = UDim2.new(0, 27, 0, 17)
                slide.Size = UDim2.new(0, 184, 0, 10)
                slide.Font = Enum.Font.SourceSans
                slide.Text = ""
                slide.TextColor3 = Color3.fromRGB(0, 0, 0)
                slide.TextSize = 14.000
            
                local valueSize = UDim2.new(value / range[2], 0, 1, 0)
                if (value == range[1]) then valueSize = UDim2.new(0, 0, 1, 0) end
                local sliderFill = Instance.new("Frame")
                sliderFill.Name = "sliderFill"
                sliderFill.Parent = slide
                sliderFill.BackgroundColor3 = Color3.fromRGB(124, 193, 21)
                sliderFill.BorderColor3 = Color3.fromRGB(27, 42, 53)
                sliderFill.BorderSizePixel = 0
                sliderFill.Size = valueSize
            
                local sliderValue = Instance.new("TextLabel")
                sliderValue.Name = "sliderValue"
                sliderValue.Parent = sliderFill
                sliderValue.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                sliderValue.BackgroundTransparency = 1.000
                sliderValue.Position = UDim2.new(0, 184, 0, 3)
                sliderValue.Size = UDim2.new(0, 0, 0, 10)
                sliderValue.Font = Enum.Font.SourceSansBold
                sliderValue.Text = tostring(value)
                sliderValue.TextColor3 = Color3.fromRGB(150, 150, 150)
                sliderValue.TextSize = 14.000
                sliderValue.TextStrokeTransparency = 0.000

                pcall(function() callback(value) end)
                slide.MouseButton1Down:Connect(function()
                    MoveConnection = game:GetService('RunService').Heartbeat:Connect(function()
                        local scale = math.clamp(game.Players.LocalPlayer:GetMouse().X - slide.AbsolutePosition.X, 0, slide.AbsoluteSize.X) /  slide.AbsoluteSize.X
                        value = math.floor(range[1] + ((range[2] - range[1]) * scale))
                        sliderValue.Text = value

                        sliderFill.Size = UDim2.new(scale, 0, 1, 0)
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

                local props = {}
                function props:SetText(nText)
                    nText = nText or text; text = nText; sliderLabel.Text = text
                end
                function props:SetValue(nValue)
                    nValue = nValue or value
                    if (value > range[2]) then 
                        value = range[2]
                    elseif (value < range[1]) then 
                        value = range[1]
                    end
                    
                    if (value > 0) then 
                        local scale = value / range[2]
                        if (value == range[1]) then scale = UDim2.new(0, 0, 1, 0) end
                        sliderValue.Text = value

                        sliderFill.Size = UDim2.new(scale, 0, 1, 0)
                        pcall(function() callback(value) end)
                    else
                        sliderValue.Text = value

                        sliderFill.Size = UDim2.new(0, 0, 1, 0)
                        pcall(function() callback(value) end)
                    end
                end
                function props:SetRange(nRange)
                    nRange = nRange or range
                    if (value > nRange[2]) then 
                        value = nRange[2]
                    elseif (value < nRange[1]) then 
                        value = nRange[1]
                    end
                    range = nRange

                    if (value > 0) then 
                        local scale = value / range[2]
                        if (value == range[1]) then scale = UDim2.new(0, 0, 1, 0) end
                        sliderValue.Text = value

                        sliderFill.Size = UDim2.new(scale, 0, 1, 0)
                        pcall(function() callback(value) end)
                    else
                        sliderValue.Text = value

                        sliderFill.Size = UDim2.new(0, 0, 1, 0)
                        pcall(function() callback(value) end)
                    end
                end
                function props:Update(nText, nValue, nRange)
                    nText = nText or text; nValue = nValue or value; nRange = nRange or range
                    if (nValue > nRange[2]) then 
                        nValue =  nRange[2]
                    elseif (nValue < nRange[1]) then 
                        nValue =  nRange[1]
                    end
                    sliderLabel.Text = text; range = nRange

                    local scale = value / range[2]
                    if (value == range[1]) then scale = UDim2.new(0, 0, 1, 0) end
                    sliderValue.Text = nValue

                    sliderFill.Size = UDim2.new(scale, 0, 1, 0)
                    pcall(function() callback(value) end)
                end
                return props
            end

            function itemsCreate:Bind(text, key, callback)
                text = text or "toggle bind"; key = key or Enum.KeyCode.Escape; callback = callback or function() end
                local bindName, editedRecently, value = key.Name, false, false
                if (bindName == Enum.KeyCode.Escape.Name) then bindName = "-" end

                local bindFrame = Instance.new("Frame")
                bindFrame.Name = "bindFrame"
                bindFrame.Parent = groupboxItems
                bindFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                bindFrame.BackgroundTransparency = 1.000
                bindFrame.Size = UDim2.new(1, 0, 0, 15)
            
                local bindLabel = Instance.new("TextLabel")
                bindLabel.Name = "bindLabel"
                bindLabel.Parent = bindFrame
                bindLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                bindLabel.BackgroundTransparency = 1.000
                bindLabel.BorderSizePixel = 0
                bindLabel.Position = UDim2.new(0, 27, 0, 0)
                bindLabel.Size = UDim2.new(0, 216, 0, 15)
                bindLabel.Font = Enum.Font.SourceSans
                bindLabel.Text = text
                bindLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
                bindLabel.TextSize = 14.000
                bindLabel.TextXAlignment = Enum.TextXAlignment.Left
            
                local bindEdit = Instance.new("TextButton")
                bindEdit.Name = "bindEdit"
                bindEdit.Parent = bindFrame
                bindEdit.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                bindEdit.BackgroundTransparency = 1.000
                bindEdit.Position = UDim2.new(0.779999971, 0, 0, 0)
                bindEdit.Size = UDim2.new(0, 20, 1, 0)
                bindEdit.Font = Enum.Font.SourceSansBold
                bindEdit.Text = "["..string.lower(bindName).."]"
                bindEdit.TextColor3 = Color3.fromRGB(150, 150, 150)
                bindEdit.TextSize = 13.000

                bindEdit.MouseEnter:Connect(function()
                    if (value) then return end
                    tween = TweenService:Create(bindEdit, TweenInfo.new(0.25, Enum.EasingStyle.Linear), {TextColor3 = Color3.fromRGB(124, 193, 21)}); tween:Play()
                end)
        
                bindEdit.MouseLeave:Connect(function()
                    if (value) then return end
                    tween = TweenService:Create(bindEdit, TweenInfo.new(0.25, Enum.EasingStyle.Linear), {TextColor3 = Color3.fromRGB(150, 150, 150)}); tween:Play()
                end)

                bindEdit.MouseButton1Click:Connect(function()
                    bindEdit.Text = "[...]"
                    local v1, v2 = game:GetService('UserInputService').InputBegan:Wait();
                    if (v1.KeyCode.Name ~= "Unknown") then
                        bindEdit.Text = "["..string.lower(v1.KeyCode.Name).."]"
                        bindName = v1.KeyCode.Name; editedRecently =  true
                        if (bindName == Enum.KeyCode.Escape.Name) then 
                            bindEdit.Text = "[-]"; bindName = "[-]"; editedRecently = false
                        end
                    end
                end)

                local debounce = false
                game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessedEvent) 
                    if (not gameProcessedEvent) then 
                        if (input.KeyCode.Name == bindName) then 
                            if (editedRecently) then editedRecently = false return end
                            if (not debounce) then
                                debounce = true
                                value = not value
                                callback(value)
                                tween = TweenService:Create(bindEdit, TweenInfo.new(0.25, Enum.EasingStyle.Linear), {TextColor3 = value and Color3.fromRGB(124, 193, 21) or Color3.fromRGB(150, 150, 150)}); tween:Play()
                                debounce = false
                            end
                        end
                    end
                end)

                local props = {}
                function props:SetText(nText)
                    nText = nText or text
                    bindLabel.Text = text
                end
                function props:SetKey(nKey)
                    nKey = nKey or key
                    bindEdit.Text = "["..string.lower(nKey.Name).."]"
                    bindName = nKey.Name;
                    if (bindName == Enum.KeyCode.Escape.Name) then 
                        bindEdit.Text = "[-]"; bindName = "[-]"; editedRecently = false
                    end
                end
                function props:Update(nText, nKey)
                    nText = nText or text; nKey = nKey or key

                    bindLabel.Text = text
                    bindEdit.Text = "["..string.lower(nKey.Name).."]"
                    bindName = nKey.Name;
                    if (bindName == Enum.KeyCode.Escape.Name) then 
                        bindEdit.Text = "[-]"; bindName = "[-]"; editedRecently = false
                    end
                end
                return props
            end

            function itemsCreate:Dropdown(text, index, table, callback)
                text = text or "dropdown"; index = index or 1; table = table or {"nil"}; callback = callback or function() end
                local canUse, selected = false, 1

                local dropdownFrame = Instance.new("Frame")
                dropdownFrame.Name = "dropdownFrame"
                dropdownFrame.Parent = groupboxItems
                dropdownFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                dropdownFrame.BackgroundTransparency = 1.000
                dropdownFrame.Size = UDim2.new(0, 244, 0, 38)
            
                local dropdownLabel = Instance.new("TextLabel")
                dropdownLabel.Name = "label"
                dropdownLabel.Parent = dropdownFrame
                dropdownLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                dropdownLabel.BackgroundTransparency = 1.000
                dropdownLabel.BorderSizePixel = 0
                dropdownLabel.Position = UDim2.new(0, 27, 0, 0)
                dropdownLabel.Size = UDim2.new(0, 216, 0, 15)
                dropdownLabel.Font = Enum.Font.SourceSans
                dropdownLabel.Text = text
                dropdownLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
                dropdownLabel.TextSize = 14.000
                dropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
            
                local dropdownActivate = Instance.new("TextButton")
                dropdownActivate.Name = "activate"
                dropdownActivate.Parent = dropdownFrame
                dropdownActivate.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                dropdownActivate.BorderColor3 = Color3.fromRGB(0, 0, 0)
                dropdownActivate.Position = UDim2.new(0, 27, 0, 17)
                dropdownActivate.Size = UDim2.new(0, 184, 0, 20)
                dropdownActivate.AutoButtonColor = false
                dropdownActivate.Font = Enum.Font.SourceSans
                dropdownActivate.Text = table[index]
                dropdownActivate.TextColor3 = Color3.fromRGB(150, 150, 150)
                dropdownActivate.TextSize = 15.000
                dropdownActivate.TextXAlignment = Enum.TextXAlignment.Left
            
                local dropdownActivatePadding = Instance.new("UIPadding")
                dropdownActivatePadding.Parent = dropdownActivate
                dropdownActivatePadding.PaddingLeft = UDim.new(0, 5)
            
                local dropdownSections = Instance.new("Frame")
                dropdownSections.Name = "dropdownSections"
                dropdownSections.Parent = dropdownActivate
                dropdownSections.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                dropdownSections.BorderColor3 = Color3.fromRGB(0, 0, 0)
                dropdownSections.Position = UDim2.new(0, -5, 1, 5)
                dropdownSections.Size = UDim2.new(1, 5, 0, 20)
                dropdownSections.Visible = false

                local dropdownSectionsLayout = Instance.new("UIListLayout")
                dropdownSectionsLayout.Parent = dropdownSections
                dropdownSectionsLayout.SortOrder = Enum.SortOrder.LayoutOrder

                if (#table ~= 0) then 
                    for i=1, #table do
                        local dropdownSectionButton = Instance.new("TextButton")
                        dropdownSectionButton.Name = "dropdownSectionLabel"
                        dropdownSectionButton.Parent = dropdownSections
                        dropdownSectionButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                        dropdownSectionButton.BorderSizePixel = 0
                        dropdownSectionButton.Size = UDim2.new(1, 0, 0, 20)
                        dropdownSectionButton.AutoButtonColor = false
                        dropdownSectionButton.Font = Enum.Font.SourceSans
                        dropdownSectionButton.Text = table[i]
                        dropdownSectionButton.TextColor3 = Color3.fromRGB(150, 150, 150)
                        dropdownSectionButton.TextSize = 15.000
                        dropdownSectionButton.TextXAlignment = Enum.TextXAlignment.Left
                    
                        local dropdownSectionLabelPadding = Instance.new("UIPadding")
                        dropdownSectionLabelPadding.Parent = dropdownSectionButton
                        dropdownSectionLabelPadding.PaddingLeft = UDim.new(0, 5)

                        dropdownSectionButton.MouseEnter:Connect(function()
                            tween = TweenService:Create(dropdownSectionButton, TweenInfo.new(0.25, Enum.EasingStyle.Linear), {TextColor3 = Color3.fromRGB(124, 193, 21)}); tween:Play()
                        end)
                
                        dropdownSectionButton.MouseLeave:Connect(function()
                            tween = TweenService:Create(dropdownSectionButton, TweenInfo.new(0.25, Enum.EasingStyle.Linear), {TextColor3 = Color3.fromRGB(150, 150, 150)}); tween:Play()
                        end)

                        dropdownSectionButton.MouseButton1Click:Connect(function()
                            if (not canUse) then return end
                            selected = i
                            dropdownActivate.Text = table[selected]
                            dropdownSections.Visible = false
                            canUse = false
                            callback(selected, table[selected])
                        end)
                    end
                end

                dropdownActivate.MouseButton1Click:Connect(function()
                    if (#table == 0) then return end
                    dropdownSections.Visible = not dropdownSections.Visible
                    dropdownSections.Size = UDim2.new(1, 5, 0, (20*#table))
                    canUse = not canUse
                end)
            end

            return itemsCreate
        end
            
        return groupboxCreate
    end

    return sectionsCreate
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
	return (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - Fastcall(v)).Magnitude
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
