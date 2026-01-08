# === Stage 1: build ===
FROM node:20-bullseye AS builder

# Define o diretório de trabalho
WORKDIR /app

# Copia apenas o package.json e package-lock.json para instalar dependências
COPY package*.json ./

# Cache das dependências
RUN npm ci --legacy-peer-deps

# Copia todo o código
COPY . .

# Build do Sanity Studio
RUN ./node_modules/.bin/sanity build

# === Stage 2: runtime ===
FROM node:20-bullseye

WORKDIR /app

# Copia o build do stage anterior
COPY --from=builder /app /app

# Instala produção apenas (opcional)
RUN npm ci --omit=dev --legacy-peer-deps

# Expõe a porta que o Sanity vai rodar
EXPOSE 3333

# Comando padrão para rodar o Sanity Studio
CMD ["./node_modules/.bin/sanity", "start", "--host", "0.0.0.0", "--port", "3333"]
