import { z } from "zod";
import type { Session } from "../types/fhir";

const STORAGE_KEY = "workshop.fhir.session";

const sessionSchema = z.object({
  username: z.string().min(1),
  password: z.string().min(1)
});

export function encodeBasicAuth(session: Session): string {
  return `Basic ${window.btoa(`${session.username}:${session.password}`)}`;
}

export function loadStoredSession(): Session | null {
  const raw = window.localStorage.getItem(STORAGE_KEY);
  if (!raw) {
    return null;
  }

  const parsed = sessionSchema.safeParse(JSON.parse(raw));
  return parsed.success ? parsed.data : null;
}

export function persistSession(session: Session | null): void {
  if (!session) {
    window.localStorage.removeItem(STORAGE_KEY);
    return;
  }

  window.localStorage.setItem(STORAGE_KEY, JSON.stringify(session));
}
