import type { FhirResource, HumanName, PatientResource } from "../types/fhir";

export function getHumanName(name?: HumanName[]): string {
  const primary = name?.[0];
  if (!primary) {
    return "Unknown patient";
  }

  return [...(primary.given ?? []), primary.family].filter(Boolean).join(" ");
}

export function formatDate(value?: string): string {
  if (!value) {
    return "Unknown";
  }

  const parsed = new Date(value);
  if (Number.isNaN(parsed.getTime())) {
    return value;
  }

  return new Intl.DateTimeFormat("en", {
    year: "numeric",
    month: "short",
    day: "numeric"
  }).format(parsed);
}

export function formatDateTime(value?: string): string {
  if (!value) {
    return "Unknown";
  }

  const parsed = new Date(value);
  if (Number.isNaN(parsed.getTime())) {
    return value;
  }

  return new Intl.DateTimeFormat("en", {
    year: "numeric",
    month: "short",
    day: "numeric",
    hour: "2-digit",
    minute: "2-digit"
  }).format(parsed);
}

export function getPatientAge(birthDate?: string): number | null {
  if (!birthDate) {
    return null;
  }

  const parsed = new Date(birthDate);
  if (Number.isNaN(parsed.getTime())) {
    return null;
  }

  const now = new Date();
  let age = now.getFullYear() - parsed.getFullYear();
  const monthDelta = now.getMonth() - parsed.getMonth();
  if (monthDelta < 0 || (monthDelta === 0 && now.getDate() < parsed.getDate())) {
    age -= 1;
  }

  return age >= 0 ? age : null;
}

export function getPatientAgeGroup(age: number | null): "young" | "adult" | "elder" | "unknown" {
  if (age === null) {
    return "unknown";
  }

  if (age < 18) {
    return "young";
  }

  if (age < 65) {
    return "adult";
  }

  return "elder";
}

export function getPatientMrn(patient: PatientResource): string {
  const preferred = patient.identifier?.find((identifier) =>
    identifier.type?.coding?.some((coding) => coding.code === "MR")
  );

  return preferred?.value ?? patient.identifier?.[0]?.value ?? "Not available";
}

export function getPatientAddress(patient: PatientResource): string {
  const address = patient.address?.[0];
  if (!address) {
    return "No address recorded";
  }

  return [address.line?.join(", "), address.city, address.state, address.postalCode, address.country]
    .filter(Boolean)
    .join(", ");
}

export function getPatientTelecom(patient: PatientResource): string {
  const telecom = patient.telecom?.[0];
  if (!telecom?.value) {
    return "No contact recorded";
  }

  return telecom.use ? `${telecom.value} (${telecom.use})` : telecom.value;
}

export function getCodeText(resource: FhirResource): string {
  const code = (resource.code ?? resource.type ?? resource.vaccineCode) as
    | {
        text?: string;
        coding?: Array<{ display?: string; code?: string }>;
      }
    | undefined;

  return code?.text ?? code?.coding?.[0]?.display ?? code?.coding?.[0]?.code ?? resource.resourceType;
}

export function getReferenceLabel(reference?: { display?: string; reference?: string }): string {
  if (!reference) {
    return "Unknown";
  }

  return reference.display ?? reference.reference ?? "Unknown";
}

export function getResourceDate(resource: FhirResource): string | undefined {
  const candidates = [
    resource.effectiveDateTime,
    resource.issued,
    resource.authoredOn,
    resource.occurrenceDateTime,
    resource.recordedDate,
    resource.onsetDateTime,
    (resource.performedPeriod as { start?: string } | undefined)?.start,
    (resource.period as { start?: string } | undefined)?.start,
    resource.date
  ];

  return candidates.find((value): value is string => typeof value === "string" && value.length > 0);
}

export function getObservationValue(resource: FhirResource): string {
  const quantity = resource.valueQuantity as { value?: number; unit?: string } | undefined;
  if (quantity?.value !== undefined) {
    return `${quantity.value}${quantity.unit ? ` ${quantity.unit}` : ""}`;
  }

  const codeable = resource.valueCodeableConcept as
    | { text?: string; coding?: Array<{ display?: string; code?: string }> }
    | undefined;
  if (codeable) {
    return codeable.text ?? codeable.coding?.[0]?.display ?? codeable.coding?.[0]?.code ?? "Recorded";
  }

  if (typeof resource.valueString === "string") {
    return resource.valueString;
  }

  if (typeof resource.valueBoolean === "boolean") {
    return resource.valueBoolean ? "Yes" : "No";
  }

  if (typeof resource.valueInteger === "number") {
    return String(resource.valueInteger);
  }

  return "Recorded";
}

export function getMedicationLabel(resource: FhirResource): string {
  const medication = (resource.medicationCodeableConcept ?? resource.medicationReference) as
    | { text?: string; display?: string; coding?: Array<{ display?: string; code?: string }> }
    | undefined;

  return medication?.text ?? medication?.display ?? medication?.coding?.[0]?.display ?? "Medication";
}
