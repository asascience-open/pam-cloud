# 2. Create new database based on Makara

Date: 2026-04-30

## Status

Accepted

## Context

NOAA is unable to share the code behind Makara though we do have the database schema.  Therefore, we need to choose between a) building a new database based on the schema underlying Makara, b) use Tethys, c) build new database from scratch.

## Decision

Ue the database structure underlying Makara, but implement it in a different RDBMS (Postgres in AWS).

## Consequences

What becomes easier or more difficult to do and any risks introduced by the change that will need to be mitigated.

- Rewrite all of the database read/write routines at each step of the workflow.
- Potentially diverge from Makara norms since we might interpret the schema differently.


## Notes

So I did a deep dive into Tethys and wanted to share my findings here since I don't see an internal call scheduled next week. Though I'd be happy to talk about it on our Monday call as well.
 
The upshot is that I don't think we should use Tethys. Or if we do, we should run it in a Windows VM and not attempt to port it to Linux. The problem with Tethys is that it's built around an old XML database developed by Oracle called Berkely DB XML. The last major release of BDB XML was in 2014 and the last patch was in 2020. It's not technically end-of-life but it's well on it's way. There are also no binaries built for Linux and apparently it is notoriously difficult to build for modern Linux due to compiler incompatibilities, among other things. So it would likely be a ton of work to port it and in the end we'd still be running a 10-year-old XML database.
 
Tethys is also a complex enough piece of software that I don't think it makes much sense to rip out BDB XML and try and slot in something more modern. The whole stack is fairly old at this point.
 
What I would advocate for is a greenfield system that has better alignment with Makara's schema.
Westendarp, Pedro identified some pretty significant inconsistencies between the schemas used by Makara and Tethys that would likely cause us issue later on. So to me it makes most sense to start fresh. The functionality we'd be trying to replicate is not terribly complex and there are plenty of modern options we could consider that would be infinitely more maintainable/upgradable.
 
I chatted with
Stone, Brian and another dev Josh about the asset metadata management system they're developing internally -- the same one that's already come up as a potential option here -- and I think that would be a good place to start. The backend is just PostgreSQL with PostgREST on top, and the frontend is a schema-driven admin UI built with React and TypeScript. All modern/reliable stuff. 