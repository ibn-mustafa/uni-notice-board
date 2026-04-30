# ─────────────────────────────────────────────
# Stage 1 – Build  (Node.js + Parcel bundler)
# ─────────────────────────────────────────────
FROM node:20-alpine AS builder

# Set working directory
WORKDIR /app

# Copy dependency manifest first (layer-cache friendly)
COPY package.json ./

# Install all dev-dependencies (htmlhint, stylelint, parcel)
RUN npm install

# Copy the rest of the project source
COPY . .

# Run linting and build (mirrors the CI pipeline order)
RUN npm run lint:html
RUN npm run lint:css
RUN npm run build

# ─────────────────────────────────────────────
# Stage 2 – Serve  (lightweight nginx image)
# ─────────────────────────────────────────────
FROM nginx:stable-alpine

# Remove default nginx welcome page
RUN rm -rf /usr/share/nginx/html/*

# Copy built static files from the builder stage
COPY --from=builder /app/dist /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start nginx in the foreground
CMD ["nginx", "-g", "daemon off;"]
