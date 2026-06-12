import { useState } from "react";
import { useQuery } from "@tanstack/react-query";
import { Link } from "react-router-dom";
import { searchPatients } from "../lib/fhir";
import { formatDate, getHumanName, getPatientAge, getPatientAgeGroup } from "../lib/format";
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
            {(patientsQuery.data ?? []).map((patient) => {
              const age = getPatientAge(patient.birthDate);
              const ageGroup = getPatientAgeGroup(age);
              const ageLabel = age === null ? "age unknown" : `${ageGroup} ${age}y`;

              return (
                <article className="card patient-card" key={patient.id}>
                  <div className="card-top patient-card-top">
                    <div className="patient-card-heading">
                      <h3>{getHumanName(patient.name)}</h3>
                      <div className="patient-card-badges">
                        <span className="patient-label-chip">{patient.gender ?? "unknown"}</span>
                        <span className="patient-label-chip patient-label-chip-muted">{ageLabel}</span>
                      </div>
                    </div>
                  </div>
                  <div className="card-meta patient-card-meta">
                    <span className="meta-item">Birth date: {formatDate(patient.birthDate)}</span>
                    <span className="meta-item">FHIR id: {patient.id}</span>
                  </div>
                  <div className="button-row patient-card-actions">
                    <Link className="button button-secondary patient-link" to={`/patients/${patient.id}`}>
                      <RecordArrowIcon />
                      <span>View record</span>
                    </Link>
                  </div>
                </article>
              );
            })}
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

function RecordArrowIcon() {
  return (
    <svg className="patient-link-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.8">
      <path d="M5 12h12" />
      <path d="M13 7l5 5-5 5" />
    </svg>
  );
}
