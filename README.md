# CANCER WAIT TIMES

This R web app offers a quick visualisation of the Cancer Waiting Times of the England NHS. Within the UK, there are targets for maximum waiting times to start treatment after being diagnosed with cancer. The waiting time target to start treatment after diagnosis in England is no more than 2 months (day) between the date the hospital recieved an urgen referral for suspected cancer and the start of the treatment.

Cancer Waiting Times standards monitor the lenght of time that patients with cancer or suspected cancer wait to be seen and treated in England. All cancer waiting times are monitored thorugh the *National Cancer Waiting Times Monitoring Dataset (NCWTMDS)*, which is an information standard applicable to all cancer services providers funded by the NHS in England. The official monthly and quaterly repors can be found here:

http://www.england.nhs.uk/statistics/statistical-work-areas/cancer-waiting-times/


## About the Cancer Wait Times R web app

The app will open in the 'Plot' tab, here:

1. Select the sheet you wish to visualise using the drop-down menu on the right-side. A table displaying the data will appear in the bottom of the screen.
2. Choose the region. A graph showing the differences of the % treated within your range between national average and regional provider will appear in the main panel; and the table will update to show the data only from the selected region.
3. If you want, you can further filter the data displayed in the plot and table by choosing a cancer type and a quarter.

The 'Map' tab displays an interactive map showing the average waiting times for each region in England. If you click on one of the regions, the average waiting time will display. Notice the map will be gray if you have not chosen a sheet, if you change the sheet, the map will automatically update. 

### Checkout and run

You can clone this repository by using the command:

```
git clone https://github.com/Aridhia-Open-Source/shiny-demo-cancer-wait-times
```

Open the .Rproj file in RStudio and use `runApp()` to start the app.

### Deploying to the workspace

1. Download this GitHub repo as a .zip file.
2. Create a new blank R web app in your workspace called "cancer-wait-times".
3. Navigate to the `cancer-wait-times` folder under "files".
4. Delete the `app.R` file from the `cancer-wait-times` folder. Make sure you keep the `.version` file!
5. Upload the .zip file to the `cancer-wait-times` folder.
6. Extract the .zip file. Make sure "Folder name" is blank and "Remove compressed file after extracting" is ticked.
7. Navigate into the unzipped folder.
8. Select all content of the unzipped folder, and move it to the `cancer-wait-times` folder (so, one level up).
9. Delete the now empty unzipped folder.
10. Start the R console and run the `dependencies.R` script to install all R packages that the app requires.
11. Run the app in your workspace.

For more information visit https://knowledgebase.aridhia.io/article/how-to-upload-your-mini-app/
