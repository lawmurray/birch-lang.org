    birch build [options]

Build the project.

Options:

  - `--enable-unity` / `--disable-unity` : Enable/disable unity build (default: disabled). A unity build is typically faster from a clean state, but does not support incremental builds (i.e. a change to any file will trigger a full rebuild).
  - `--enable-warnings` / `--disable-warnings` : Enable/disable warnings (default: enabled).
  - `--enable-debug` / `--disable-debug` : Enable/disable debug mode (default: enabled).
  - `--enable-verbose` / `--disable-verbose` : Verbose mode (default: enabled).
  - `--prefix` : Installation prefix (default: platform-specific).
  - `--arch=[native|js|wasm]` : Target architecture (default: `native`). Valid options are `native` for the architecture of the current machine, `js` for JavaScript or `wasm` for WebAssembly. The latter two require the Emscripten compiler.

The following three options are analogous to their counterparts for a C/C++ compiler, and specify the locations in which the Birch compiler should
search for headers (both Birch and C/C++ headers), installed libraries and
installed data files. They may be given multiple times to specify multiple
directories in the order in which they are to be searched.

  - `--include-dir` : Add search directory for header files.
  - `--lib-dir` : Add search directory for library files.
  - `--share-dir` : Add search directory for data files.

After searching these directories, the Birch compiler will search the environment variables `BIRCH_INCLUDE_PATH`, `BIRCH_LIBRARY_PATH` and `BIRCH_SHARE_PATH`, followed by the directories of the compiler's own installation, followed by the system-wide locations `/usr/local/` and
`/usr/`.
