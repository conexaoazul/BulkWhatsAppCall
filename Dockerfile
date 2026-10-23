# Dockerfile do BulkWhatsAppCall (build estatica CRA -> nginx).
# Origem deste arquivo: branch feature/dockerfile em conexaoazul/BulkWhatsAppCall (PR aberto).
FROM node:18-alpine AS build
WORKDIR /app
COPY package*.json ./
# Sem package-lock.json no repo; npm ci exige lockfile.
RUN npm install --force
COPY . .
RUN npm run build

FROM nginx:alpine
COPY --from=build /app/build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]