================================================================================
 2022-08-05
 Bob Steagall
 KEWB Computing
================================================================================
This is the README file for the KEWB GCC 12.X.0 build scripts.  In the following
text, the version numbers will be referred to as 12.X.0 or 12X0, depending on
the usage and context.  The 'X' refers to GCC's minor version number; e.g., if
'X' is '2', then you intend to build, install, and use GCC 12.2.0.

In order to run these scripts, the following prerequisites must be installed:
 a. lsb_release on Linux
 b. the typical GNU software development and build tools

--------------------------------------------
1. SCRIPTS THAT PROVIDE CUSTOM BUILD OPTIONS

  * gcc-build-vars.sh - This very important script sets critical environment
    variables that are used by all the other scripts.  The first few variables
    can be modified; if you think you want to modify some of these variables,
    follow the directions in the script file.


----------------------------------------------------
2. TOP-LEVEL SCRIPTS THAT PERFORM HIGH-LEVEL ACTIONS

  * build-gcc.sh - This script will perform an entire build of GCC.  It does
    so by running fetch-gcc.sh, unpack-gcc.sh, configure-gcc.sh, make-gcc.sh,
    and the test scripts, in that order.

  * stage-gcc.sh - This script installs GCC into a staging location specified
    by the build variables script (gcc-build-vars.sh).  This is normally in
    the ./dist subdirectory, which serves as the staging area for creating a
    TGZ (compressed tarball) file and/or an RPM file.

  * pack-gcc.sh - This script creates a compressed tarball of compiler files
    installed into the staging directory by the stage-gcc.sh script.  The
    resulting TGZ file will be in the ./packages subdirectory.

  * install-gcc-tarball.sh - This script unpacks the TGZ file created by the
    packing script (pack-gcc.sh) into the directory structure specified in
    the build variables script (gcc-build-vars.sh).

  * make-gcc-rpm.sh - This script creates an RPM of the compiler files
    installed into the staging directory by the stage-gcc.sh script.  The
    resulting RPM file will be in the ./packages subdirectory.


-----------------------------------------------------
3. SECOND-LEVEL SCRIPTS THAT PERFORM BASIC OPERATIONS

This set of scripts performs several basic operations that are part of the
build process.  Each operation is a distinct step in that process.

  * fetch-gcc.sh - This script downloads the required source tarballs from
    GNU mirror sites

  * unpack-gcc.sh - This script unpacks the tarballs, places everything in
    the correct relative locations, and then performs any required patching.

  * configure-gcc.sh - This script runs GCC's configure script from within
    the build subdirectory.  It sets several key options for building GCC,
    including some that are specified by the environment variables set in
    gcc-build-vars.sh.

  * make-gcc.sh - This script makes GCC from within the build subdirectory.
    It runs with -j8 (i.e., up to 8 parallel processes); you can change this
    value by modifying the GCC_BUILD_THREADS_ARG variable defined in the
    gcc-build-vars.sh script described above.

  * clean-gcc.sh - This script deletes the source, build, install staging,
    and package output directories.


--------------------------------------------
4. HOW TO BUILD GCC 12.X.0 WITH THESE SCRIPTS

(NB: In the directions below, remember to replace the 'X' with the minor
version number!)


The process is pretty simple:

 a. Clone the git repo and checkout the gcc12 branch.

    $ cd <build_dir>
    $ git clone https://github.com/BobSteagall/gcc-builder.git
    $ cd <build_dir>/gcc-builder
    $ git checkout gcc12

 b. Customize the variables exported by gcc-build-vars.sh.  In particular,
    you will need to customize the first variable at the top of that file,
    GCC_VERSION, to select the specific version of GCC 12 to download and
    build.

    $ vi ./gcc-build-vars.sh

 c. Run the build-gcc.sh script.

    $ ./build-gcc.sh | tee build.log

    This command will build GCC and run the various test suites that come
    with the distribution.

    To build without running the test suites, you can use:

    $ ./build-gcc.sh -T | tee build.log

d. If the build succeeds, and you are satisfied with the test results, run
    the stage-gcc.sh script to create the installation staging area.

    $ ./stage-gcc.sh

 e. If you want to create a tarball for subsequent installations:

    $ ./pack-gcc.sh

    The resulting tarball will be in the ./packages subdirectory.  To install
    the tarball:

    $ sudo ./install-gcc-tarball.sh

    or, alternatively:

    $ sudo tar -zxvf ./gcc-builder/kewb-gcc12X0*.tgz -C /

    If you are satisfied that everything is working correctly, then at some
    point you may want to set ownership of the un-tarred files to root
    (substitute the values of GCC_INSTALL_PREFIX and GCC_INSTALL_SCRIPTS_PREFIX
    that you defined in gcc-build-vars.sh):

    $ sudo chown -R root:root $GCC_INSTALL_PREFIX
    $ sudo chown root:root $GCC_INSTALL_SCRIPTS_PREFIX/*gcc12X0*

 f. If you want to create an RPM for subsequent installations:

    $ ./make-gcc-rpm.sh -v

    The resulting RPM will be in the ./packages subdirectory.  Install it
    using RPM or YUM on the command line.

 g. That's it!

IMPORTANT WARNING:

If you want to rebuild GCC 12.X.0 after having built and installed it according
to these directions, AND you built with a custom binutils, AND you plan to
install the rebuilt version in the same location as its predecessor, then it
is imperative that you first perform exactly one of the following three actions:

  a. Delete the installation directory, for example:

    $ rm -rf /usr/local/gcc/12.X.0

  --OR--

  b. Rename the installation directory, for example:

    $ mv /usr/local/gcc/12.X.0 /usr/local/gcc/12.X-old

  --OR--

  c. Rename the custom 'as' and 'ld' exectuables, for example:

    $ cd /usr/local/gcc/12.X.0/libexec/gcc/x86_64-kewb-linux-gnu/12.X.0
    $ mv as as-old
    $ mv ld ld-old

Otherwise, the configure portion of the build process will find the custom
'as' and 'ld' executables in the GCC 12.X.0 directory structure, and build
the 'crtbeginS.o' startup file in a way that is likely to be incompatible
with your system's default linker.

It is _critical_ that the compilation of GCC itself takes place using your
system's default binutils, and not the custom 'as' and 'ld' that are
installed in the GCC 12.X.0 directory structure.


---------------------------------------------
5. HOW TO USE THE KEWB CUSTOM GCC 12.X.0 BUILD

Before using the compiler, some paths need to be set.  The simplest way to do
this is source the "setenv-for-gcc12X0.sh" script that is installed.

 a. Source the script /usr/local/bin/setenv-for-gcc-12X0.sh, which was installed
    in step 4.e or 4.f above.  For example,

        $ source /usr/local/bin/setenv-for-gcc12X0.sh

-- OR --

 a. You will need to modify your PATH environment variable so that the
    directory $GCC_INSTALL_DIR/bin appears before the directory where your
    system default compiler is installed (which is usually in /usr/bin or
    /usr/local/bin).  For example,

        $ export PATH=/usr/local/gcc/12.X.0/bin:$PATH

 b. You will also need to modify your LD_LIBRARY_PATH environment variable so
    that the $GCC_INSTALL_PREFIX/lib and $GCC_INSTALL_PREFIX/lib64 directories
    appear first in the path.  For example,

        $ export LD_LIBRARY_PATH=/usr/local/gcc/12.X.0/lib:\
          /usr/local/gcc/12.X.0/lib64:$LD_LIBRARY_PATH
