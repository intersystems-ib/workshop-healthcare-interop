import { useState } from "react";
import { useQuery } from "@tanstack/react-query";
import { Link } from "react-router-dom";
import { searchPatients } from "../lib/fhir";
import { formatDate, getHumanName, getPatientMrn } from "../lib/format";
import { useAuth } from "../state/AuthContext";

export function HomePage() {
  const { session } = useAuth();
  const [name, setName] = useState("");
  const [gender, setGender] = useState("");

  const patientsQuery = useQuery({
    queryKey: ["patients", name, gender],
    queryFn: () => searchPatients(session!, { name, gender })
  });

  return (
    <main className="workspace-layout">
      <section className="hero-panel">
        <div className="hero-heading">
          <div>
            <span className="eyebrow">Patient Search</span>
            <h2 className="hero-title">Move from a patient index into a full clinical chart.</h2>
            <p className="hero-copy">
              The list runs live FHIR `Patient` searches. Open any result to load the patient’s
              longitudinal record from `Patient/$everything`.
            </p>
          </div>
          <div className="release-meta">
            <span className="release-label">FHIR Server</span>
            <span className="release-value">IRIS for Health R4 repository</span>
          </div>
        </div>
      </section>

      <section className="content-panel">
        <div className="workspace-section">
          <div className="workspace-section-header">
            <div className="workspace-section-heading">
              <span className="workspace-section-step">Search</span>
              <h3 className="workspace-section-title">Patient directory</h3>
            </div>
          </div>

          <div className="field-row">
            <div className="field">
              <label htmlFor="name">Name contains</label>
              <input id="name" onChange={(event) => setName(event.target.value)} value={name} />
            </div>
            <div className="field">
              <label htmlFor="gender">Gender</label>
              <select
                className="select"
                id="gender"
                onChange={(event) => setGender(event.target.value)}
                value={gender}
              >
                <option value="">Any</option>
                <option value="male">Male</option>
                <option value="female">Female</option>
                <option value="other">Other</option>
                <option value="unknown">Unknown</option>
              </select>
            </div>
          </div>

          {patientsQuery.isError ? <p className="error-text">{String(patientsQuery.error.message)}</p> : null}
          {patientsQuery.isLoading ? <p className="section-copy">Loading patients...</p> : null}

          <div className="home-grid grid">
            {(patientsQuery.data ?? []).map((patient) => (
              <article className="card" key={patient.id}>
                <div className="card-top">
                  <div>
                    <span className="pill">{patient.gender ?? "unknown"}</span>
                    <h3>{getHumanName(patient.name)}</h3>
                  </div>
                  <span className="meta-item">MRN {getPatientMrn(patient)}</span>
                </div>
                <div className="card-meta">
                  <span className="meta-item">Birth date: {formatDate(patient.birthDate)}</span>
                  <span className="meta-item">FHIR id: {patient.id}</span>
                </div>
                <div className="button-row">
                  <Link className="button button-primary" to={`/patients/${patient.id}`}>
                    Open record
                  </Link>
                </div>
              </article>
            ))}
          </div>

          {!patientsQuery.isLoading && (patientsQuery.data?.length ?? 0) === 0 ? (
            <div className="placeholder">
              <strong>No patients matched this search.</strong>
              <p>Try a broad search first or remove the gender filter.</p>
            </div>
          ) : null}
        </div>
      </section>
    </main>
  );
}
