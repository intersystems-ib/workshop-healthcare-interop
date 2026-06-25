import { z } from "zod";
import { FHIR_PATH } from "../config/env";
import { encodeBasicAuth } from "./auth";
import type { FhirBundle, FhirResource, PatientResource, Session } from "../types/fhir";

const bundleSchema = z.object({
  resourceType: z.literal("Bundle"),
  type: z.string().optional(),
  total: z.number().optional(),
  entry: z
    .array(
      z.object({
        fullUrl: z.string().optional(),
        resource: z
          .object({
            resourceType: z.string()
          })
          .catchall(z.unknown())
          .optional()
      })
    )
    .optional()
});

function createHeaders(session: Session): HeadersInit {
  return {
    Accept: "application/fhir+json",
    Authorization: encodeBasicAuth(session)
  };
}

async function request(path: string, session: Session): Promise<unknown> {
  const response = await fetch(`${FHIR_PATH}${path}`, {
    headers: createHeaders(session)
  });

  if (!response.ok) {
    throw new Error(`${response.status} ${response.statusText}`);
  }

  return (await response.json()) as unknown;
}

export async function validateSession(session: Session): Promise<void> {
  await request("/metadata", session);
}

export async function searchPatients(
  session: Session,
  filters: { name: string; gender: string }
): Promise<PatientResource[]> {
  const params = new URLSearchParams({ _count: "20" });
  if (filters.name.trim()) {
    params.set("name:contains", filters.name.trim());
  }
  if (filters.gender) {
    params.set("gender", filters.gender);
  }

  const bundle = bundleSchema.parse(await request(`/Patient?${params.toString()}`, session)) as FhirBundle;
  return (bundle.entry ?? [])
    .map((entry) => entry.resource)
    .filter((resource): resource is PatientResource => resource?.resourceType === "Patient");
}

export async function fetchPatientRecord(
  session: Session,
  patientId: string
): Promise<{ patient: PatientResource; bundle: FhirBundle<FhirResource> }> {
  const bundle = bundleSchema.parse(await request(`/Patient/${patientId}/$everything`, session)) as FhirBundle<
    FhirResource
  >;

  const patient = (bundle.entry ?? [])
    .map((entry) => entry.resource)
    .find((resource): resource is PatientResource => resource?.resourceType === "Patient");

  if (!patient) {
    throw new Error("Patient record is missing the Patient resource");
  }

  return { patient, bundle };
}
