#! /usr/bin/env node

const readline = require("readline");
const fs = require("fs");
const path = require('path');
const { promisify } = require("util");
const exec = promisify(require("child_process").exec);
const tsConfigContent = require("./default-tsconfig");
const inserter = require("./utils/inserter");
const yargs = require('yargs');

const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout,
  });

function askQuestion(question) {
    return new Promise((resolve) => {
      rl.question(question, (answer) => {
        resolve(answer);
      });
    });
};

const { argv } = yargs;

let excludedDirectories = ['node_modules', 'build', 'typescriptify', '.git', 'dist'];

if (argv.exclude) {
    const additionalExcluded = argv.exclude.split(',');

    // Remove duplicates
    additionalExcluded.forEach(directory => {
        if (!excludedDirectories.includes(directory)) {
            excludedDirectories.push(directory);
        }
    }
    );
    // excludedDirectories = excludedDirectories.concat(argv.exclude.split(','));
}

async function main() {
  try {
    const answer = await askQuestion(
      "Would you like your project to be typesafe? (y/n): "
    );
    if (answer.toLowerCase() === "y" || answer.toLowerCase() === "yes") {
      console.log("Great! Changing all js and jsx files to ts and tsx files");

      const excludeString = excludedDirectories.map(directory => `-not -path './${directory}/*'`).join(' ');

      // Replace js and jsx files with ts and tsx respectively
      await exec(
        `find . -type f -name '*.js' ${excludeString} -exec bash -c 'mv \"$1\" \"\${1%.js}.ts\"' - '{}' \\;`
      );
      await exec(
        "find . -type f -name '*.jsx' -not -path './node_modules/*' -not -path './build/*' -exec bash -c 'mv \"$1\" \"${1%.jsx}.tsx\"' - '{}' \\;"
      );

      const addTsConfig = await askQuestion(
        "Would you like me to add a tsconfig.json file? (y/n): "
      );
      if (
        addTsConfig.toLowerCase() === "y" ||
        addTsConfig.toLowerCase() === "yes"
      ) {
        console.log("Great! Adding a tsconfig.json file");
        fs.writeFileSync("tsconfig.json", tsConfigContent);

        const addTsNoCheck = await askQuestion(
          "Would you like me to add // @ts-nocheck to the top of all your files? (y/n): "
        );
        if (
          addTsNoCheck.toLowerCase() === "y" ||
          addTsNoCheck.toLowerCase() === "yes"
        ) {
          console.log(
            "Great! Adding // @ts-nocheck to the top of all your files"
          );

          const targetDirectory = process.cwd();

          const allowedExtensions = ['.ts', '.tsx'];
        
          function collectFiles(directory) {
            let fileList = [];
          
            const entries = fs.readdirSync(directory);
          
            entries.forEach(entry => {
              const entryPath = path.join(directory, entry);
              const stats = fs.statSync(entryPath);
          
              if (stats.isDirectory() && !excludedDirectories.includes(entry)) {
                const nestedFiles = collectFiles(entryPath);
                fileList = fileList.concat(nestedFiles);
              } else if (stats.isFile() && allowedExtensions.includes(path.extname(entry))) {
                fileList.push(entryPath);
              }
            });
          
            return fileList;
          }
          
          // Get all files in the target directory and its subdirectories
          const allFiles = collectFiles(targetDirectory);

            allFiles.forEach(file => {
                inserter(file).content(
                    "// @ts-nocheck"
                ).at(1).then(() => {
                    console.log(`Added // @ts-nocheck to ${file}`);
                });
            });
        } else {
          console.log("Well then, I hope you have a great day!");
        }
      } else {
        console.log("Well then, I hope you have a great day!");
      }
    } else {
      console.log("Well then, I hope you have a terrible day!");

      // Revert ts and tsx files back to js and jsx respectively
      await exec(
        "find . -type f -name '*.ts' -exec bash -c 'mv \"$1\" \"${1%.ts}.js\"' - '{}' \\;"
      );
      await exec(
        "find . -type f -name '*.tsx' -exec bash -c 'mv \"$1\" \"${1%.tsx}.jsx\"' - '{}' \\;"
      );
    }
  } catch (error) {
    console.error("An error occurred:", error);
  } finally {
    rl.close();
  }
}

main();
