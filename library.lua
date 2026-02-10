-- UI Library
local Library = {}

print("Library loading...")

-- Services
local CoreGui = game:GetService("CoreGui")
print("CoreGui loaded")

-- Main library state
local mainGui = nil
local mainFrame = nil
local sidebar = nil
local sidebarContainer = nil
local contentArea = nil
local tabs = {}
local currentTab = nil

-- Create the main window
function Library:CreateWindow(title)
	print("CreateWindow called with title:", title)

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
		print("CoreGui failed, using PlayerGui:", err)
		local Players = game:GetService("Players")
		local LocalPlayer = Players.LocalPlayer
		if LocalPlayer then
			mainGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
		else
			warn("No LocalPlayer found!")
			return self
		end
	end

	print("ScreenGui created and parented")

	-- Create MainFrame
	mainFrame = Instance.new("Frame")
	mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	mainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
	mainFrame.BorderSizePixel = 0
	mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	mainFrame.Size = UDim2.new(0, 580, 0, 460)
	mainFrame.Name = "MainFrame"
	mainFrame.Parent = mainGui

	local mainCorner = Instance.new("UICorner")
	mainCorner.CornerRadius = UDim.new(0, 20)
	mainCorner.Parent = mainFrame

	local mainStroke = Instance.new("UIStroke")
	mainStroke.Color = Color3.fromRGB(31, 31, 31)
	mainStroke.Parent = mainFrame

	print("MainFrame created")

	-- Create Sidebar
	sidebar = Instance.new("Frame")
	sidebar.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
	sidebar.BorderSizePixel = 0
	sidebar.Position = UDim2.new(0, 7, 0, 7)
	sidebar.Size = UDim2.new(0, 142, 0, 446)
	sidebar.Name = "Sidebar"
	sidebar.Parent = mainFrame

	local sidebarCorner = Instance.new("UICorner")
	sidebarCorner.CornerRadius = UDim.new(0, 20)
	sidebarCorner.Parent = sidebar

	local sidebarStroke = Instance.new("UIStroke")
	sidebarStroke.Color = Color3.fromRGB(31, 31, 31)
	sidebarStroke.Parent = sidebar

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
	sidebarTitle.Parent = sidebar

	print("Sidebar created")

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
	contentArea.Parent = mainFrame

	local contentCorner = Instance.new("UICorner")
	contentCorner.CornerRadius = UDim.new(0, 20)
	contentCorner.Parent = contentArea

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
	contentTitle.Parent = contentArea

	print("ContentArea created")
	print("Window created successfully!")

	return self
end

-- Create a tab
function Library:CreateTab(name)
	print("CreateTab called with name:", name)

	if not mainGui then
		warn("Create a window first using CreateWindow()")
		return
	end

	local Tab = {}

	-- Create tab button
	local tabButton = Instance.new("Frame")
	tabButton.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
	tabButton.BorderSizePixel = 0
	tabButton.Size = UDim2.new(0, 128, 0, 40)
	tabButton.Name = "TabButton"
	tabButton.Parent = sidebarContainer

	local tabCorner = Instance.new("UICorner")
	tabCorner.Parent = tabButton

	local tabStroke = Instance.new("UIStroke")
	tabStroke.Color = Color3.fromRGB(31, 31, 31)
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
	tabLabel.Parent = tabButton

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
		print("Tab selected:", name)
		-- Hide all tabs
		for _, tab in pairs(tabs) do
			tab.content.Visible = false
			tab.stroke.Color = Color3.fromRGB(31, 31, 31)
		end

		-- Show this tab
		tabContent.Visible = true
		tabStroke.Color = Color3.fromRGB(60, 60, 60)
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
		selectTab()
	end

	print("Tab created successfully:", name)

	return Tab
end

print("Library functions defined")

return Library
