export type FhirResource = {
  resourceType: string;
  id?: string;
  [key: string]: unknown;
};

export type FhirBundleEntry<TResource extends FhirResource = FhirResource> = {
  fullUrl?: string;
  resource?: TResource;
};

export type FhirBundle<TResource extends FhirResource = FhirResource> = {
  resourceType: "Bundle";
  type?: string;
  total?: number;
  entry?: Array<FhirBundleEntry<TResource>>;
};

export type HumanName = {
  family?: string;
  given?: string[];
};

export type PatientResource = FhirResource & {
  resourceType: "Patient";
  name?: HumanName[];
  gender?: string;
  birthDate?: string;
  maritalStatus?: {
    text?: string;
    coding?: Array<{ code?: string; display?: string }>;
  };
  communication?: Array<{
    language?: {
      text?: string;
      coding?: Array<{ code?: string; display?: string }>;
    };
  }>;
  extension?: Array<{
    url?: string;
    valueCode?: string;
    valueString?: string;
    extension?: Array<{
      url?: string;
      valueString?: string;
      valueCoding?: {
        display?: string;
        code?: string;
      };
    }>;
  }>;
  identifier?: Array<{
    system?: string;
    value?: string;
    type?: {
      text?: string;
      coding?: Array<{ code?: string; display?: string }>;
    };
  }>;
  address?: Array<{
    line?: string[];
    city?: string;
    state?: string;
    postalCode?: string;
    country?: string;
  }>;
  telecom?: Array<{
    system?: string;
    value?: string;
    use?: string;
  }>;
};

export type Session = {
  username: string;
  password: string;
};

export type PatientSearchFilters = {
  name: string;
  gender: string;
};
