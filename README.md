# Simple-Moving-Average Crossover Based Trading Algorithm with Paroli Implementation
### Introduction
This algorithm uses a 20-40 datapoint Simple-Moving-Average crossover mechanism with additional implementation of Paroli system for trading.

The main idea is to use the 20-40 datapoint SMA crossover as the main strategy, and then using the Paroli system to capitalize on the momentum of a bullish stock.

Paroli system can be summerized as a *betting system where you increase your bet after each successive win*, capitalizing on winning streaks. Think of it as the opposite of systems where you increase your bet after a loss (like the Martingale).
1. Start with a base bet size.
2. If you win, take your original bet plus your winnings and bet that larger amount in the next round.
3. If you lose (at any point), you go back to betting your original base bet size for the next round.
4. Often, people using Paroli set a limit (e.g., 2 or 3 consecutive wins). Once they hit that limit, they stop increasing their bet and go back to the base bet size, even if they win that round. This is to protect some of the profits made during the streak.

The 20-40 datapoint Simple-Moving-Average crossover is a commonly used technique in algorithmic trading to identify entries and exits. It generates a potential buy signal when the shorter-period 20-day SMA crosses above the longer-period 40-day SMA, suggesting increasing upward momentum. Conversely, a potential sell signal is generated when the 20-day SMA crosses below the 40-day SMA, indicating potential downward momentum.

The objective of this study was to comprehend the performance of the Paroli system when implemented in an already robust 20-40 SMA crossover technique, as well as in a wider scope to compare the algorithm against others in terms of metric performance.

In the script, the balance is split into two accounts; capital and outstanding position size. Capital is the leftover balance (cash account) and is subject to 3% interest capital gain; outstanding position size is the balance invested into stock, not subject to 3%.

This current version runs on historical data, taking $AAPL for study. Scraping live data from APIs can be expensive (hardware & software)!

### Usage
The user defined variables are detailed in the Starting Varible section.
1. capital = 10000; % Starting capital
2. upRisk = 0.01; % Upper limit for triggering Paroli
3. downRisk = 0.1; % Stop loss limit
4. paroliLotSize = 10; % How many lots for each paroli cycle
5. entryLotSize = 50; % How many lots for starting entry
6. maxParoliWins = 3; % Maximum Paroli cycles

The data loading is done at line #14, @*data = readtable('AAPL_historical_data.csv');*.

### Performance
![paroli_10](paroli_10.png)
AAPL from Jan 2020 to Jan 2024, showing 20&40 SMA, Sell, Entry, Paroli points, and oustanding position size. Paroli lot size @ 10 (10 addition lots invested per Paroli cycle).
![asset_10](asset_10.png)
Asset accumulation over time.
Balance at Jan 2024 (end): $17675.31177201533

We can compare the performance of this configuration with a system with 0 Paroli lot size (effectively disabling the Paroli system).

