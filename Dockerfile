# 1. Base Node.js liviana
FROM node:20-alpine

# 2. Instalamos git y OpenSSL (imprescindible para Prisma en Alpine)
RUN apk add --no-cache git openssl

# 3. Clonamos el repositorio oficial
RUN git clone https://github.com/EvolutionAPI/evolution-api.git /app

# 4. Nos movemos a la carpeta del proyecto
WORKDIR /app

# 5. Instalamos dependencias
RUN npm install

# 6. BUSCADOR AUTOMÁTICO: Encuentra la ruta REAL del schema y genera el cliente
RUN SCHEMA_PATH=$(find /app -name "*.prisma" -print -quit) && \
    echo ">>> Archivo schema encontrado en: $SCHEMA_PATH" && \
    npx prisma generate --schema="$SCHEMA_PATH"

# 7. Construimos la aplicación
RUN npm run build

# 8. Exponemos el puerto oficial
EXPOSE 8080

# 9. Comando de arranque
CMD ["npm", "run", "start:prod"]
