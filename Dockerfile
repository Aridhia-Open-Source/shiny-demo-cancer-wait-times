# Pull base R container
FROM rocker/shiny-verse:4.0.2

# Copy app to container
COPY *.R /home/app/
COPY datafiles /home/app/datafiles
COPY map_data /home/app/map_data
COPY DESCRIPTION /home/app/
COPY www /home/app/www


# Additional dependencies for rgdal
RUN sudo apt-get update
RUN sudo apt-get install -y gdal-bin proj-bin libgdal-dev libproj-dev
RUN sudo apt-get install -y libudunits2-dev libv8-dev

# Install R packages
RUN R -e "source('/home/app/dependencies.R')"

EXPOSE 8080

COPY docker/mini-app /usr/bin/mini-app

ENTRYPOINT /usr/bin/mini-app
