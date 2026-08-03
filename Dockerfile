# 1. Usamos una base ligera de Node.js
FROM node:20-alpine

# 2. Instalamos git para poder traer el código
RUN apk add --no-cache git

# 3. Clonamos el código fuente oficial y público
RUN git clone https://github.com/EvolutionAPI/evolution-api.git /app

# 4. Nos movemos a la carpeta del proyecto
WORKDIR /app

# 5. Instalamos dependencias, GENERAMOS PRISMA, y construimos
RUN npm install
RUN npx prisma generate
RUN npm run build

# 6. Exponemos el puerto que usa la API
EXPOSE 8080

# 7. Comando final para encender el motor
CMD ["npm", "run", "start:prod"]
