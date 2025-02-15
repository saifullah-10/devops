#use  an official Nodejs image as the base image
FROM node:18 AS build

#set the working directory in the container
WORKDIR /devops

#copy package.json and package-lock.json to install dependencies
COPY package.json package-lock.json ./

#Install dependencies
RUN npm install 

#copy the entire project to the container
COPY . .

# Build the React app and show logs
RUN npm run build && ls -l /devops/dist

 #use an official Nginx image to serve the app
 FROM nginx:alpine

 # Copy the build output from the previous stage to the Nginx server's default directory
COPY --from=build /devops/dist /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start the Nginx server
CMD ["nginx", "-g", "daemon off;"]