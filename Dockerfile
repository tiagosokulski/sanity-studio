# Stage 0: base
FROM node:20-alpine AS base
WORKDIR /app

# Copia package.json e package-lock.json primeiro para aproveitar cache do npm
COPY package*.json ./

# Instala dependências com cache
RUN npm ci --legacy-peer-deps

# Stage 1: build
FROM base AS build
WORKDIR /app

# Copia tudo
COPY . .

# Build do Sanity Studio
RUN ./node_modules/.bin/sanity build

# Stage 2: produção
FROM node:20-alpine AS production
WORKDIR /app

# Copia apenas arquivos necessários da build
COPY --from=build /app/dist ./dist
COPY --from=build /app/node_modules ./node_modules
COPY --from=build /app/package*.json ./

# Expose porta
EXPOSE 3333

# Comando para rodar o Sanity Studio em produção
CMD ["./node_modules/.bin/sanity", "start", "--host", "0.0.0.0", "--port", "3333"]
