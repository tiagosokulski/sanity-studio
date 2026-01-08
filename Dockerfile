# Dockerfile otimizado para Sanity Studio (resolve erro de Node < 20)
# Multi-stage: build com Node 20, runtime leve também com Node (serve)
# Ajuste o caminho de saída se seu build gerar para outro diretório (ex: ./dist)

### STAGE 1: Build (Node >= 20)
FROM node:20-bullseye AS builder

# evita prompts interativos e usa o cache do npm onde possível
ENV CI=true
WORKDIR /app

# copie apenas package.json + package-lock para acelerar cache de dependências
COPY package*.json ./

# instalar todas as dependências necessárias para build (inclui devDeps)
RUN npm install --legacy-peer-deps

# copie o resto do código
COPY . .

# roda o build do Sanity (mesmo comando que você usa localmente)
RUN npm run build

### STAGE 2: Runtime (serve os arquivos estáticos)
FROM node:20-bullseye AS runner

WORKDIR /app

# instala um servidor estático leve
RUN npm install -g serve

# copie apenas o output do build
# OBS: nos logs anteriores o site foi servido a partir de ".sanity/dist".
# Se seu build gerar em outro local, ajuste este caminho (ex: /app/dist)
COPY --from=builder /app/.sanity/dist /app/.sanity/dist

# porta usada pelo seu serviço no Easypanel (conforme logs: 3000)
EXPOSE 3000

# comando padrão para iniciar (serve em modo single-page app)
CMD ["serve", "-s", ".sanity/dist", "-l", "3000"]
