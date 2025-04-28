# Simple-Moving-Average Crossover Based Trading Algorithm with Paroli Implementation
### Introduction
This algorithm uses a 20-40 datapoint Simple-Moving-Average crossover mechanism with additional implementation of Paroli system for trading.

Paroli system can be summerized as a *betting system where you increase your bet after each successive win*, capitalizing on winning streaks. Think of it as the opposite of systems where you increase your bet after a loss (like the Martingale).
1. Start with a base bet size.
2. If you win, take your original bet plus your winnings and bet that larger amount in the next round.
3. If you lose (at any point), you go back to betting your original base bet size for the next round.
4. Often, people using Paroli set a limit (e.g., 2 or 3 consecutive wins). Once they hit that limit, they stop increasing their bet and go back to the base bet size, even if they win that round. This is to protect some of the profits made during the streak.

The 20-40 datapoint Simple-Moving-Average crossover is a commonly used technique in algorithmic trading to identify entries and exits. It generates a potential buy signal when the shorter-period 20-day SMA crosses above the longer-period 40-day SMA, suggesting increasing upward momentum. Conversely, a potential sell signal is generated when the 20-day SMA crosses below the 40-day SMA, indicating potential downward momentum.

The objective of this study was to comprehend the performance of the Paroli system when implemented in an already robust 20-40 SMA crossover technique, as well as in a wider scope to compare the algorithm against others in terms of metric performance.

This current version runs on historical data, taking $APPL for study. Scraping live data from APIs can be expensive (hardware & software)!

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
