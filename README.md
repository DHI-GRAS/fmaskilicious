# fmaskilicious

Orchestrate FMask 4.0 cloud masking 🍭

## Installation

1. [Download FMask 4.0 standalone installer](https://drive.google.com/file/d/1--xhPuTsYvxKimSuuAAVmExsvqaKPX1c/view?usp=sharing)
   and copy it into the root of this repository.

2. Run

   ```bash
   $ docker build -t fmask .
   ```

   from the root of this repository.


## Usage

To process a Sentinel 2 scene (e.g. `S2A_MSIL1C_20180624T103021_N0206_R108_T33UUB_20180624T160117`)
that is located on your PC run

```bash
$ docker run \
    -v /path/to/safe:/mnt/input-dir:ro \
    -v /path/to/output:/mnt/output-dir:rw \
    -it fmask \
    S2A_MSIL1C_20180624T103021_N0206_R108_T33UUB_20180624T160117 *T33UUB*
```

Note that the folder mounted at `/mnt/input-dir` needs to contain the SAFE folder with the given
scene ID (in this case `S2A_MSIL1C_20180624T103021_N0206_R108_T33UUB_20180624T160117.SAFE`).
The second argument is a glob pattern matching the granules to be processed (`*` to process all granules).

Results are written to the folder mounted on `/mnt/output-dir` (one per granule).