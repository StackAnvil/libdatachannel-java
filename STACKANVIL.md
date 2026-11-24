# StackAnvil fork

This fork builds [opencollab-incubator/libdatachannel-java](https://github.com/opencollab-incubator/libdatachannel-java) with a few native patches that StackAnvil needs before they reach upstream. StackAnvil pins the release assets by checksum and never builds this project itself.

The `stackanvil` branch is the upstream commit StackAnvil pins, plus these changes:

- `patches/<name>/*.patch`: patches for nested submodules. `scripts/apply-stackanvil-patches.sh` maps each directory to its submodule and applies the patches.
- `.github/workflows/native-builds.yml`: one step that runs the script after checkout.
- `.github/workflows/stackanvil-release.yml`: builds every native target and publishes an immutable release.

## Patches

| Patch | Upstream |
| --- | --- |
| `libjuice/0001-discard-unauthenticated-and-late-error-responses-to-checks.patch` | Not submitted yet. Branch [AlexProgrammerDE/libjuice@authenticate-check-error-responses](https://github.com/AlexProgrammerDE/libjuice/tree/authenticate-check-error-responses). |

Drop a patch once the submodule it targets contains the change.

## Release

1. Rebase `stackanvil` onto the upstream commit you want, and check that `scripts/apply-stackanvil-patches.sh` still applies every patch.
2. Tag the branch as `v<libdatachannel version>.<n>-stackanvil.<release>`, for example `v0.24.6.0-stackanvil.1`, and push the tag.
3. The workflow publishes the facade JAR, the arch-detect bundle with every native library, both POMs, and `SHA256SUMS`. The repository has immutable releases enabled, so a published tag and its assets cannot change.
4. Update `libdatachannel.json` in [StackAnvil/patches](https://github.com/StackAnvil/patches) with the new tag and checksums.
