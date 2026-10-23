# Build estatico reproduzivel do frontend BulkWhatsAppCall.
FROM node:22-alpine AS build
WORKDIR /app
# Dependencias transitivas podem vir de repositorios git.
RUN apk add --no-cache git
COPY package.json package-lock.json ./
RUN npm ci --legacy-peer-deps --no-audit --no-fund
COPY . .
RUN npm run build

FROM nginx:1.28-alpine
COPY --from=build /app/build /usr/share/nginx/html
EXPOSE 80
HEALTHCHECK --interval=30s --timeout=5s --start-period=15s --retries=3 \
  CMD wget -q -O /dev/null http://127.0.0.1/ || exit 1
CMD ["nginx", "-g", "daemon off;"]
