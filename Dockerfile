# 1. Usamos una base ligera de Node.js
FROM node:20-alpine

# 2. Instalamos git para poder traer el código
RUN apk add --no-cache git

# 3. ¡EL TRUCO! Clonamos una versión ESTABLE (v2.2.0), no la rama de desarrollo rota
RUN git clone --branch v2.2.0 https://github.com/EvolutionAPI/evolution-api.git /app

# 4. Nos movemos a la carpeta del proyecto
WORKDIR /app

# 5. Instalamos y construimos (la versión estable ya tiene todo en su lugar)
RUN npm install
# Agregamos este comando con "|| true" para que intente generar la base, pero si ya lo hace automático no falle
RUN npx prisma generate || true 
RUN npm run build

# 6. Exponemos el puerto que usa la API
EXPOSE 8080

# 7. Comando final para encender el motor
CMD ["npm", "run", "start:prod"]
