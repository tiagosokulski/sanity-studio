# --- Builder ---
FROM node:20 AS builder
WORKDIR /app

ARG PREVIEW_ALLOWED_HOSTS="sanity.sokulskilabs.com,localhost,127.0.0.1"
ENV PREVIEW_ALLOWED_HOSTS=${PREVIEW_ALLOWED_HOSTS}

# Copia package.json e package-lock.json primeiro (cache de npm)
COPY package.json package-lock.json* ./

# Instala dependências
RUN if [ -f package-lock.json ]; then npm ci --legacy-peer-deps; else npm install --legacy-peer-deps; fi

# Copia todo o código
COPY . .

# Remove build antigo
RUN rm -rf .sanity/dist || true

# Substitui vite.config.js com allowedHosts (arquivo já versionado, mas sobrescreve apenas allowedHosts)
RUN echo "import { defineConfig } from 'vite'; import sanityVite from 'sanity/vite'; export default defineConfig({ plugins: [sanityVite()], preview: { allowedHosts: ${PREVIEW_ALLOWED_HOSTS//,/','} } });" > vite.config.js

# Build do Sanity
RUN npm run build

# --- Runner (produção) ---
FROM nginx:alpine AS runner
COPY --from=builder /app/.sanity/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
