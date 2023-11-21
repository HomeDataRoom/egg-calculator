scriptVersion = "0.6" -- The current version of the script
lastUpdatedDate = "11/20/2023" -- The date at which the script was last updated
print("Welcome to the Egg Calculator, version " .. scriptVersion .. " last updated " .. lastUpdatedDate .. ".")
githubLink = "https://github.com/homedataroom/egg-calculator" -- The link to the script's GitHub repository
print("If you experience issues with this script or would like to know more about it, please visit the repository at " .. githubLink .. ".")
print("\nTo ensure accurate projections, please set up your farm and ensure at least a few million eggs are being produced/shipped per minute.")

dev = 0 -- Whether developer mode is enabled or not. 0 = disabled, 1 = enabled
if dev == 1 then
    print("\nDeveloper mode is enabled.")
end

successConfidence = 0.5 -- The calculated probability of completing the contract
function addConfidence(amount) -- Adds to the confidence value
    successConfidence = successConfidence + amount
end

function makeReadable(number) -- Converts a number to a more human-readable format
    local left,num,right = string.match(number,'^([^%d]*%d)(%d*)(.-)$')
    return left..(num:reverse():gsub('(%d%d%d)','%1,'):reverse())..right
end

-- Determines whether the user is doing a solo or co-op contract
potentialContractTypes = {"1 - Solo", "2 - Co-op"}
activeContractType = nil
while activeContractType ~= 1 and activeContractType ~= 2 do
    print("\nThe available types of contracts are: ")
    for i, v in ipairs(potentialContractTypes) do
        print(v)
    end
    io.write("\nPlease select which type of contract you are currently doing:\n")
    local userInput = io.read()
    if userInput == "1" or userInput == "2" then
        activeContractType = tonumber(userInput)
        print("Contract type " .. activeContractType .. " selected.")
    else
        -- Prints an error message if anything other than 1 or 2 is typed
        print("Error: please only type '1' or '2'.")
    end
end

-- Determines the current egg shipping rate
eggsPerSecond = nil
while eggsPerSecond == nil do
    io.write("\nHow many eggs, in billions, is your farm shipping per second? (Top middle)\n")
    local userInput = io.read()
    eggsPerSecond = tonumber(userInput)
    print("Great. You are shipping " .. eggsPerSecond .. " billion eggs per second.")
    eggsPerMinute = eggsPerSecond * 60
    eggsPerHour = eggsPerMinute * 60
    eggsPerDay = eggsPerHour * 24
end

-- Determines the contract goal
contractGoal = nil
while contractGoal == nil do
    io.write("\nWhat is the goal, in quadrillions, of the contract? (Farm > Goals)\n")
    local userInput = io.read()
    if tonumber(userInput) >= 0.0001 then
        contractGoal = userInput
        print("Great. The contract goal is " .. contractGoal .. " quadrillion eggs.")
    else
        -- Prints an error message if a number less than 0.0001 is typed
        print("Error: the contract goal must be at least 0.0001 quadrillion (100 billion).")
    end
end

-- Determines how much time is left to complete the contract
daysRemaining = nil
while daysRemaining == nil do
    io.write("\nHow many days are left to complete the contract? (Farm)\n")
    local userInput = io.read()
    daysRemaining = tonumber(userInput)
    hoursRemaining = daysRemaining * 24
    print("Great. There are " .. daysRemaining .. " days left to complete the contract.")
end

-- If applicable, determines the shipping rate of the co-op
coopEggsPerHour = nil
if activeContractType == 2 then
    while coopEggsPerHour == nil do
        io.write("\nHow many eggs, in trillions, is your co-op shipping per hour? (Farm > Rate)\n")
        local userInput = io.read()
        coopEggsPerHour = tonumber(userInput)
        print("Great. Your coop is shipping " .. coopEggsPerHour .. " trillion eggs per hour.")
        coopEggsPerMinute = coopEggsPerHour / 60
        coopEggsPerSecond = coopEggsPerMinute / 60
        coopEggsPerDay = coopEggsPerHour * 24
    end
end

-- Determines how many eggs have already been delivered, and how many are remaining
eggsDelivered = nil
while eggsDelivered == nil do
    io.write ("\nHow many eggs, in quadrillions, have already been delivered? (Farm > Delivered)\n")
    local userInput = io.read()
    eggsRemaining = contractGoal - tonumber(userInput)
    eggsRemainingPerHour = eggsRemaining / hoursRemaining
    trillionEggsRemainingPerHour = math.ceil(eggsRemainingPerHour * 1000)
    trillionEggsPerHour = eggsPerHour / 1000
    if activeContractType == 2 then
        coopDifference = coopEggsPerHour - trillionEggsPerHour
    else
        coopDifference = 0
    end
    if coopDifference >= 0 or activeContractType ~= 2 then
        eggsDelivered = tonumber(userInput)
        print("Great. " .. eggsDelivered .. " quadrillion eggs have already been delivered.")
        print("That means you only have " .. eggsRemaining .. " to go!")
    else
        print("Error: Your co-op difference cannot be negative. Please check your input and try again, or restart the script.")
    end
end

chickens = nil -- The number of chickens on the user's farm
while chickens == nil do
    print("\nHow many chickens are currently on your farm? (Top left)")
    io.write("This doesn't have to be an exact number; it can be a rough estimate, but should be at least 1,000.\n")
    local userInput = io.read()
    if tonumber(userInput) >= 1000 then
        chickens = userInput
        print("Great. You have " .. makeReadable(chickens) .. " chickens on your farm.")
        millionChickens = chickens / 1000000
    else
        -- Prints an error message if a number less than 1,000 is typed
        print("Error: you need to have at least 1,000 chickens producing eggs. Hatch more chickens before continuing.")
    end
end

-- Determines the current internal hatchery rate, per habitat, per minute
internalHatchery = nil
while internalHatchery == nil do
    io.write("\nWhat is your current internal hatchery rate? (Main Menu > Stats > Int. Hatchery Rate)\n")
    local userInput = io.read()
    if tonumber(userInput) >= 1 then
        internalHatchery = userInput
        print("Great. Each habitat is gaining " .. internalHatchery .. " chickens every minute.")
    else
        -- Prints an error message if there are no internal hatchery upgrades
        print("Error: you need to have at least 1 internal hatchery rate. Upgrade your internal hatcheries before continuing.")
    end
end

-- Outputs results
print("\nBased on the information you provided, you have " .. daysRemaining .. " days to deliver " .. eggsRemaining .. " quadrillion more eggs.")

if activeContractType == 2 then
    totalPerHour = trillionEggsPerHour + coopEggsPerHour 
else
    totalPerHour = trillionEggsPerHour
end

if activeContractType == 2 then
    print("That means your co-op needs to deliver " .. trillionEggsRemainingPerHour .. " trillion eggs per hour for the remainder of the contract.")
else
    print("That means you need to deliver " .. trillionEggsRemainingPerHour .. " trillion eggs per hour for the remainder of the contract.")
end

if totalPerHour >= trillionEggsRemainingPerHour then
    addConfidence(0.5)
    deficit = 0
    print("\nIt looks like you are already doing that.")
else
    successConfidence = 0
    deficit = trillionEggsRemainingPerHour - totalPerHour
    print("\nYou will need to increase your shipping rate by " .. deficit .. " trillion in order to meet this requirement.")
end

eggsPerChicken = math.floor((eggsPerSecond / chickens) * 1000000000)
totalInternalHatchery = internalHatchery * 4
totalInternalHatcheryPerHour = totalInternalHatchery * 60
totalInternalHatcheryPerDay = totalInternalHatcheryPerHour * 24
chickensByEnd = math.floor((totalInternalHatcheryPerDay / daysRemaining) + chickens)
projectedRateMinute = (chickensByEnd * eggsPerChicken) / 60
print("\nEach chicken on your farm is laying " .. eggsPerChicken .. " eggs per second. By the end of the contract, your farm will have at least " .. chickensByEnd .. " chickens on it.")
projectedRateHour = projectedRateMinute * 60
trillionProjectedRateHour = projectedRateHour / 1000
print("If your egg laying rate stays consistent, your farm will be producing " .. trillionProjectedRateHour .. " trillion eggs per hour by the end of the contract.")
if trillionProjectedRateHour >= trillionEggsRemainingPerHour then
    addConfidence(0.5)
end

if successConfidence >= 0.95 then
    print("\nBased on these results, you are very likely to finish the contract goal by its deadline. Congratulations!")
else
    if successConfidence <= 0.05 then
        print("\nBased on these results, you are unlikely to finish the contract goal by its deadline. Consider purchasing additional research, using boosts, or restarting the contract.")
    else
        print("\nBased on these results, the calculator is unsure whether you will finish the contract by its deadline or not. Restart the script, or try again later when more progress has been made in the contract.")
    end
end
print("If you believe this script's output to be incorrect, please report it at " .. githubLink .. ".")

-- Optional information about the user's co-op
if activeContractType == 2 then
    print("\nSince you are in a co-op, here is some extra information you may find helpful:")
    print("\nYou are shipping " .. trillionEggsPerHour .. " trillion eggs per hour. Your co-op is shipping " .. coopEggsPerHour .. " trillion eggs per hour.")
    userProportionOfCoop = (trillionEggsPerHour / coopEggsPerHour) * 100
    roundedUserProportionOfCoop = math.ceil(userProportionOfCoop)
    print("Without you, they'd be shipping " .. coopDifference .. " trillion eggs per hour. That means you're shipping about " .. roundedUserProportionOfCoop .. "% of the eggs in the co-op.")
end

-- If developer mode is enabled, prints the names of all variables and their current values
if dev == 1 then
    print("\nDeveloper mode is enabled. Here are all variables stored by the script, and their current values:")
    print("\nscriptVersion: " .. scriptVersion .."")
    print("lastUpdatedDate: " .. lastUpdatedDate .."")
    print("githubLink: " .. githubLink .."")
    print("dev: " .. dev .."")
    print("potentialContractTypes: ")
    for i, v in ipairs(potentialContractTypes) do
        print(v)
    end
    print("activeContractType: " .. activeContractType .."")
    print("chickens: " .. chickens .."")
    print("millionChickens: " .. millionChickens .."")
    print("eggsPerSecond: " .. eggsPerSecond .."")
    print("eggsPerMinute: " .. eggsPerMinute .."")
    print("eggsPerHour: " .. eggsPerHour .."")
    print("eggsPerDay: " .. eggsPerDay .."")
    print("coopEggsPerHour: " .. coopEggsPerHour .."")
    print("coopEggsPerMinute: " .. coopEggsPerMinute .."")
    print("coopEggsPerSecond: " .. coopEggsPerSecond .."")
    print("coopEggsPerDay: " .. coopEggsPerDay .."")
    print("internalHatchery: " .. internalHatchery .."")
    print("contractGoal: " .. contractGoal .."")
    print("eggsDelivered: " .. eggsDelivered .."")
    print("eggsRemaining: " .. eggsRemaining .."")
    print("daysRemaining: " .. daysRemaining .."")
    print("hoursRemaining: " .. hoursRemaining .."")
    print("successConfidence: " .. successConfidence .."")
    print("trillionEggsPerHour: " .. trillionEggsPerHour .."")
    print("totalPerHour: " .. totalPerHour .."")
    print("eggsRemainingPerHour: " .. eggsRemainingPerHour .."")
    print("trillionEggsRemainingPerHour: " .. trillionEggsRemainingPerHour .."")
    print("deficit: " .. deficit .."")
    print("eggsPerChicken: " .. eggsPerChicken .."")
    print("totalInternalHatchery: " .. totalInternalHatchery .."")
    print("totalInternalHatcheryPerHour: " .. totalInternalHatcheryPerHour .."")
    print("totalInternalHatcheryPerDay: " .. totalInternalHatcheryPerDay .."")
    print("chickensByEnd: " .. chickensByEnd .."")
    print("projectedRateMinute: " .. projectedRateMinute .."")
    print("projectedRateHour: " .. projectedRateHour .."")
    print("trillionProjectedRateHour: " .. trillionProjectedRateHour .."")
    print("coopDifference: " .. coopDifference .."")
    print("userProportionOfCoop: " .. userProportionOfCoop .."")
    print("roundedUserProportionOfCoop: " .. roundedUserProportionOfCoop .."")
end
