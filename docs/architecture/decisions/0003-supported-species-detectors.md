# 3. Supported Species Detectors

Date: 2026-07-23

## Status

Accepted

## Context

This is the full list of species detectors to be supported in the initial design of PAMHUB.

## Decision

**General Tools:**
- PAMGuard detectors: (included with the PAMGuard install)

**Multispecies Baleen Whales:**
- LFDCS

**North Atlantic Minke whale pulse-train detector:**

- CNN-based detector for detecting pulse trains from N-A minke whale. It is has been used along the US east coast from the Gulf of Maine , down to the Caribbeans and Mexico. It has mostly been used on fixed mooring, but a student from USVI used it successfully on glider data.
- The version most people use is on the repo here: https://github.com/xaviermouy/minke-whale-detector. The repo includes a word document with documentation/instructions.
- There is also a linux version to help batch processing on the NEFSC containers they run locally (i.e. not on their cloud environment). It is the same thing as above but with a few more sh scripts and wrapers to facilitate queuing processing tasks, etc. This was very specific for NEFSC's needs, so using the version above may be more appropriate. Repo here: https://github.com/xaviermouy/minke-whale-detector_batch-processing_linux

**General fish detector:**

A generic fish sound detector
- GitHub repo here: https://github.com/xaviermouy/FishSound_Finder
- Documentation and tutorial here: https://fishsound-finder.readthedocs.io/en/latest/

**Kurtosis detector:**

- This is a versatile impulse detector that is being used for detecting pile driving sounds (used by NOAA in the SNE wind energy areas for monitoring pile driving activity), haddock knock trains (what I use for monitoring haddock in the Gulf of Maine), and Megaptcliks from humpback whales (what I used in our herring investigation in Stellwagen bank).
- The configuration file used with the detector dictates what signals/frequencies to look for
- The GitHub repo is here and has a Word doc with instructions to run it: https://github.com/xaviermouy/KurtosisDetector

**Humpback detector:**

- This  is the package from Vincent Kather called AcoDet: https://github.com/vskode/acodet
- NOAA NEFSC is now using this detector in addition to LFDCS for humpbacks

## Consequences

None