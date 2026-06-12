import { useQuery } from "@tanstack/react-query";
import { Link, useParams } from "react-router-dom";
import { fetchPatientRecord } from "../lib/fhir";
import {
  formatDate,
  formatDateTime,
  getCodeText,
  getHumanName,
  getMedicationLabel,
  getObservationValue,
  getPatientAddress,
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
          <article className="card">
            <h3>Patient summary</h3>
            <div className="card-meta">
              <span className="meta-item">MRN: {getPatientMrn(patient)}</span>
              <span className="meta-item">Gender: {patient.gender ?? "Unknown"}</span>
              <span className="meta-item">Birth date: {formatDate(patient.birthDate)}</span>
              <span className="meta-item">Phone: {getPatientTelecom(patient)}</span>
              <span className="meta-item">Address: {getPatientAddress(patient)}</span>
            </div>
          </article>

          <article className="card">
            <h3>Record footprint</h3>
            <div className="chip-row">
              {resourceSections
                .filter((resourceType) => (groupedResources.get(resourceType)?.length ?? 0) > 0)
                .map((resourceType) => (
                  <span className="chip" key={resourceType}>
                    {resourceType} {groupedResources.get(resourceType)?.length}
                  </span>
                ))}
            </div>
            <p className="meta-item">Bundle entries: {resources.length}</p>
          </article>
        </div>
      </section>

      {resourceSections.map((resourceType) => {
        const items = groupedResources.get(resourceType) ?? [];
        if (items.length === 0) {
          return null;
        }

        return (
          <section className="content-panel" key={resourceType}>
            <h3 className="section-title">{resourceType}</h3>
            <p className="section-copy">{items.length} resource(s) related to this patient.</p>
            <div className="grid home-grid">
              {items.map((resource, index) => (
                <article className="card" key={`${resource.resourceType}-${resource.id ?? index}`}>
                  <div className="card-top">
                    <h3>{getCardTitle(resource)}</h3>
                    <span className="pill">{formatDateTime(getResourceDate(resource))}</span>
                  </div>
                  <div className="card-meta">
                    {getCardMeta(resource).map((item) => (
                      <span className="meta-item" key={item}>
                        {item}
                      </span>
                    ))}
                  </div>
                </article>
              ))}
            </div>
          </section>
        );
      })}

      <section className="content-panel">
        <h3 className="section-title">Technical View</h3>
        <p className="section-copy">Raw FHIR response for debugging and demo walkthroughs.</p>
        <div className="result-preview">
          <pre>{JSON.stringify(bundle, null, 2)}</pre>
        </div>
      </section>
    </main>
  );
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
