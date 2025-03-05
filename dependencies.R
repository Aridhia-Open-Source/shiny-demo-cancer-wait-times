##########################
###### DEPENDENCIES ######
##########################
package_install <- function(x, ...) {
  for (i in x) {
    # Check if package is installed
    if (!require(i, character.only = TRUE)){
      # If the package could not be loaded then install it
      install.packages(i, ...)
    }
  }
}

# Source this script to install all the libraries needed for the app

packages <- c("shiny", "tidyverse", "V8", "DT", "tidyxl", "readxl", "leaflet", "sf", "rmapshaper")

Sys.unsetenv("DOWNLOAD_STATIC_LIBV8")
Sys.setenv(DISABLE_STATIC_LIBV8=1)

package_install(packages)

