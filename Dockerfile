# Dockerfile para Sanity Studio (build + runtime) usando Node 20.x
# Ajustado para evitar problemas com Nixpacks e engines incompatíveis.

# ---------- Build stage ----------
FROM node:20 AS build

# evitar prompts interativos e definir diretório
WORKDIR /app
ENV NODE_ENV=production
ENV PATH=/app/node_modules/.bin:$PATH

# copiar apenas package-lock / package.json primeiro para aproveitar cache
COPY package*.json ./

# usar npm ci para reprodutibilidade; legacy-peer-deps preservado por compatibilidade
RUN corepack enable && npm ci --legacy-peer-deps --prefer-offline

# copiar resto do projeto
COPY . .

# rodar build (garante que seu "npm run build" está definido para rodar `sanity build`)
RUN npm run build

# ---------- Runtime stage ----------
FROM node:20 AS runtime

WORKDIR /app

# instalar um servidor estático mínimo
RUN npm install -g serve

# copiar artefatos de build — Sanity normalmente gera .sanity/dist
# ajuste se seu build gerar outro diretório
COPY --from=build /app/.sanity/dist /app/.sanity/dist

EXPOSE 3000

# comando padrão para servir o build
CMD ["serve", "-s", ".sanity/dist", "-l", "3000"]
