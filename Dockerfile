# Stage 1
# Using the node 18 base image
# Platform flag for system architecture, using is specifically for Mac M1 Chip, not required on Intel based processors
FROM --platform=linux/amd64 node:18-alpine as build-stage

# Setting the base directory for application to load
WORKDIR /app

# Copying dependecies files to install dependecies
COPY package.json package-lock.json ./

# Installing dependecies
RUN npm install

# Copying the rest of the source code
COPY . .

# Creating the build
RUN npm run build


# Stage 2
# Using nginx base image for serving the angular application static resources
FROM --platform=linux/amd64 nginx:stable

# Copying nginx config file
COPY nginx.conf /etc/nginx/nginx.conf

# Copying the angular build from Stage 1
COPY --from=build-stage /app/dist/angular-app/ /usr/share/nginx/html