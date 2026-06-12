# UI

React + Vite frontend for the FHIR repository demo in this repository.

It follows the same frontend technology choices as the `iris-terminology-server/ui` app:

- Vite
- React 18
- TypeScript
- React Router
- TanStack Query
- Zod

## What It Does

- Basic-auth login against the local IRIS FHIR repository
- patient search by name or gender
- patient list view with demographics
- patient record page using `Patient/{id}/$everything`
- grouped clinical sections for conditions, encounters, observations, medications, procedures, immunizations, reports and claims

## Run It

From the repo root, start IRIS first:

```bash
docker compose up -d
```

From `ui/`:

```bash
npm install
npm run dev
```

Open:

```text
http://localhost:5173
```

## FHIR Prerequisite

The workshop FHIR server must exist and be loaded first, as described in the top-level [README](../README.md).

Default repository endpoint used by the UI:

```text
/csp/healthshare/fhirrepo/fhir/r4
```

## Configuration

Copy `.env.example` to `.env` if you need a different IRIS host:

```text
VITE_IRIS_BASE_URL=http://localhost:52773
```

The Vite dev server proxies `/iris/*` to that base URL, so browser CORS configuration is not required for local development.
