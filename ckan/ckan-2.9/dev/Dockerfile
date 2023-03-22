FROM alpine:3.13

# Internals, you probably don't need to change these
ENV APP_DIR=/srv/app
ENV SRC_EXTENSIONS_DIR=/srv/app/src_extensions
ENV TZ=UTC
RUN echo ${TZ} > /etc/timezone

# Install packages needed by the dev requirements
RUN apk add --no-cache libffi-dev \
      # Set up PROJ
        geos-dev \ 
        proj \
        proj-util

# Install CKAN dev requirements
RUN pip3 install -r https://raw.githubusercontent.com/ckan/ckan/${GIT_BRANCH}/dev-requirements.txt

# Create folder for local extensions sources
RUN mkdir ${SRC_EXTENSIONS_DIR}

COPY setup/start_ckan_development.sh ${APP_DIR}

RUN chown ckan -R /srv/app

CMD ["/srv/app/start_ckan_development.sh"]

# Make sure both files are not exactly the same
RUN if ! [ /usr/share/zoneinfo/${TZ} -ef /etc/localtime ]; then \
    cp /usr/share/zoneinfo/${TZ} /etc/localtime ;\
    fi ;

# Install any extensions needed by your CKAN instance
# - Make sure to add the plugins to CKAN__PLUGINS in the .env file
# - Also make sure all extra configuration options are added to the CKAN config file (ckan.ini)
#   This can be done by creating an overriding start_ckan_dev_development.sh file:
#   (https://github.com/ckan/ckan-docker-base/blob/main/ckan-2.9/dev/setup/start_ckan_development.sh) ie: updating the 'ckan config-tool' lines
#   For more on config-tool please see https://docs.ckan.org/en/latest/maintaining/cli.html#config-tool-tool-for-editing-options-in-a-ckan-config-file
#   or using Crudini (https://github.com/pixelb/crudini) 
#
# For instance:
#
### XLoader ###
#RUN pip3 install -e 'git+https://github.com/ckan/ckanext-xloader.git@master#egg=ckanext-xloader' && \ 
#    pip3 install -r ${APP_DIR}/src/ckanext-xloader/requirements.txt && \
#    pip3 install -U requests[security]


###TODO: XLoader ###
RUN pip3 install -e 'git+https://github.com/ckan/ckanext-xloader.git@master#egg=ckanext-xloader' && \ 
    pip3 install -r ${APP_DIR}/src/ckanext-xloader/requirements.txt && \
    pip3 install -U requests[security]

### Harvester ###
RUN echo "ckan/ckanext-harvester" && \
    pip3 install -e 'git+https://github.com/ckan/ckanext-harvest.git@master#egg=ckanext-harvest' && \
    pip3 install -r ${APP_DIR}/src/ckanext-harvest/pip-requirements.txt
# will also require gather_consumer and fetch_consumer processes running (please see https://github.com/ckan/ckanext-harvest)

### Resource dictionary-Fix version ###
RUN echo "mjanez/ckanext-resourcedictionary" && \
    pip3 install -e git+https://github.com/mjanez/ckanext-resourcedictionary.git#egg=ckanext-resourcedictionary && \
    pip3 install -r ${APP_DIR}/src/ckanext-resourcedictionary/requirements.txt

### Geoview ###
RUN echo "ckan/ckanext-geoview" && \
    pip3 install -e git+https://github.com/ckan/ckanext-geoview.git#egg=ckanext-geoview 

### Spatial ###
RUN echo "ckan/ckanext-spatial" && \
    pip3 install -e git+https://github.com/ckan/ckanext-spatial.git#egg=ckanext-spatial && \
    pip3 install -r https://raw.githubusercontent.com/ckan/ckanext-spatial/bae9290395b252ee8e40056256fa694569d1d78b/requirements.txt

### Scheming-GeoDCAT-AP extended version ###
RUN echo "mjanez/ckanext-scheming (GeoDCAT-AP extended version)" && \
    pip3 install -e git+https://github.com/mjanez/ckanext-scheming.git#egg=ckanext-scheming 

### Pages ###
RUN echo "ckan/ckanext-pages" && \
    pip3 install -e git+https://github.com/ckan/ckanext-pages.git#egg=ckanext-pages

### PDFView ###
RUN echo "ckan/ckanext-pdfview" && \
    pip3 install -e git+https://github.com/ckan/ckanext-pdfview.git#egg=ckanext-pdfview

### DCAT-GeoDCAT-AP extended version ###
RUN echo "mjanez/ckanext-dcat (GeoDCAT-AP extended version)" && \
    pip3 install -e git+https://github.com/mjanez/ckanext-dcat.git#egg=ckanext-dcat && \
    pip3 install -r https://raw.githubusercontent.com/mjanez/ckanext-dcat/master/requirements.txt

# Clone the extension(s) your are writing for your own project in the `src` folder
# to get them mounted in this image at runtime

# Used to configure the container environment by setting environment variables, creating users, running initialization scripts, .etc
COPY docker-entrypoint.d/* /docker-entrypoint.d/

# Apply any patches needed to CKAN core or any of the built extensions (not the
# runtime mounted ones)
COPY patches ${APP_DIR}/patches

RUN for d in $APP_DIR/patches/*; do \
    if [ -d $d ]; then \
    for f in `ls $d/*.patch | sort -g`; do \
    cd $SRC_DIR/`basename "$d"` && echo "$0: Applying patch $f to $SRC_DIR/`basename $d`"; patch -p1 < "$f" ; \
    done ; \
    fi ; \
    done