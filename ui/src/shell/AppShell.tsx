import { Link, Outlet, useLocation } from "react-router-dom";
import { useAuth } from "../state/AuthContext";

export function AppShell() {
  const { session, logout } = useAuth();
  const location = useLocation();

  return (
    <div className="app-shell">
      <div className="page">
        <header className="shell-header">
          <div className="shell-brand">
            <span className="eyebrow">FHIR Repository</span>
            <h1>Patient record workspace</h1>
            <p>Explore IRIS for Health sample records with a clinical-first lens.</p>
          </div>
          <div className="shell-actions">
            <nav className="tab-row">
              <Link className={`tab-button ${location.pathname === "/" ? "tab-button-active" : ""}`} to="/">
                Patients
              </Link>
            </nav>
            <p className="shell-meta">{session?.username}</p>
            <button className="button button-secondary" onClick={logout} type="button">
              Sign out
            </button>
          </div>
        </header>
        <Outlet />
      </div>
    </div>
  );
}
