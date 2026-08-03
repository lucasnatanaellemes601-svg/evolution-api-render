# 1. Base Node.js liviana
FROM node:20-alpine

# 2. Instalamos git y OpenSSL
RUN apk add --no-cache git openssl

# 3. Clonamos el repositorio oficial
RUN git clone https://github.com/EvolutionAPI/evolution-api.git /app

# 4. Nos movemos a la carpeta del proyecto
WORKDIR /app

# 5. VITAL: Filtramos y nos paramos en la última versión ESTABLE (sin betas ni RCs)
RUN git fetch --tags && \
    STABLE_TAG=$(git tag -l --sort=-v:refname "v*" | grep -v "-rc" | grep -v "-beta" | head -n 1) && \
    echo ">>> Cambiando a la versión estable: $STABLE_TAG" && \
    git checkout $STABLE_TAG

# 6. Instalamos dependencias
RUN npm install

# 7. Buscador automático de Schema y generación de Prisma
RUN SCHEMA_PATH=$(find /app -name "*.prisma" -print -quit) && \
    echo ">>> Archivo schema encontrado en: $SCHEMA_PATH" && \
    npx prisma generate --schema="$SCHEMA_PATH"

# 8. Construimos la aplicación
RUN npm run build

# 9. Exponemos el puerto oficial
EXPOSE 8080

# 10. Comando de arranque
CMD ["npm", "run", "start:prod"]
