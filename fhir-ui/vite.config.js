var _a;
import { defineConfig } from "vite";
import react from "@vitejs/plugin-react";
var irisBaseUrl = (_a = process.env.VITE_IRIS_BASE_URL) !== null && _a !== void 0 ? _a : "http://localhost:52773";
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
