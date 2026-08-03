# 1. Base Node.js súper liviana
FROM node:20-alpine

# 2. Instalamos git y OpenSSL (VITAL para que Prisma no se muera en Alpine)
RUN apk add --no-cache git openssl

# 3. Clonamos el repositorio completo
RUN git clone https://github.com/EvolutionAPI/evolution-api.git /app

# 4. Nos movemos a la carpeta del proyecto
WORKDIR /app

# 5. MAGIA NEGRA: Buscamos automáticamente la última versión ESTABLE oficial y nos anclamos ahí
RUN git fetch --tags && \
    LATEST_TAG=$(git describe --tags $(git rev-list --tags --max-count=1)) && \
    echo "Anclando en la version estable: $LATEST_TAG" && \
    git checkout $LATEST_TAG

# 6. Instalamos dependencias
RUN npm install

# 7. Generamos Prisma (ahora sin trucos, si falla queremos verlo, pero con OpenSSL tiene que andar)
RUN npx prisma generate

# 8. Construimos la aplicación
RUN npm run build

# 9. Exponemos el puerto
EXPOSE 8080

# 10. Comando final para encender el motor
CMD ["npm", "run", "start:prod"]
