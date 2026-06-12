import { useState } from "react";
import { useQuery } from "@tanstack/react-query";
import { Link, useParams } from "react-router-dom";
import { fetchPatientRecord } from "../lib/fhir";
import {
  formatDate,
  formatDateTime,
  getCodeText,
  getPatientAge,
  getHumanName,
  getPatientBirthSex,
  getMedicationLabel,
  getObservationValue,
  getPatientAddress,
  getPatientEthnicityOrRace,
  getPatientLanguage,
  getPatientMaritalStatus,
  getPatientMrn,
  getPatientTelecom,
  getReferenceLabel,
  getResourceDate
} from "../lib/format";
import { useAuth } from "../state/AuthContext";
import type { FhirResource } from "../types/fhir";

const resourceSections = [
  "Encounter",
  "Condition",
  "Observation",
  "MedicationRequest",
  "Procedure",
  "Immunization",
  "DiagnosticReport",
  "CarePlan",
  "Claim",
  "ExplanationOfBenefit"
] as const;

export function PatientPage() {
  const { patientId = "" } = useParams();
  const { session } = useAuth();
  const [activityFilter, setActivityFilter] = useState("all");
  const [timeFilter, setTimeFilter] = useState("all");

  const recordQuery = useQuery({
    queryKey: ["patient-record", patientId],
    queryFn: () => fetchPatientRecord(session!, patientId)
  });

  if (recordQuery.isLoading) {
    return (
      <section className="content-panel">
        <p className="section-copy">Loading patient record...</p>
      </section>
    );
  }

  if (recordQuery.isError || !recordQuery.data) {
    return (
      <section className="content-panel">
        <p className="error-text">{recordQuery.isError ? String(recordQuery.error.message) : "Missing record"}</p>
      </section>
    );
  }

  const { patient, bundle } = recordQuery.data;
  const resources = (bundle.entry ?? [])
    .map((entry) => entry.resource)
    .filter((resource): resource is FhirResource => Boolean(resource));

  const groupedResources = new Map<string, FhirResource[]>();
  for (const resource of resources) {
    const list = groupedResources.get(resource.resourceType) ?? [];
    list.push(resource);
    groupedResources.set(resource.resourceType, list);
  }

  for (const [resourceType, list] of groupedResources.entries()) {
    list.sort((left, right) => {
      const leftDate = getResourceDate(left) ?? "";
      const rightDate = getResourceDate(right) ?? "";
      return rightDate.localeCompare(leftDate);
    });
    groupedResources.set(resourceType, list);
  }

  const timelineItems = resources
    .filter((resource) => resource.resourceType !== "Patient")
    .map((resource, index) => ({
      resource,
      index,
      sortDate: getResourceDate(resource) ?? "",
      hasDate: Boolean(getResourceDate(resource))
    }))
    .sort((left, right) => {
      if (left.hasDate && right.hasDate) {
        return right.sortDate.localeCompare(left.sortDate);
      }

      if (left.hasDate) {
        return -1;
      }

      if (right.hasDate) {
        return 1;
      }

      return left.index - right.index;
    });

  const activityOptions = resourceSections.filter(
    (resourceType) => (groupedResources.get(resourceType)?.length ?? 0) > 0
  );
  const patientAge = getPatientAge(patient.birthDate);
  const filteredTimelineItems = timelineItems.filter(({ resource, sortDate }) => {
    if (activityFilter !== "all" && resource.resourceType !== activityFilter) {
      return false;
    }

    if (timeFilter === "all") {
      return true;
    }

    if (!sortDate) {
      return false;
    }

    const resourceDate = new Date(sortDate);
    if (Number.isNaN(resourceDate.getTime())) {
      return false;
    }

    const cutoff = getTimeFilterCutoff(timeFilter);
    return cutoff ? resourceDate >= cutoff : true;
  });

  return (
    <main className="workspace-layout">
      <section className="hero-panel">
        <div className="hero-heading">
          <div>
            <span className="eyebrow">Patient Chart</span>
            <h2 className="hero-title">{getHumanName(patient.name)}</h2>
            <p className="hero-copy">
              Demographics from the `Patient` resource plus related clinical material returned by
              `Patient/{patientId}/$everything`.
            </p>
          </div>
          <div className="button-row">
            <Link className="button button-secondary" to="/">
              Back to patients
            </Link>
          </div>
        </div>
      </section>

      <section className="content-panel">
        <div className="workspace-grid">
          <article className="card demographics-card">
            <span className="section-kicker">Demographics</span>
            <h3>Patient details</h3>
            <div className="demographics-grid">
              <div className="demographics-item">
                <span className="demographics-label">Gender</span>
                <span className="demographics-value">{patient.gender ?? "Unknown"}</span>
              </div>
              <div className="demographics-item">
                <span className="demographics-label">Birth date</span>
                <span className="demographics-value">{formatDate(patient.birthDate)}</span>
              </div>
              <div className="demographics-item">
                <span className="demographics-label">Age</span>
                <span className="demographics-value">{patientAge === null ? "Not recorded" : `${patientAge} years`}</span>
              </div>
              <div className="demographics-item">
                <span className="demographics-label">MRN</span>
                <span className="demographics-value">{getPatientMrn(patient)}</span>
              </div>
              <div className="demographics-item">
                <span className="demographics-label">Phone</span>
                <span className="demographics-value">{getPatientTelecom(patient)}</span>
              </div>
              <div className="demographics-item">
                <span className="demographics-label">Birth sex</span>
                <span className="demographics-value">{getPatientBirthSex(patient)}</span>
              </div>
              <div className="demographics-item">
                <span className="demographics-label">Marital status</span>
                <span className="demographics-value">{getPatientMaritalStatus(patient)}</span>
              </div>
              <div className="demographics-item">
                <span className="demographics-label">Language</span>
                <span className="demographics-value">{getPatientLanguage(patient)}</span>
              </div>
              <div className="demographics-item">
                <span className="demographics-label">Race</span>
                <span className="demographics-value">{getPatientEthnicityOrRace(patient, "race")}</span>
              </div>
              <div className="demographics-item">
                <span className="demographics-label">Ethnicity</span>
                <span className="demographics-value">{getPatientEthnicityOrRace(patient, "ethnicity")}</span>
              </div>
              <div className="demographics-item demographics-item-wide">
                <span className="demographics-label">Address</span>
                <span className="demographics-value">{getPatientAddress(patient)}</span>
              </div>
            </div>
          </article>

          <article className="card footprint-card">
            <span className="section-kicker">Record profile</span>
            <h3>Clinical footprint</h3>
            <div className="footprint-summary">
              <div className="footprint-total">
                <span className="footprint-total-value">{resources.length}</span>
                <span className="footprint-total-label">bundle entries</span>
              </div>
              <p className="meta-item footprint-copy">
                A quick sense of where this chart is dense, from results and visits to claims and care activity.
              </p>
            </div>
            <div className="footprint-list">
              {resourceSections
                .filter((resourceType) => (groupedResources.get(resourceType)?.length ?? 0) > 0)
                .map((resourceType) => (
                  <div className="footprint-row" key={resourceType}>
                    <div className="footprint-row-top">
                      <span className="footprint-name">{formatResourceType(resourceType)}</span>
                      <span className="footprint-count">{groupedResources.get(resourceType)?.length}</span>
                    </div>
                    <div className="footprint-bar">
                      <div
                        className="footprint-bar-fill"
                        style={{
                          width: `${Math.max(
                            10,
                            ((groupedResources.get(resourceType)?.length ?? 0) /
                              Math.max(...resourceSections.map((type) => groupedResources.get(type)?.length ?? 0), 1)) *
                              100
                          )}%`
                        }}
                      />
                    </div>
                  </div>
                ))}
            </div>
          </article>
        </div>
      </section>

      <section className="content-panel">
        <h3 className="section-title">Clinical timeline</h3>
        <p className="section-copy">
          Most recent activity first. This view mixes encounters, observations, medications, claims,
          and other patient resources into one chronological stream.
        </p>
        <div className="timeline-filters">
          <div className="field">
            <label htmlFor="activity-filter">Activity</label>
            <select
              className="select"
              id="activity-filter"
              onChange={(event) => setActivityFilter(event.target.value)}
              value={activityFilter}
            >
              <option value="all">All activity</option>
              {activityOptions.map((resourceType) => (
                <option key={resourceType} value={resourceType}>
                  {resourceType}
                </option>
              ))}
            </select>
          </div>
          <div className="field">
            <label htmlFor="time-filter">Time</label>
            <select
              className="select"
              id="time-filter"
              onChange={(event) => setTimeFilter(event.target.value)}
              value={timeFilter}
            >
              <option value="all">All time</option>
              <option value="30d">Last 30 days</option>
              <option value="1y">Last year</option>
              <option value="5y">Last 5 years</option>
            </select>
          </div>
        </div>
        <div className="timeline-list">
          {filteredTimelineItems.map(({ resource, index }) => (
            <article className="timeline-item" key={`${resource.resourceType}-${resource.id ?? index}`}>
              <div className="timeline-rail" aria-hidden="true">
                <span className="timeline-dot" />
              </div>
              <div className="timeline-content">
                <div className="timeline-top">
                  <div className="timeline-heading">
                    <span className="timeline-type">{resource.resourceType}</span>
                    <h4 className="timeline-title">{getCardTitle(resource)}</h4>
                  </div>
                  <span className="timeline-date">{formatDateTime(getResourceDate(resource))}</span>
                </div>
                <div className="timeline-meta">
                  {getCardMeta(resource).map((item) => (
                    <span className="meta-item" key={item}>
                      {item}
                    </span>
                  ))}
                </div>
              </div>
            </article>
          ))}
          {filteredTimelineItems.length === 0 ? (
            <div className="placeholder">
              <strong>No timeline entries match these filters.</strong>
              <p>Try broadening the time range or switching activity back to all.</p>
            </div>
          ) : null}
        </div>
      </section>

    </main>
  );
}

function getTimeFilterCutoff(value: string): Date | null {
  const now = new Date();

  switch (value) {
    case "30d":
      return new Date(now.getFullYear(), now.getMonth(), now.getDate() - 30);
    case "1y":
      return new Date(now.getFullYear() - 1, now.getMonth(), now.getDate());
    case "5y":
      return new Date(now.getFullYear() - 5, now.getMonth(), now.getDate());
    default:
      return null;
  }
}

function formatResourceType(value: string): string {
  return value.replace(/([a-z])([A-Z])/g, "$1 $2");
}

function getCardTitle(resource: FhirResource): string {
  switch (resource.resourceType) {
    case "Observation":
      return `${getCodeText(resource)}: ${getObservationValue(resource)}`;
    case "MedicationRequest":
      return getMedicationLabel(resource);
    case "Encounter":
      return getCodeText(resource);
    default:
      return getCodeText(resource);
  }
}

function getCardMeta(resource: FhirResource): string[] {
  switch (resource.resourceType) {
    case "Encounter": {
      const encounter = resource as FhirResource & {
        class?: { code?: string; display?: string };
        serviceProvider?: { display?: string; reference?: string };
      };
      return [
        `Class: ${encounter.class?.display ?? encounter.class?.code ?? "Unknown"}`,
        `Provider: ${getReferenceLabel(encounter.serviceProvider)}`
      ];
    }
    case "Condition": {
      const condition = resource as FhirResource & {
        clinicalStatus?: { coding?: Array<{ display?: string; code?: string }> };
      };
      return [`Status: ${condition.clinicalStatus?.coding?.[0]?.display ?? "Recorded"}`];
    }
    case "Observation": {
      return [`Value: ${getObservationValue(resource)}`];
    }
    case "MedicationRequest": {
      const medication = resource as FhirResource & {
        requester?: { display?: string; reference?: string };
        status?: string;
      };
      return [
        `Status: ${medication.status ?? "Recorded"}`,
        `Requester: ${getReferenceLabel(medication.requester)}`
      ];
    }
    case "Procedure": {
      const procedure = resource as FhirResource & {
        status?: string;
      };
      return [`Status: ${procedure.status ?? "Recorded"}`];
    }
    case "Immunization": {
      const immunization = resource as FhirResource & {
        status?: string;
      };
      return [`Status: ${immunization.status ?? "Recorded"}`];
    }
    case "DiagnosticReport": {
      const report = resource as FhirResource & {
        conclusion?: string;
      };
      return [report.conclusion ? `Conclusion: ${report.conclusion}` : "Conclusion: Not recorded"];
    }
    case "CarePlan": {
      const carePlan = resource as FhirResource & {
        status?: string;
        intent?: string;
      };
      return [`Status: ${carePlan.status ?? "Recorded"}`, `Intent: ${carePlan.intent ?? "Unknown"}`];
    }
    case "Claim":
    case "ExplanationOfBenefit": {
      const financial = resource as FhirResource & {
        status?: string;
        insurer?: { display?: string; reference?: string };
      };
      return [
        `Status: ${financial.status ?? "Recorded"}`,
        `Insurer: ${getReferenceLabel(financial.insurer)}`
      ];
    }
    default:
      return [`FHIR id: ${resource.id ?? "Unknown"}`];
  }
}
