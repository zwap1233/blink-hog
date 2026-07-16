# Blink-Hog Project Planning

Issues identified in the current repository, ranked by criticality.

## Critical (blocks build or boot)

| # | Issue | Location | Recommended Action |
|---|-------|----------|--------------------|
| 1 | **Git submodules not initialized** | `Hog/`, `boardstore/pynq-supported-board-file/` | Run `git submodule update --init --recursive` and document this in the README. Without Hog and board files, the Vivado build cannot start. |
| 2 | **`create_petalinux_image.sh` uses unquoted `find` with globs** | `petalinux/create_petalinux_image.sh` lines 7-9 | Use quoted paths, `-maxdepth 1`, and explicit file checks. Multiple files or spaces in `~/bin/` will break the script. |
| 3 | **PetaLinux `config` has manual SD selected without controller** | `petalinux/config` | Explicitly set `CONFIG_SUBSYSTEM_PRIMARY_SD_PS7_SD_0_SELECT=y` (or `_1`) for PYNQ-Z2. Without this, the board may not boot from SD. |
| 4 | **`wire r0-r3` declared after instantiation** | `blink/hdl/Blink.v` lines 48-83 | Move `wire [C_S00_AXI_DATA_WIDTH-1:0] r0, r1, r2, r3;` above the `Blink_slave_lite_v1_0_S00_AXI` instance to avoid implicit-net/width errors. |
| 5 | **Custom AXI-Lite slave violates handshake assumptions** | `blink/hdl/Blink_slave_lite_v1_0_S00_AXI.v` | `WREADY` tied to `AWREADY` and `axi_awready` toggling breaks independent AW/W channel behavior. Replace with a proven AXI-Lite template or Xilinx AXI GPIO. |

## High (will likely fail in non-trivial scenarios)

| # | Issue | Location | Recommended Action |
|---|-------|----------|--------------------|
| 6 | **`petalinux-config` runs interactively** | `petalinux/create_petalinux_image.sh` line 20 | Add `--silentconfig` and pre-seed the project to support CI/automation. |
| 7 | **Committed `petalinux/config` and `config.old` are not used** | `petalinux/config`, `petalinux/config.old` | Either copy them into `blink/project-spec/configs/config` during project creation, or remove them to avoid stale confusion. |
| 8 | **No error handling in PetaLinux script** | `petalinux/create_petalinux_image.sh` | Check that `XSA_FILE`, `BIT_FILE`, and `rootfs.tar.gz` exist before packaging. |
| 9 | **`docker-compose.yml` does not build the image** | `petalinux/docker-compose.yml` | Add a `build:` section or document the `docker build -t petalinuxcontainer .` step. |

## Medium (should fix for quality and maintainability)

| # | Issue | Location | Recommended Action |
|---|-------|----------|--------------------|
| 10 | **`led_1` is active-low while `led_0` is active-high** | `blink/hdl/Blink.v` line 82 | Remove the `~` on `led_1` unless the asymmetric behavior is intentional. Document it if intentional. |
| 11 | **Stale generated wrapper from Vivado 2024.1** | `blink/hdl/design_1_wrapper.vhd` | Regenerate with Vivado 2025.2 or let Hog regenerate the wrapper. |
| 12 | **`TARGET_LANGUAGE=Verilog` but top-level is VHDL** | `Top/blink/hog.conf` line 16 | Set `TARGET_LANGUAGE=VHDL` to match the committed top-level wrapper, or regenerate the wrapper in Verilog. |
| 13 | **Dockerfile hardcodes user identity** | `petalinux/Dockerfile` lines 20-23, 38 | Remove the hardcoded `xilinx` user name/email, or make them `ARG` defaults. |
| 14 | **No README or build instructions** | repository root | Add a `README.md` with prerequisites, `git submodule` commands, `make` targets, and PetaLinux image creation steps. |

## Low (nice to have)

| # | Issue | Location | Recommended Action |
|---|-------|----------|--------------------|
| 15 | **PetaLinux `config.old` is empty and unused** | `petalinux/config.old` | Remove the file or keep it in a backup directory outside the repo. |
| 16 | **`.gitignore` ignores `petalinux/*/` but root `config` is tracked** | `.gitignore`, `petalinux/config` | Decide whether to track the generated project `config` or keep it ignored; be consistent. |
| 17 | **Makefile could include a `petalinux` target** | `Makefile` | Add a `petalinux` target that calls `create_petalinux_image.sh` after a successful bitstream build to tie the flows together. |
