Attribute VB_Name = "Module1"
Sub StockTicker():

'Declare Variables
Dim Last_Row As Long
Dim Yearly_Change As Double
Dim Stock_Ticker As String
Dim Opening_Row As Long
Dim Percent_Change As Double
Dim Stock_Volume As LongLong
Dim Ticker_Summary_Row As Long
Dim Great_Perc_Inc As Double
Dim Least_Perc_Inc As Double
Dim Great_Perc_Inc_Stock_row As Long
Dim Least_Perc_Inc_Stock_row As Long
Dim Great_Stock_Vol As LongLong
Dim Great_Stock_Row As Long
Dim ws As Worksheet

'Loop through each worksheets
For Each ws In Worksheets
    
    'Initialize all variables
    Stock_Ticker = ws.Cells(2, 1).Value 'initialize with first stock name
    Opening_Row = 2 'starts on the second row
    Stock_Volume = 0
    Ticker_Summary_Row = 2 'starts on the second row
    Great_Perc_Inc = 0
    Least_Perc_Inc = 0
    Great_Stock_Vol = 0
    Great_Perc_Inc_Stock_row = 2 'starts on the second row
    Least_Perc_Inc_Stock_row = 2 'starts on the second row
    Great_Stock_Row = 2 'starts on the second row
    
    'Find number of rows
    Last_Row = ws.Cells(Rows.Count, "A").End(xlUp).Row
    
    'Display the titles
    ws.Cells(1, 9).Value = "Ticker"
    ws.Cells(1, 10).Value = "Yearly Change"
    ws.Cells(1, 11).Value = "Percentage Change"
    ws.Cells(1, 12).Value = "Total Stock Volume"

    'Loop through each row
    For i = 2 To Last_Row
           
        'Compare the stock ticker names of the current row with the next row
        If ws.Cells(i, 1).Value = ws.Cells(i + 1, 1).Value Then 'If Stock Ticker name is the same, calculate total stock volume
            
            Stock_Volume = Stock_Volume + ws.Cells(i, 7).Value
            
        Else 'Stock Ticker name has changed
            
            'add last row stock volume
             Stock_Volume = Stock_Volume + ws.Cells(i, 7).Value
             
            'Yearly change  = years closing price - opening price
            Yearly_Change = ws.Cells(i, 6).Value - ws.Cells(Opening_Row, 3).Value
            
            'The percent change from opening price at the beginning of a given year to the closing price at the end of that year
            If Yearly_Change = 0 Or ws.Cells(Opening_Row, 3).Value = 0 Then 'check for division by 0
                Percent_Change = 0
            Else
                Percent_Change = Yearly_Change / ws.Cells(Opening_Row, 3).Value
            End If
            
            'Display Stock Ticker, Yearly Change, Percentage Change and Total Stock Volume
            ws.Cells(Ticker_Summary_Row, 9).Value = Stock_Ticker
            ws.Cells(Ticker_Summary_Row, 10).Value = Yearly_Change
            ws.Cells(Ticker_Summary_Row, 11).Value = Format(Percent_Change, "Percent")
            ws.Cells(Ticker_Summary_Row, 12).Value = Stock_Volume
            
            'Highlight Yearly Change cell
            If Yearly_Change >= 0 Then
                ws.Cells(Ticker_Summary_Row, 10).Interior.ColorIndex = 4 'green if positive
            Else
                ws.Cells(Ticker_Summary_Row, 10).Interior.ColorIndex = 3 'red if negative
            End If
            
            'go to next row to display next stocks summary
            Ticker_Summary_Row = Ticker_Summary_Row + 1
            
            'check if this is the first stock
            If Stock_Ticker = ws.Cells(2, 1).Value Then
                
                'initialize values for the first Stock
                Great_Perc_Inc = Percent_Change
                Least_Perc_Inc = Percent_Change
                Great_Stock_Vol = Stock_Volume
            
            ElseIf Percent_Change > Great_Perc_Inc Then  'Find the greatest % increase
                
                Great_Perc_Inc = Percent_Change
                Great_Perc_Inc_Stock_row = i    'take note of the row number
            
            ElseIf Percent_Change < Least_Perc_Inc Then 'Find the least % decrease
                
                Least_Perc_Inc = Percent_Change
                Least_Perc_Inc_Stock_row = i    'take note of the row number
            
            End If
            
            'Find the greatest stock volume
            If Stock_Volume > Great_Stock_Vol Then
                Great_Stock_Vol = Stock_Volume
                Great_Stock_Row = i 'take note of the row number
            End If
            
            'Assign name of stock in next row to Stock_Ticker; this is the new stock
            Stock_Ticker = ws.Cells(i + 1, 1).Value
            
            'Reset Stock_Volume to 0
            Stock_Volume = 0
            
            'Set Opening_Row to current row+1 to start with the new Stock ticker name
            Opening_Row = i + 1
        
        End If
    
    Next i

    'Display the Greatest % increase, least % decrease and greatest total volume
    ws.Cells(1, 16).Value = "Ticker"
    ws.Cells(1, 17).Value = "Value"
    ws.Cells(2, 15).Value = "Greatest % Increase"
    ws.Cells(2, 16).Value = ws.Cells(Great_Perc_Inc_Stock_row, 1)
    ws.Cells(2, 17).Value = Format(Great_Perc_Inc, "Percent")
    ws.Cells(3, 15).Value = "Least % decrease"
    ws.Cells(3, 16).Value = ws.Cells(Least_Perc_Inc_Stock_row, 1)
    ws.Cells(3, 17).Value = Format(Least_Perc_Inc, "Percent")
    ws.Cells(4, 15).Value = "Greatest Total volume"
    ws.Cells(4, 16).Value = ws.Cells(Great_Stock_Row, 1)
    ws.Cells(4, 17).Value = Great_Stock_Vol

Next ws

End Sub

