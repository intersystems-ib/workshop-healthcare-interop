import { createContext, useContext, useEffect, useMemo, useState } from "react";
import { loadStoredSession, persistSession } from "../lib/auth";
import type { Session } from "../types/fhir";

type AuthContextValue = {
  session: Session | null;
  login: (session: Session) => void;
  logout: () => void;
};

const AuthContext = createContext<AuthContextValue | null>(null);

export function AuthProvider({ children }: { children: React.ReactNode }) {
  const [session, setSession] = useState<Session | null>(() => loadStoredSession());

  useEffect(() => {
    persistSession(session);
  }, [session]);

  const value = useMemo(
    () => ({
      session,
      login: (nextSession: Session) => setSession(nextSession),
      logout: () => setSession(null)
    }),
    [session]
  );

  return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>;
}

export function useAuth(): AuthContextValue {
  const context = useContext(AuthContext);
  if (!context) {
    throw new Error("useAuth must be used within AuthProvider");
  }
  return context;
}
