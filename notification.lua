local Notification = {}

local TweenService = game:GetService("TweenService")
local function CreateInstance(cls,props)
    local inst = Instance.new(cls)
    for i,v in pairs(props) do
        inst[i] = v
    end
    return inst
end
local function OffsetToScale(Offset)
	local ViewPortSize = workspace.Camera.ViewportSize
	return ({Offset[1] / ViewPortSize.X, Offset[2] / ViewPortSize.Y})
end
local Screen = OffsetToScale({game.Workspace.CurrentCamera.ViewportSize.X, game.Workspace.CurrentCamera.ViewportSize.Y})

function Notification:Create(title, desc, tdur, dur)
    if (game.CoreGui:FindFirstChild("NotificationUI")) then game.CoreGui["NotificationUI"]:Destroy() end
    local UI = CreateInstance('ScreenGui',{DisplayOrder=0,Enabled=true,ResetOnSpawn=false,Name='NotificationUI', Parent=game.CoreGui})
    local s = CreateInstance('Frame',{Style=Enum.FrameStyle.Custom,Active=false,AnchorPoint=Vector2.new(0, 0),BackgroundColor3=Color3.new(0, 0, 0),BackgroundTransparency=0,BorderColor3=Color3.new(0.105882, 0.164706, 0.207843),BorderSizePixel=0,ClipsDescendants=false,Draggable=false,Position=UDim2.new(1, 0, 1, 0),Rotation=0,Selectable=false,Size=UDim2.new(0.2, 0, 0.2, 0),SizeConstraint=Enum.SizeConstraint.RelativeXY,Visible=true,ZIndex=1,Name = 's',Parent = UI})
    local b1 = CreateInstance('Frame',{Style=Enum.FrameStyle.Custom,Active=false,AnchorPoint=Vector2.new(0, 0),BackgroundColor3=Color3.new(0.14902, 0.133333, 0.141176),BackgroundTransparency=0,BorderColor3=Color3.new(0.105882, 0.164706, 0.207843),BorderSizePixel=0,ClipsDescendants=false,Draggable=false,Position=UDim2.new(0.002, 0, 0.004, 0),Rotation=0,Selectable=false,Size=UDim2.new(1, -2, 1, -2),SizeConstraint=Enum.SizeConstraint.RelativeXY,Visible=true,ZIndex=1,Name = 'b1',Parent = s})
    local b2 = CreateInstance('Frame',{Style=Enum.FrameStyle.Custom,Active=false,AnchorPoint=Vector2.new(0, 0),BackgroundColor3=Color3.new(0.227451, 0.227451, 0.227451),BackgroundTransparency=0,BorderColor3=Color3.new(0.105882, 0.164706, 0.207843),BorderSizePixel=0,ClipsDescendants=false,Draggable=false,Position=UDim2.new(0.01, 0, 0.02, 0),Rotation=0,Selectable=false,Size=UDim2.new(1, -8, 1, -8),SizeConstraint=Enum.SizeConstraint.RelativeXY,Visible=true,ZIndex=1,Name = 'b2',Parent = s})
    local b3 = CreateInstance('Frame',{Style=Enum.FrameStyle.Custom,Active=false,AnchorPoint=Vector2.new(0, 0),BackgroundColor3=Color3.new(0.0196078, 0.0196078, 0.0196078),BackgroundTransparency=0,BorderColor3=Color3.new(0.105882, 0.164706, 0.207843),BorderSizePixel=0,ClipsDescendants=false,Draggable=false,Position=UDim2.new(0.012, 0, 0.024, 0),Rotation=0,Selectable=false,Size=UDim2.new(1, -10, 1, -10),SizeConstraint=Enum.SizeConstraint.RelativeXY,Visible=true,ZIndex=1,Name = 'b3',Parent = s})
    local a = CreateInstance('Frame',{Style=Enum.FrameStyle.Custom,Active=false,AnchorPoint=Vector2.new(0, 0),BackgroundColor3=Color3.new(1, 1, 1),BackgroundTransparency=0,BorderColor3=Color3.new(0.105882, 0.164706, 0.207843),BorderSizePixel=0,ClipsDescendants=false,Draggable=false,Position=UDim2.new(0.015, 0, 0.03, 0),Rotation=0,Selectable=false,Size=UDim2.new(1, -12, 0, 2),SizeConstraint=Enum.SizeConstraint.RelativeXY,Visible=true,ZIndex=1,Name = 'a',Parent = s})
    local ag = CreateInstance('UIGradient',{Color=ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(55, 157, 187)), ColorSequenceKeypoint.new(0.50, Color3.fromRGB(175, 73, 160)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(184, 197, 64))},Name="ag",Parent=a})
    
    local d = CreateInstance('Frame',{Style=Enum.FrameStyle.Custom,Active=false,AnchorPoint=Vector2.new(0, 0),BackgroundColor3=Color3.new(0.184314, 0.184314, 0.184314),BackgroundTransparency=0,BorderColor3=Color3.new(0.105882, 0.164706, 0.207843),BorderSizePixel=0,ClipsDescendants=false,Draggable=false,Position=UDim2.new(0.034, 0, 0.2, 0),Rotation=0,Selectable=false,Size=UDim2.new(1, -26, 0.720000029, 0),SizeConstraint=Enum.SizeConstraint.RelativeXY,Visible=true,ZIndex=1,Name = 'd',Parent = s})
    local dt = CreateInstance('TextLabel',{Font=Enum.Font.SourceSans,FontSize=Enum.FontSize.Size18,Text=desc,TextColor3=Color3.new(0.588235, 0.588235, 0.588235),TextScaled=false,TextSize=15,TextStrokeColor3=Color3.new(0, 0, 0),TextStrokeTransparency=1,TextTransparency=0,TextWrapped=true,TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Top,Active=false,AnchorPoint=Vector2.new(0, 0),BackgroundColor3=Color3.new(0.0705882, 0.0705882, 0.0705882),BackgroundTransparency=0,BorderColor3=Color3.new(0.105882, 0.164706, 0.207843),BorderSizePixel=0,ClipsDescendants=false,Draggable=false,Position=UDim2.new(0.002, 0, 0.008, 0),Rotation=0,Selectable=false,Size=UDim2.new(1, -2, 1, -2),SizeConstraint=Enum.SizeConstraint.RelativeXY,Visible=true,ZIndex=1,Name='dt',Parent = d})
    local dtp = CreateInstance('UIPadding', {PaddingBottom=UDim.new(0, 0),PaddingLeft=UDim.new(0, 4),PaddingRight=UDim.new(0, 0),PaddingTop=UDim.new(0, 2),Name='dtp',Parent=dt})
    
    local t = CreateInstance('Frame',{Style=Enum.FrameStyle.Custom,Active=false,AnchorPoint=Vector2.new(0, 0),BackgroundColor3=Color3.new(0.184314, 0.184314, 0.184314),BackgroundTransparency=0,BorderColor3=Color3.new(0.105882, 0.164706, 0.207843),BorderSizePixel=0,ClipsDescendants=false,Draggable=false,Position=UDim2.new(0.034, 0, 0.076, 0),Rotation=0,Selectable=false,Size=UDim2.new(1, -26, 0.100000001, 0),SizeConstraint=Enum.SizeConstraint.RelativeXY,Visible=true,ZIndex=1,Name = 't',Parent = s})
    local tt = CreateInstance('TextLabel',{Font=Enum.Font.SourceSans,FontSize=Enum.FontSize.Size18,Text='label',TextColor3=Color3.new(0.588235, 0.588235, 0.588235),TextScaled=false,TextSize=15,TextStrokeColor3=Color3.new(0, 0, 0),TextStrokeTransparency=1,TextTransparency=0,TextWrapped=true,TextXAlignment=Enum.TextXAlignment.Center,TextYAlignment=Enum.TextYAlignment.Center,Active=false,AnchorPoint=Vector2.new(0, 0),BackgroundColor3=Color3.new(0.0705882, 0.0705882, 0.0705882),BackgroundTransparency=0,BorderColor3=Color3.new(0.105882, 0.164706, 0.207843),BorderSizePixel=0,ClipsDescendants=false,Draggable=false,Position=UDim2.new(0.002, 0, 0.048, 0),Rotation=0,Selectable=false,Size=UDim2.new(1, -2, 1, -2),SizeConstraint=Enum.SizeConstraint.RelativeXY,Visible=true,ZIndex=1,Name='tt',Parent = t})
    
    local sizex, sizey = s.Size.X.Scale, s.Size.Y.Scale
    local t1 = TweenService:Create(
        s, 
        TweenInfo.new(tdur / 3, Enum.EasingStyle.Linear),
        { Position = UDim2.new((Screen[1] - sizex) - 0.005, 0, (Screen[2] - sizey) - 0.005, 0) }
    )
    t1:Play(); t1.Completed:Wait(); task.wait(dur)

    local t2 = TweenService:Create(
        s, 
        TweenInfo.new(tdur / 3, Enum.EasingStyle.Linear),
        { Position = UDim2.new((sizex + Screen[1]) + 0.005, 0, (sizey + Screen[2]) + 0.005, 0) }
    )
    t2:Play(); t2.Completed:Wait();

    UI:Destroy()
end
return Notification
