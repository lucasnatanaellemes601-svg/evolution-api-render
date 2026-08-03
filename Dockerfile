# 1. Usamos una base ligera de Node.js
FROM node:20-alpine

# 2. Instalamos git
RUN apk add --no-cache git

# 3. Clonamos el código de la rama principal (ya que no encontramos la v2.2.0)
RUN git clone https://github.com/EvolutionAPI/evolution-api.git /app

# 4. Nos movemos a la carpeta del proyecto
WORKDIR /app

# 5. Instalamos dependencias
RUN npm install

# 6. ¡El buscador automático arreglado! (Busca sin comillas y genera Prisma)
RUN find . -name schema.prisma -exec npx prisma generate --schema={} \; || true

# 7. Construimos la app
RUN npm run build

# 8. Exponemos el puerto que usa la API
EXPOSE 8080

# 9. Comando final para encender el motor
CMD ["npm", "run", "start:prod"]
