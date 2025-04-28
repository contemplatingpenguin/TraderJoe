clear all; clc;
format long;

%% Staring Variables
capital = 10000; % Starting capital
upRisk = 0.01; % Upper limit for triggering Paroli
downRisk = 0.1; % Stop loss limit
paroliLotSize = 10; % How many lots for each paroli cycle
entryLotSize = 50; % How many lots for starting entry
maxParoliWins = 3; % As per your Paroli variables

%% Data loading
% yfinance for scraping data and saving it as .csv
data = readtable('AAPL_historical_data.csv');
disp(class(data.Price));
figure(1) % Plotting ticker data over time
plot(data.Price,data.Close)
title('Stock Price Over Time ($AAPL)')
xlabel('Date')
ylabel('Closing Price ($)')
grid on;

%% Paroli Algorithm

% Initialization
inTrade = false; % Flag to check if we are currently in a position
positionSize = NaN; % Total oustanding position size
capitalList = []; % Collect capital over time series data
positionSizeList = []; % Collect total oustanding position size over time series data
sellDate = []; % Record dates of selling
sellPrice = []; % Record prices of selling
entryDate = []; % Record dates of entry
entryPrice = []; % Record prices of entry
paroliDate = []; % Record paroli dates
paroliPrice = []; % Record paroli prices
totalAssetsList = []; % Collects asset over time series data
lotSize = 0;


% Example trade entry strategy, eg. Using 20-40 SMA crossover
SMA_20 = movmean(data.Close(2:end),[20 0]);
SMA_40 = movmean(data.Close(2:end),[40 0]);
hold on
plot(data.Price(2:end),SMA_20)
plot(data.Price(2:end),SMA_40)

% Cycle through stock data by tick
for i = 1:(length(data.Price)-1)
    capital = capital *(1.00008219178); % Capital account earns 3% interest per year
    currentPrice = data.Close(i); % Outstanding position size
    positionSize = lotSize*currentPrice;
    capitalList = [capitalList capital];
    positionSizeList = [positionSizeList positionSize]; 
    if capital < 0 % Check for balance; if negative stops the loop
        fprintf("Capital is negative!")
        break
    end
    % If not in a trade position
    if ~inTrade
        % If 20 SMA crosses 40 SMA, enters trade
        if SMA_20(i) > SMA_40(i) && SMA_20(i-1) <= SMA_40(i-1)
            fprintf('Buy Signal Detected on %s (Index %d)\n', datestr(data.Price(i), 'yyyy-mm-dd'), i); % Use datestr for clean output
            inTrade = true;           % Set flag to indicate we are now in a trade
            paroliPosition = 1;
            ceillingProfitPrice = data.Close(i)*(1+upRisk);
            stopLossPrice = data.Close(i)*(1-downRisk);
            lotSize = entryLotSize;
            capital = capital - lotSize*data.Close(i);
            entryDate = [entryDate data.Price(i)];
            entryPrice = [entryPrice data.Close(i)];
        end
    % If in a trade positon
    elseif inTrade
        % Increase betsize according to paroliLotSize
        if data.Close(i) >= ceillingProfitPrice && paroliPosition <= maxParoliWins
            paroliPosition = paroliPosition + 1;
            lotSize = lotSize + paroliLotSize;
            ceillingProfitPrice = data.Close(i)*(1+upRisk);
            stopLossPrice = data.Close(i)*(1-downRisk);
            capital = capital - paroliLotSize*data.Close(i);
            paroliDate = [paroliDate data.Price(i)];
            paroliPrice = [paroliPrice data.Close(i)];
        % Sell if hit stop loss or 40 SMA crosses 20 SMA
        elseif data.Close(i) <= stopLossPrice || (SMA_40(i) > SMA_20(i) && SMA_40(i-1) <= SMA_20(i-1))
            sellDate = [sellDate data.Price(i)];
            sellPrice = [sellPrice data.Close(i)];
            paroliPosition = 1;
            capital = capital + positionSize;
            positionSize = 0;
            lotSize = 0;
            inTrade = false;
        end
    end
    totalAssetsList = [totalAssetsList capital+lotSize*currentPrice];
end
% Ending script
paroliPosition = 1;
capital = capital + positionSize; % Summing total amount
positionSize = 0;
lotSize = 0;
inTrade = false;

% Plotting
plot(sellDate,sellPrice,'r*')
plot(entryDate,entryPrice,'b*')
plot(paroliDate,paroliPrice,'g*')
yyaxis right;
plot(data.Price(2:end),positionSizeList)
xlabel("Time")
ylabel("Position Size ($)")
title("Position Size over Time")
legend("Price","20 SMA","40 SMA","Sell point","Entry point","Paroli Point","Position Size")

figure(2)
plot(data.Price(2:end),capitalList)
xlabel("Time")
ylabel("Capital ($)")
title("Capital over Time")

figure(3)
plot(data.Price(2:end),totalAssetsList)
xlabel("Time")
ylabel("Assets ($)")
title("Assets over Time")
