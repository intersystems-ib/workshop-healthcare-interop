import { useState } from "react";
import { useMutation } from "@tanstack/react-query";
import { Navigate } from "react-router-dom";
import { validateSession } from "../lib/fhir";
import { useAuth } from "../state/AuthContext";

export function LoginPage() {
  const { session, login } = useAuth();
  const [username, setUsername] = useState("superuser");
  const [password, setPassword] = useState("SYS");

  const authMutation = useMutation({
    mutationFn: async () => {
      const nextSession = { username, password };
      await validateSession(nextSession);
      return nextSession;
    },
    onSuccess: (nextSession) => {
      login(nextSession);
    }
  });

  if (session) {
    return <Navigate to="/" replace />;
  }

  return (
    <div className="app-shell">
      <div className="page grid login-grid">
        <section className="hero-panel">
          <div className="hero-heading">
            <div>
              <span className="eyebrow">Workshop UI</span>
              <h1 className="hero-title">Clinical records from the IRIS FHIR repository.</h1>
              <p className="hero-copy">
                This frontend uses the same stack as the terminology demo UI, but it is oriented around
                patient discovery and longitudinal record review.
              </p>
            </div>
          </div>
          <div className="status-list">
            <article className="status-card">
              <h3>FHIR endpoint</h3>
              <p>`/csp/healthshare/fhirrepo/fhir/r4` through the local Vite proxy.</p>
            </article>
            <article className="status-card">
              <h3>Patient views</h3>
              <p>Search patients, open a chart, and inspect grouped resources from `$everything`.</p>
            </article>
            <article className="status-card">
              <h3>Expected credentials</h3>
              <p>Local workshop default is `superuser` / `SYS`.</p>
            </article>
          </div>
        </section>

        <section className="form-panel">
          <h2 className="form-title">Connect to IRIS</h2>
          <p className="form-copy">The UI validates credentials by requesting the FHIR capability statement.</p>
          <form
            className="form"
            onSubmit={(event) => {
              event.preventDefault();
              authMutation.mutate();
            }}
          >
            <div className="field">
              <label htmlFor="username">Username</label>
              <input id="username" onChange={(event) => setUsername(event.target.value)} value={username} />
            </div>
            <div className="field">
              <label htmlFor="password">Password</label>
              <input
                id="password"
                onChange={(event) => setPassword(event.target.value)}
                type="password"
                value={password}
              />
            </div>
            {authMutation.isError ? (
              <p className="error-text">Authentication failed: {String(authMutation.error.message)}</p>
            ) : null}
            <div className="button-row">
              <button className="button button-primary" disabled={authMutation.isPending} type="submit">
                {authMutation.isPending ? "Connecting..." : "Open workspace"}
              </button>
            </div>
          </form>
        </section>
      </div>
    </div>
  );
}
