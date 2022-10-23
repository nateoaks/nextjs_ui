FROM node:16-alpine as builder
WORKDIR /app
COPY package.json package-lock.json /app
RUN npm install
COPY . .
RUN npm run build

FROM node:16-alpine as production
WORKDIR /app
ENV NODE_ENV production

COPY --from=builder /app/public ./public
COPY --from=builder --chown=nextjs:nodejs /app/.next/standalone ./
COPY --from=builder --chown=nextjs:nodejs /app/.next/static ./.next/static

EXPOSE 3000
ENV PORT 3000

# CMD npm run start:prod
CMD node server.js
