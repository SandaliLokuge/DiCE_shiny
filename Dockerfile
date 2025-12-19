# =================================================
# Base image: Shiny Server + R
# =================================================
FROM rocker/shiny:4.5.2

# =================================================
# System libraries (needed for CRAN + Bioconductor)
# =================================================
RUN apt-get update && apt-get install -y --no-install-recommends \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    libgit2-dev \
    libcairo2-dev \
    libfontconfig1-dev \
    libfreetype6-dev \
    libpng-dev \
    libjpeg-dev \
    libtiff5-dev \
    && rm -rf /var/lib/apt/lists/*

# =================================================
# Install CRAN packages (app + DiCE deps)
# =================================================
RUN R -q -e "install.packages(c( \
  'shiny','shinythemes','readr','readxl','future','DT','promises', \
  'htmltools','visNetwork','openxlsx','ggplot2','dplyr', \
  'uuid','jsonlite','zip','vroom', \
  'tibble','data.table','igraph','reticulate','purrr','parallel','stats','utils' \
), repos='https://cloud.r-project.org')"

# =================================================
# Bioconductor core
# =================================================
RUN R -q -e "if (!requireNamespace('BiocManager', quietly=TRUE)) \
  install.packages('BiocManager', repos='https://cloud.r-project.org')"

# =================================================
# Bioconductor packages required by DiCE
# =================================================
RUN R -q -e "BiocManager::install(c( \
  'SingleCellExperiment', \
  'SummarizedExperiment', \
  'BiocParallel', \
  'AnnotationDbi', \
  'annotate', \
  'org.Hs.eg.db', \
  'org.Mm.eg.db' \
), ask=FALSE)"

# =================================================
# CRAN packages required by DiCE
# =================================================
RUN R -q -e "install.packages(c( \
  'FSelectorRcpp','NetWeaver','praznik','zinbwave' \
), repos='https://cloud.r-project.org')"

# =================================================
# Install DiCE from local tar.gz
# =================================================
COPY packages/DiCE_1.1.3.tar.gz /tmp/DiCE_1.1.3.tar.gz

RUN R -q -e "install.packages('/tmp/DiCE_1.1.3.tar.gz', \
  repos=NULL, type='source')"

# =================================================
# Copy Shiny app
# =================================================
WORKDIR /srv/shiny-server/dice-web
COPY . .

RUN chown -R shiny:shiny /srv/shiny-server

# =================================================
# Expose Shiny port
# =================================================
EXPOSE 3838
