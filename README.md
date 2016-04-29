# Stock Market Viz

## Description
The purpose of this visualization is to compare the closing price of different stocks over the past two years. This visualization contains three subviews views.

#### View 1
View 1 is the overview view. View 1 shows all the stocks in one window, and highlights a stock's trend line when selected. This view is also where the user is able to select a time frame for View 3 by dragging from one point in time to another.

#### View 2
View 2 is the selected view. This means that it only shows the stocks that have been selected at the bottom by the user. This allows the user to see the stocks at a scale that is more appropriate to their maximum and minimum closing price.

#### View 3
View 3 is the selected stock detailed time view. It shows the selected stocks at the time interval that is selected in View 1. This allows the user to get a more detailed view of the data for a selected period of time.

## Data
The data for this project came from [Yahoo Finance](http://finance.yahoo.com/) and thankfully it came in CSV format, so there was no need for preproccessing.

## Note
If you are a Mac OSX user and the program immediately shows an error window, you need to remove the `.DS_Store` file from the `csv/` directory.
