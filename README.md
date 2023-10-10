# Typesify

Convert your JavaScript code to TypeScript.

## How to use

run `npx typesify` in your project root directory.

To exclude files from being transformed use keyword `--exclude` followed by a comma separated list of glob patterns.
For example to exclude all files in `node_modules` and `dist` directories:
run `npx typesify --exclude **/node_modules/**,**/dist/**`

## How it works

1. Typesify converts all `.js` and `.jsx` files in your project to `.ts` and `.tsx` files respectively.
2. Typesify adds a `tsconfig.json` file to your project root directory.
3. Typesify adds `@ts-check` to the top of all `.ts` and `.tsx` files.

## Motivation
Converting a project at work to typescript, I thought instead of using all of the great packages out there, I would build one myself! It is a good enough starting point to migrate a Javascript React project to Typescript.
