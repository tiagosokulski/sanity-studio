# Dockerfile para build e deploy do Sanity Studio com Node 20
FROM node:20-bullseye AS builder
WORKDIR /app

# Copia package.json e package-lock para usar cache de layer
COPY package.json package-lock.json ./

# Instala dependências (legacy-peer-deps por compatibilidade do template)
RUN npm ci --legacy-peer-deps

# Copia o resto do projeto e roda o build
COPY . .
RUN npm run build

# Stage final: imagem leve que serve os arquivos estáticos
FROM node:20-bullseye AS runner
WORKDIR /app

# Instala serve para servir a pasta de build
RUN npm install -g serve

# Copia apenas os arquivos de build da etapa anterior
COPY --from=builder /app/.sanity/dist /app/.sanity/dist

# Porta que o Easypanel (ou seu container) usará
EXPOSE 3000

# Comando de execução
CMD ["serve","-s",".sanity/dist","-l","3000"]
