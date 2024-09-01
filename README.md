# Code summary generator

## Installation

This application scans NPM-packages for possibly malicious behavior using
CodeQL. The queries were designed after analyzing malicious packages discovered
by prior research:
[Maloss](https://github.com/osssanitizer/maloss) and [Backstabbers Knife Collection](https://github.com/cybertier/Backstabbers-Knife-Collection)

### Prerequisites

1. Ensure that Python 3 and [CodeQL](https://codeql.github.com/) are installed
   on your system.
2. Ensure that the CodeQL executable is added to your system's PATH to make it
   accessible from the command line.
3. Verify installation with this command:

   ```bash
   codeql --version
   ```

   You should see the installed CodeQL version.

### Install Dependencies

Setup python virtual environment (optional):

```sh
python -m venv venv
```

Install python requirements:

```sh
pip install -r requirements.txt
```

Install CodeQL dependencies:
```bash
cd queries && codeql pack install && cd ..
```

## Usage

You can run the application by executing the `main.py` file.

You can get a list of all options by adding the `-h` flag:

```bash
./main.py -h
```

You can specify a path to an NPM-package with the `-s` flag or use the `-p` flag
followed by the package name to automatically download the package from the
NPM registry:

```bash
# use local package
./main.py -s PATH_TO_NPM_PACKAGE
# download from NPM
./main.py -p PACKAGE_NAME
```

**Examples:**

```bash
# generate behavior summary in markdown format and save it as summary.md
./main.py -p PACKAGE_NAME -f markdown -o summary.md
# generate behavior summary in pdf format and save it as summary.md
# override summary.pdf if it already exists
./main.py -s LOCAL_PKG -f pdf -o summary.pdf --force
```

## Adding your own queries

The application was designed to be easily expandable.\
If you want to add some queries on your own, create a `.ql` file in the `queries`
directory. The name of the file should be the id. \
The application displays results based on the metadata information in the `.ql`
file. Here is a minimal example:

```ql
/**
 * @name Datacollection of ENV-Variables
 * @description Package sends a network request, which includes environment variables
 * @id datacollection-env
 */
```

Every query should have a corresponding test in the `tests` directory.
To create a test, add a new folder with the id of your query as a name.
Inside the folder create an NPM project, which includes the behavior your
query tests for.

To execute all tests run the application with the `-t` flag:

```sh
./main.py -t
```

## Troubleshooting

### Shortened code in generated documents

Sometimes the application references code which is shortened,
for example: `fetch(' ... .com/')`. This behavior is due to
the `toString()` function of CodeQL for javascript. At the
time of writing this can unfortunately not be adjusted.
But there are some patched versions of CodeQL, which can
fix this behavior.
