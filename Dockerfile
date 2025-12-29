FROM node:24-alpine
WORKDIR /app
RUN npm install hexo-cli -g 
RUN hexo init blog 
WORKDIR /app/blog
RUN npm install

CMD ["hexo", "server", "-i", "0.0.0.0", "-p", "4000"]
EXPOSE 4000