# -----------------------------
# Dockerfile para Sanity Studio 3
# -----------------------------

# 1️⃣ Escolhe uma imagem oficial Node 20
FROM node:20

# 2️⃣ Define o diretório de trabalho dentro do container
WORKDIR /app

# 3️⃣ Copia apenas os arquivos de dependências para instalar antes do código (melhora cache)
COPY package*.json ./

# 4️⃣ Instala dependências
RUN npm install --legacy-peer-deps

# 5️⃣ Copia todo o restante do código
COPY . .

# 6️⃣ Build do Sanity Studio
# Isso cria a pasta .sanity/dist dentro do container
RUN npm run build

# 7️⃣ Expõe a porta padrão do Sanity Studio (ajuste se usar outra)
EXPOSE 3333

# 8️⃣ Comando default ao iniciar o container
CMD ["npm", "start"]
