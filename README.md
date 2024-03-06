# scripts
This is (or will be) a collection of scripts that make my everyday workflow easier.

Currently it's only for me, this is a public repository so I can download the scripts easily on any machine without logging in into GitHub. 
Maybe someday I will provide a more thorough `README` with detailed usage information of this repo.

## Some rules for scripting
- All scripts should use `#!/bin/bash`. Avoiding bashisms will bring a lot of overhead and difficuly into scripting and I'm not planning using those scripts in environments that don't have `bash`.
- No hardcoding. Also try using as few environment variables as possible (e.g. from `$HOME/.env`).
- Avoid storing sensitive data in plain text files. If a secret is used by any of the scripts, this secret should be kept in [`pass`](https://www.passwordstore.org/) and the user should be propted for a password.
- If a script is calling another script or tool, the user should be informed about this, e.g. a message like `Executing command: command --long-option=something arg1` should be displayed.


## Initial goals

- [ ] Provide examples/templates for common parts of an `sh` script like:
    - [ ]  argument parsing (short options, long options and positional arguments)
    - [ ]  printing which checks `--quiet`, `--verbose` or `--very-verbose` flags, think of them like log-levels
    - [ ]  display quick usage docs with `--help`
    - [ ]  display `script-name [options] args` one-liner description when the script exits with an error
    - [ ]  pretty-printing setup with colors
- [ ] Gather the above in a sample script that can be cloned and used as a template + oneliner `curl` command which downloads the template

## Future script ideas

### Wrappers for `kubectl` commands
Build a set of wrapper scripts around common `kubectl` + `awscli` commands that are context/profile aware:
- [ ] The profiles/contexts should be parsed from `~/.kube/config` or `~/.aws/config`
- [ ] These scripts should be chainable (by calling each other) to achieve something more complex, e.g:
    - Getting a secret from a k8s secret-store in a `dev` cluster (`dev` is only a reference to a cluster-name or context that is a lot longer):
        1. Check somehow if the user has access to `dev` cluster: check if the `$HOME/.aws/credentials` file contains a token OR use `aws sts get-caller-identity` OR something similar
        2. If user has no access to `dev` cluster, acquire access
        3. Switch k8s context
        4. Get the secret using `kubectl get secret name-of-the-secret-store -o jsonpath='{.path.to.secret}' | base64 -d`
    - All of these steps should be done by a wrapper script and the one should call the next one and pass the relevant args, like the short reference (`dev`) to the context.
- [ ] The point would be to have a **simple** oneliner for `kubectl` commands and the oneliner should be controllable easily with a positional argument that specifies the context in a short form (e.g `dev` instead of `very-long-k8s-dev-context-name-that-is-hard-to-remember`)

### Prepare variables for `hurl` requests
Tool which prepares variables for [hurl](https://hurl.dev/) requests in version controlled API collections which are structured into folders.
`.env-.*` files in the file tree (from API collection repo root to 'leaf' folders) should be parsed for variables and those variables should be dumped into `request.variables` files inside 'leaf' folders of the folder structure.
- [ ] sensitive data should be handled in a secure way (e.g. it should not come from `.env-.*` files, it should not be in the repo)
- [ ] `request.variables` files should be added to `.gitignore` automatically 

