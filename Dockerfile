# Usando Node 20 LTS, que é compatível com Sanity
FROM node:20-bullseye

# Diretório de trabalho dentro do container
WORKDIR /app

# Copiando package.json e package-lock.json primeiro para cache do npm
COPY package*.json ./

# Instalando dependências
RUN npm install --legacy-peer-deps

# Copiando o restante do projeto
COPY . .

# Definindo a porta que o container vai expor
EXPOSE 3333

# Comando padrão para iniciar o Sanity Studio
CMD ["./node_modules/.bin/sanity", "start", "--host", "0.0.0.0", "--port", "3333"]
