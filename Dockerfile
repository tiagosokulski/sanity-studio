# ===== Etapa 1: Build =====
FROM node:20.19-bullseye AS builder

# Diretório de trabalho
WORKDIR /app

# Copia package.json e package-lock.json
COPY package*.json ./

# Cache do npm para otimizar builds
RUN npm ci --legacy-peer-deps

# Copia todo o código do Studio
COPY . .

# Cria vite.config.js com allowedHosts já configurado
RUN echo "import { defineConfig } from 'vite'; \
import sanityVite from 'sanity/vite'; \
export default defineConfig({ \
  plugins: [sanityVite()], \
  preview: { allowedHosts: ['sanity.sokulskilabs.com', 'localhost', '127.0.0.1'] } \
});" > vite.config.js

# Build do Sanity Studio
RUN npx sanity build

# ===== Etapa 2: Production =====
FROM node:20.19-bullseye-slim

WORKDIR /app

# Copia apenas os arquivos necessários do build
COPY --from=builder /app /app

# Expõe porta do Sanity Studio
EXPOSE 3333

# Comando para iniciar o Sanity Studio em produção e ouvindo 0.0.0.0
CMD ["npx", "sanity", "start", "--host", "0.0.0.0", "--port", "3333"]
