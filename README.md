# MVox Guix Channel

[![Guix Build](https://github.com/benzwick/guix-mvox/actions/workflows/guix-build.yml/badge.svg)](https://github.com/benzwick/guix-mvox/actions/workflows/guix-build.yml)
[![Guix Channel](https://github.com/benzwick/guix-mvox/actions/workflows/guix-channel.yml/badge.svg)](https://github.com/benzwick/guix-mvox/actions/workflows/guix-channel.yml)
[![Guix Shell](https://github.com/benzwick/guix-mvox/actions/workflows/guix-shell.yml/badge.svg)](https://github.com/benzwick/guix-mvox/actions/workflows/guix-shell.yml)

This [Guix channel](https://guix.gnu.org/manual/en/html_node/Channels.html)
provides packages for [MFEM](https://mfem.org) and
[MVox](https://github.com/benzwick/mvox).

| Package         | Version | Description |
|-----------------|---------|-------------|
| `mfem`          | 4.9     | Finite element methods library (shared, zlib, exceptions; no MPI) |
| `mfem@4.5`      | 4.5.2   | Finite element methods library (previous version) |
| `mvox`          | 1.0.0   | Mesh voxelizer for MFEM meshes (built against MFEM 4.9) |
| `mvox-mfem-4.5` | 1.0.0   | Mesh voxelizer for MFEM meshes (built against MFEM 4.5) |

## Installing MVox

Add the channel to `~/.config/guix/channels.scm`:

```scheme
(cons (channel
       (name 'mvox)
       (url "https://github.com/benzwick/guix-mvox")
       (branch "main"))
      %default-channels)
```

Then pull and install:

    guix pull
    guix install mvox
    mvox --help

## Building MVox from source

The channel can also provide build dependencies for building
[MVox](https://github.com/benzwick/mvox) from source.
See the [MVox README](https://github.com/benzwick/mvox#building-from-source)
for the latest build instructions and dependencies.

If the channel is already configured:

    guix shell --container -D mvox

Or from a local checkout of this repository:

    guix shell --container -L /path/to/guix-mvox -D mvox

The `--container` flag creates an
[isolated environment](https://guix.gnu.org/manual/en/html_node/Invoking-guix-shell.html)
so that only Guix-provided packages are visible,
preventing conflicts with system-installed libraries.
The container shares the current working directory with the host,
so run the command from a parent directory
that contains both the channel and the source tree.

The `-D` flag includes the dependencies of "the following package",
so it must come immediately before the package name.
When using `-L`, put it before `-D`.

### Example

Clone both repositories and start the shell from the parent directory
so that both are visible inside the container:

```sh
cd ~/projects/mvox
git clone https://github.com/benzwick/guix-mvox.git
git clone https://github.com/benzwick/mvox.git
guix shell --container -L guix-mvox -D mvox
```

Inside the container, the working directory is `~/projects/mvox`.
Build with cmake and make:

```sh
cd mvox
cmake -B build
make -C build -j$(nproc)
./build/mvox --help
```

The [Guix Shell CI workflow](.github/workflows/guix-shell.yml)
demonstrates the full build and test process.
The CI runs each step with `guix shell -L . -D mvox --`
rather than an interactive container because GitHub Actions steps
run independently and cannot share a persistent shell session.

## Development

Build from a local checkout without adding the channel:

```sh
guix build -L . mfem
guix build -L . mvox
```

Lint packages:

```sh
guix lint -L . mfem mvox
```

## 3D Slicer integration

This channel is designed to be composed with
[guix-systole](https://github.com/SystoleOS/guix-systole) to build a
[3D Slicer](https://www.slicer.org) custom application with MVox as a
loadable C++ module. This integration is planned for a future release.

### How it will work

The guix-systole channel packages 3D Slicer and its full dependency tree
(VTK, ITK, CTK, etc.) as individual Guix packages. External loadable modules
can be built against the installed Slicer development files and injected at
runtime via the Guix profile.

To use both channels together, combine them in
`~/.config/guix/channels.scm`:

```scheme
(cons* (channel
         (name 'systole)
         (url "https://github.com/SystoleOS/guix-systole.git")
         (branch "main"))
       (channel
         (name 'mvox)
         (url "https://github.com/benzwick/guix-mvox")
         (branch "main"))
       %default-channels)
```

A `slicer-mvox` package would build the MVox loadable module against Slicer's
installed development files (using `-DSlicer_DIR`), following the pattern
established by
[slicer-openigtlink](https://github.com/SystoleOS/guix-systole/blob/main/systole/systole/packages/openigtlink.scm).
The built `.so` files are symlinked into `lib/Slicer-5.8/SlicerModules/`,
where the Slicer wrapper picks them up automatically.

Installing would then be:

```sh
guix install slicer-5.8 slicer-mvox
```

### Current status

The guix-systole extension infrastructure is still being developed
(see [guix-systole#72](https://github.com/SystoleOS/guix-systole/issues/72),
[#73](https://github.com/SystoleOS/guix-systole/issues/73),
[#98](https://github.com/SystoleOS/guix-systole/pull/98)).
The `slicer-mvox` package will be added once the extension API is finalized.
