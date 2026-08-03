# 1. Base Node.js liviana
FROM node:20-alpine

# 2. Instalamos git y OpenSSL
RUN apk add --no-cache git openssl

# 3. Clonamos el repositorio
RUN git clone https://github.com/EvolutionAPI/evolution-api.git /app

# 4. Nos movemos a la carpeta del proyecto
WORKDIR /app

# 5. Anclamos a la última versión estable (tag)
RUN git fetch --tags && \
    LATEST_TAG=$(git describe --tags $(git rev-list --tags --max-count=1)) && \
    echo "Anclando en la version estable: $LATEST_TAG" && \
    git checkout $LATEST_TAG

# 6. Instalamos dependencias
RUN npm install

# 7. Usamos el script propio del proyecto para generar el cliente de Prisma
RUN npm run build:prisma || npx prisma generate --schema=./prisma/schema.prisma || true

# 8. Construimos la aplicación
RUN npm run build

# 9. Exponemos el puerto
EXPOSE 8080

# 10. Encendemos la API
CMD ["npm", "run", "start:prod"]
