import { defineConfig } from "vite";
import react from "@vitejs/plugin-react";

const irisBaseUrl = process.env.VITE_IRIS_BASE_URL ?? "http://localhost:52773";

export default defineConfig({
  plugins: [react()],
  server: {
    port: 5173,
    proxy: {
      "/iris": {
        target: irisBaseUrl,
        changeOrigin: true
      }
    }
  }
});
