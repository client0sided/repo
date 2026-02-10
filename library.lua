-- UI Library
local Library = {}

-- Services
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

-- Main library state
local mainGui = nil
local mainFrame = nil
local sidebar = nil
local sidebarContainer = nil
local contentArea = nil
local tabs = {}
local currentTab = nil

-- Animation settings
local WINDOW_TWEEN_INFO = TweenInfo.new(
	0.2, -- Duration
	Enum.EasingStyle.Sine,
	Enum.EasingDirection.Out,
	0, -- RepeatCount
	false, -- Reverses
	0 -- DelayTime
)

-- Custom bezier approximation using Sine Out
local function animateElement(element, targetProperties, delay)
	delay = delay or 0
	
	task.wait(delay)
	
	local tween = TweenService:Create(element, WINDOW_TWEEN_INFO, targetProperties)
	tween:Play()
	
	return tween
end

-- Create the main window
function Library:CreateWindow(title)
	-- Clean up existing GUI if it exists
	if mainGui then
		mainGui:Destroy()
	end
	
	-- Reset state
	tabs = {}
	currentTab = nil
	
	-- Create ScreenGui
	mainGui = Instance.new("ScreenGui")
	mainGui.Name = "UILibrary"
	mainGui.ResetOnSpawn = false
	
	-- Try to parent to CoreGui, fallback to PlayerGui if that fails
	local success, err = pcall(function()
		mainGui.Parent = CoreGui
	end)
	
	if not success then
		local Players = game:GetService("Players")
		local LocalPlayer = Players.LocalPlayer
		if LocalPlayer then
			mainGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
		end
	end
	
	-- Create MainFrame (start invisible)
	mainFrame = Instance.new("Frame")
	mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	mainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
	mainFrame.BorderSizePixel = 0
	mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	mainFrame.Size = UDim2.new(0, 580, 0, 460)
	mainFrame.Name = "MainFrame"
	mainFrame.BackgroundTransparency = 1 -- Start invisible
	mainFrame.Parent = mainGui
	
	local mainCorner = Instance.new("UICorner")
	mainCorner.CornerRadius = UDim.new(0, 20)
	mainCorner.Parent = mainFrame
	
	local mainStroke = Instance.new("UIStroke")
	mainStroke.Color = Color3.fromRGB(31, 31, 31)
	mainStroke.Transparency = 1 -- Start invisible
	mainStroke.Parent = mainFrame
	
	-- Animate main frame in
	animateElement(mainFrame, {BackgroundTransparency = 0})
	animateElement(mainStroke, {Transparency = 0}, 0.1)
	
	-- Create Sidebar
	sidebar = Instance.new("Frame")
	sidebar.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
	sidebar.BorderSizePixel = 0
	sidebar.Position = UDim2.new(0, 7, 0, 7)
	sidebar.Size = UDim2.new(0, 142, 0, 446)
	sidebar.Name = "Sidebar"
	sidebar.BackgroundTransparency = 1
	sidebar.Parent = mainFrame
	
	local sidebarCorner = Instance.new("UICorner")
	sidebarCorner.CornerRadius = UDim.new(0, 20)
	sidebarCorner.Parent = sidebar
	
	local sidebarStroke = Instance.new("UIStroke")
	sidebarStroke.Color = Color3.fromRGB(31, 31, 31)
	sidebarStroke.Transparency = 1
	sidebarStroke.Parent = sidebar
	
	-- Animate sidebar
	animateElement(sidebar, {BackgroundTransparency = 0}, 0.15)
	animateElement(sidebarStroke, {Transparency = 0}, 0.2)
	
	-- Sidebar title
	local sidebarTitle = Instance.new("TextLabel")
	sidebarTitle.Font = Enum.Font.GothamMedium
	sidebarTitle.Text = title or "Menu"
	sidebarTitle.TextColor3 = Color3.fromRGB(230, 230, 230)
	sidebarTitle.TextSize = 14
	sidebarTitle.TextXAlignment = Enum.TextXAlignment.Left
	sidebarTitle.BackgroundTransparency = 1
	sidebarTitle.Position = UDim2.new(0.0915492922, 0, 0.0156950671, 0)
	sidebarTitle.Size = UDim2.new(1, 0, 0.0582959652, 0)
	sidebarTitle.Name = "Title"
	sidebarTitle.TextTransparency = 1
	sidebarTitle.Parent = sidebar
	
	-- Animate title text
	animateElement(sidebarTitle, {TextTransparency = 0}, 0.25)
	
	-- Sidebar container for tabs
	sidebarContainer = Instance.new("Frame")
	sidebarContainer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	sidebarContainer.BackgroundTransparency = 1
	sidebarContainer.BorderSizePixel = 0
	sidebarContainer.Position = UDim2.new(0, 0, 0.0739910305, 0)
	sidebarContainer.Size = UDim2.new(0, 141, 0, 400)
	sidebarContainer.Parent = sidebar
	
	local sidebarLayout = Instance.new("UIListLayout")
	sidebarLayout.Padding = UDim.new(0, 7)
	sidebarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	sidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
	sidebarLayout.Parent = sidebarContainer
	
	local sidebarPadding = Instance.new("UIPadding")
	sidebarPadding.PaddingBottom = UDim.new(0, 7)
	sidebarPadding.PaddingLeft = UDim.new(0, 7)
	sidebarPadding.PaddingRight = UDim.new(0, 7)
	sidebarPadding.PaddingTop = UDim.new(0, 7)
	sidebarPadding.Parent = sidebarContainer
	
	-- Create ContentArea
	contentArea = Instance.new("Frame")
	contentArea.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
	contentArea.BorderSizePixel = 0
	contentArea.Position = UDim2.new(0, 156, 0, 7)
	contentArea.Size = UDim2.new(0, 417, 0, 446)
	contentArea.Name = "ContentArea"
	contentArea.BackgroundTransparency = 1
	contentArea.Parent = mainFrame
	
	local contentCorner = Instance.new("UICorner")
	contentCorner.CornerRadius = UDim.new(0, 20)
	contentCorner.Parent = contentArea
	
	-- Animate content area
	animateElement(contentArea, {BackgroundTransparency = 0}, 0.2)
	
	-- Content area title
	local contentTitle = Instance.new("TextLabel")
	contentTitle.Font = Enum.Font.GothamMedium
	contentTitle.Text = "Tab"
	contentTitle.TextColor3 = Color3.fromRGB(230, 230, 230)
	contentTitle.TextSize = 14
	contentTitle.TextXAlignment = Enum.TextXAlignment.Left
	contentTitle.BackgroundTransparency = 1
	contentTitle.Position = UDim2.new(0.0148106124, 0, 0.0156950671, 0)
	contentTitle.Size = UDim2.new(1, 0, 0.0582959652, 0)
	contentTitle.Name = "Title"
	contentTitle.TextTransparency = 1
	contentTitle.Parent = contentArea
	
	-- Animate content title
	animateElement(contentTitle, {TextTransparency = 0}, 0.3)
	
	return self
end

-- Create a tab
function Library:CreateTab(name)
	if not mainGui then
		warn("Create a window first using CreateWindow()")
		return
	end
	
	local Tab = {}
	local tabIndex = #tabs
	
	-- Create tab button (start invisible)
	local tabButton = Instance.new("Frame")
	tabButton.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
	tabButton.BorderSizePixel = 0
	tabButton.Size = UDim2.new(0, 128, 0, 40)
	tabButton.Name = "TabButton"
	tabButton.BackgroundTransparency = 1
	tabButton.Parent = sidebarContainer
	
	local tabCorner = Instance.new("UICorner")
	tabCorner.Parent = tabButton
	
	local tabStroke = Instance.new("UIStroke")
	tabStroke.Color = Color3.fromRGB(31, 31, 31)
	tabStroke.Transparency = 1
	tabStroke.Parent = tabButton
	
	local tabPadding = Instance.new("UIPadding")
	tabPadding.PaddingLeft = UDim.new(0, 7)
	tabPadding.PaddingRight = UDim.new(0, 7)
	tabPadding.Parent = tabButton
	
	local tabLabel = Instance.new("TextLabel")
	tabLabel.Font = Enum.Font.GothamMedium
	tabLabel.Text = name
	tabLabel.TextColor3 = Color3.fromRGB(230, 230, 230)
	tabLabel.TextSize = 14
	tabLabel.TextXAlignment = Enum.TextXAlignment.Left
	tabLabel.BackgroundTransparency = 1
	tabLabel.Size = UDim2.new(1, 0, 1, 0)
	tabLabel.Name = "TabLabel"
	tabLabel.TextTransparency = 1
	tabLabel.Parent = tabButton
	
	-- Animate tab button in with stagger
	local delay = 0.35 + (tabIndex * 0.08)
	animateElement(tabButton, {BackgroundTransparency = 0}, delay)
	animateElement(tabStroke, {Transparency = 1}, delay + 0.05) -- Start at transparency 1 (closed)
	animateElement(tabLabel, {TextTransparency = 0}, delay + 0.1)
	
	-- Create tab content container
	local tabContent = Instance.new("Frame")
	tabContent.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	tabContent.BackgroundTransparency = 1
	tabContent.BorderSizePixel = 0
	tabContent.Position = UDim2.new(-0.00124090177, 0, 0.0739910007, 0)
	tabContent.Size = UDim2.new(0, 417, 0, 412)
	tabContent.Visible = false
	tabContent.Parent = contentArea
	
	local contentPadding = Instance.new("UIPadding")
	contentPadding.PaddingBottom = UDim.new(0, 7)
	contentPadding.PaddingLeft = UDim.new(0, 7)
	contentPadding.PaddingRight = UDim.new(0, 7)
	contentPadding.PaddingTop = UDim.new(0, 7)
	contentPadding.Parent = tabContent
	
	local contentLayout = Instance.new("UIListLayout")
	contentLayout.Padding = UDim.new(0, 7)
	contentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
	contentLayout.Parent = tabContent
	
	-- Make button clickable
	local clickDetector = Instance.new("TextButton")
	clickDetector.BackgroundTransparency = 1
	clickDetector.Size = UDim2.new(1, 0, 1, 0)
	clickDetector.Text = ""
	clickDetector.Parent = tabButton
	
	-- Tab selection logic
	local function selectTab()
		-- Hide all tabs and set stroke to transparency 1 (closed)
		for _, tab in pairs(tabs) do
			tab.content.Visible = false
			animateElement(tab.stroke, {Transparency = 1}) -- Closed tab
		end
		
		-- Show this tab and set stroke to transparency 0.8 (open)
		tabContent.Visible = true
		animateElement(tabStroke, {Transparency = 0.8}) -- Open tab
		currentTab = Tab
		
		-- Update content area title
		contentArea.Title.Text = name
	end
	
	clickDetector.MouseButton1Click:Connect(selectTab)
	
	-- Store tab reference
	Tab.button = tabButton
	Tab.content = tabContent
	Tab.stroke = tabStroke
	Tab.name = name
	
	table.insert(tabs, Tab)
	
	-- Auto-select first tab
	if #tabs == 1 then
		task.wait(delay + 0.2)
		selectTab()
	end
	
	return Tab
end

return Library
