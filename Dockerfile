# --- Builder (compila o Sanity Studio) ---
FROM node:20 AS builder
WORKDIR /app

# Host(s) permitidos para Vite preview (separe por vírgula)
ARG PREVIEW_ALLOWED_HOSTS="sanity.sokulskilabs.com,localhost,127.0.0.1"
ENV PREVIEW_ALLOWED_HOSTS=${PREVIEW_ALLOWED_HOSTS}

# Copia apenas package*.json para usar cache de camada para npm install
COPY package.json package-lock.json* ./

# Instala dependências (legacy-peer-deps se necessário)
RUN if [ -f package-lock.json ]; then \
      npm ci --legacy-peer-deps ; \
    else \
      npm install --legacy-peer-deps ; \
    fi

# Copia todo o projeto
COPY . .

# Garante que não exista build antigo
RUN rm -rf .sanity/dist || true

# Sobrescreve vite.config.js para forçar allowedHosts a partir do ARG/ENV
# (gera um vite.config.js simples e seguro que importa sanity/vite)
RUN node -e "\
  const fs = require('fs'); \
  const hosts = (process.env.PREVIEW_ALLOWED_HOSTS||'localhost,127.0.0.1').split(',').map(s=>s.trim()); \
  const content = `import { defineConfig } from 'vite';\nimport sanityVite from 'sanity/vite';\nexport default defineConfig({ plugins: [sanityVite()], preview: { allowedHosts: ${JSON.stringify(hosts)} } });\n`; \
  fs.writeFileSync('vite.config.js', content); \
  console.log('Written vite.config.js with hosts:', hosts.join(','));"

# Build do Sanity Studio (gera .sanity/dist)
RUN npm run build

# --- Production image (serve estático com nginx) ---
FROM nginx:alpine AS runner

# Remove conteúdo default nginx e copia o build
RUN rm -rf /usr/share/nginx/html/*
COPY --from=builder /app/.sanity/dist /usr/share/nginx/html

# (opcional) ajuste headers CORS ou config custom do nginx:
# COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

# Execução padrão
CMD ["nginx", "-g", "daemon off;"]
