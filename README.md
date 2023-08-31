# Typesify

Convert your JavaScript code to TypeScript.

## How to use

run `npx typesify` in your project root directory.

To exclude files from being transformed use keyword `--exclude` followed by a comma separated list of glob patterns.
For example to exclude all files in `node_modules` and `dist` directories:
run `npx typesify --exclude **/node_modules/**,**/dist/**`
