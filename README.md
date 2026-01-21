# OSIRIS Utilities

This repository contains input decks, analysis scripts, Jupyter notebooks, and example configurations for working with OSIRIS. The file structure is as follows:

```bash

.
├── analysis/       # Contains all resources related to data analysis
│ ├── notebooks/    # Interactive Jupyter Notebooks (walkthroughs, basic analysis, etc.)
│ └── scripts/      # Automation scripts for analysis tasks
├── config/         # System- or compiler-specific configuration files for OSIRIS
├── decks/          # Collection of important and interesting input decks
├── jobex.sh        # Job batch script for running on the Great Lakes cluster at the University of Michigan
├── profile.osiris  # Shell script that loads required modules and sets up the environment
└── README.md		# Overview of the project, usage instructions, and documentation
```

# Installation and Setup
The official OSIRIS documentation doesn't include detailed instructions for every computing cluster. This repository attempts to fill in those gaps for systems that I've personally used.

If your cluster is *not* listed here, refer to the official OSIRIS documentation: [OSIRIS Documentation](https://osiris-code.github.io/documentation/)

Currently documented systems:

- [Great Lakes @ UofM](#great-lakes--uofm)

## Great Lakes @ UofM

### 1. Logging In

First, login to the Great Lakes cluster from your local machine:

```bash
ssh <yourid>@greatlakes.arc-ts.umich.edu
```

Once logged in, you're working in a **login** node. This is where you can compile code, edit files, and submit jobs (**not** where simulations actually run or where you should choose to store large amounts of data).

### 2. Setting Up Your Environment

OSIRIS depends on several external libraries (MPI, HDF5, FFTW, etc.). On Great Lakes, these are provided through the module system.

Create a file called ```profile.osiris``` and add the following lines:

```bash
module load intel
module load openmpi
module load hdf5
module load fftw
```

Every time you login and want to work with OSIRIS, run:

```bash
source profile.osiris
```

If you forget this step, these modules will not be loaded and compilation or execution will fail with confusing errors. Alternatively, you can remember which modules to load and do so every time you login to Great Lakes.

### 3. Downloading the OSIRIS Source Code

Clone the OSIRIS repository from GitHub:

```bash
git clone https://github.com/GoLP-IST/osiris.git
```

This only needs to be done once, unless you want to update to a newer version later. If you need access to the ```dev/``` branch for a newer version of the code, ask your advisor!

### 4. Configuring the Build

Before compiling, OSIRIS must be configured for:
- Your operating system/cluster
- The number of spatial dimensions (1D/2D/3D)

The general format is:

```bash
./configure [-h] [-s system] [-d dimension] [-t type]
```

**Example: Local MacOS (1D)**

```bash
./configure -s macosx.gfortran -d 1
```

**Example: Great Lakes (1D)**

```bash
./configure -s osiris_sys.greatlakes.intel -d 1
```

The ```-s``` flag selects a system-specific configuration file, and the ```-d``` flag sets the simulation dimensionality. If you later want to switch between 1D, 2D, or 3D, you must recompile the code.

### 5. Compiling OSIRIS

Once configured, you can compile the code by running:

```bash
make
```

This builds the default (production) version of the code. You can also explicitly choose the dimensions and build type:

```bash
make 1d production
make 2d production
make 3d production
```

For most users, **production** is what you want. The **debug** and **profile** builds are mainly for developers.

### 6. Running the Code

#### <ins>Input Files ("Decks")</ins>

OSIRIS simulations are controlled by text-based input files that are sometimes referred to as **input decks**.

If you are unfamiliar with the format, you can start here: [OSIRIS Documentation](https://osiris-code.github.io/documentation/input_format). 

An example input deck is provided in this repository under ```decks/base-wake-2d```. You can copy and modify this file for your own simulations.

#### <ins>Batch Scripts and Job Submission</ins>

On Great Lakes, simulations are run using **SLURM batch jobs**. You do *not* run OSIRIS directly on the login node.

The file ```jobex.sh``` is a fully working example batch script. You typically only need to edit the section marked:

```bash
########################################################################################
# EDIT BELOW HERE
########################################################################################
```

You'll likely need to change:
- ```DIMS```: simulation dimensionality (1D/2D/2D)
- ```INPUTFILE```: path to your input deck
- ```RUNTITLE```: optional label for your run
- ```DATA_DIR```: where simulation output will be stored

This script creates a new run directory, copies the OSIRIS executable and input file, and launches the simulation using MPI.

#### <ins>Submitting a Job</ins>

Once your batch script is ready, you can submit it with:

```bash
sbatch jobex.sh
```

SLURM will queue your job and run it when resources are available. You can monitor the job's status by just typing ```sq```.

