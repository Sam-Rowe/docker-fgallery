FROM ubuntu:bionic AS Builder

EXPOSE 80

# Force package install to be silent
ENV DEBIAN_FRONTEND=noninteractive
RUN apt -y update
RUN apt -y install fgallery facedetect

# Copy the images to the gallery folder
COPY ./gallery/ /fgallery/gallery/
WORKDIR /fgallery/

# Press the static site out to dist folder
RUN fgallery gallery dist

# Production now on nginx
FROM nginx:latest AS production
# Copy from the builder the pressed static site to the default html folder for the nginx iamge
COPY --from=Builder /fgallery/dist /usr/share/nginx/html
