# CANCER WAIT TIMES

This RShiny mini-app offers a quick visualisation of the Cancer Waiting Times of the England NHS. Within the UK, there are targets for maximum waiting times to start treatment after being diagnosed with cancer. The waiting time target to start treatment after diagnosis in England is no more than 2 months (day) between the date the hospital recieved an urgen referral for suspected cancer and the start of the treatment.

Cancer Waiting Times standards monitor the lenght of time that patients with cancer or suspected cancer wait to be seen and treated in England. All cancer waiting times are monitored thorugh the *National Cancer Waiting Times Monitoring Dataset (NCWTMDS)*, which is an information standard applicable to all cancer services providers funded by the NHS in England. The official monthly and quaterly repors can be found here:

http://www.england.nhs.uk/statistics/statistical-work-areas/cancer-waiting-times/


## About the Cancer Wait Times RShiny mini-app

The app will open in the 'Plot' tab, here:

1. Select the sheet you wish to visualise using the drop-down menu on the right-side. A table displaying the data will appear in the bottom of the screen.
2. Choose the region. A graph showing the differences of the % treated within your range between national average and regional provider will appear in the main panel; and the table will update to show the data only from the selected region.
3. If you want, you can further filter the data displayed in the plot and table by choosing a cancer type and a quarter.

The 'Map' tab displays an interactive map showing the average waiting times for each region in England. If you click on one of the regions, the average waiting time will display. Notice the map will be gray if you have not chosen a sheet, if you change the sheet, the map will automatically update. 

### Checkout and run

You can clone this repository by using the command:

```
git clone https://github.com/aridhia/demo-cancer-wait-times
```

Open the .Rproj file in RStudio and use `runApp()` to start the app.

### Deploying to the workspace

1. Create a new mini-app in the workspace called "cancer-wait-times"" and delete the folder created for it
2. Download this GitHub repo as a .ZIP file, or zip all the files
3. Upload the .ZIP file to the workspace and upzip it inside a folder called cancer-wait-times"
4. Run the app in your workspace