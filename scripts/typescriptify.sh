#! /bin/bash

# change all js or jsx files to ts or tsx files in all directories and subdirectories
echo "Would you like your project to be typesafe? (y/n)"
read answer
case $answer in
    [yY] | [yY][eE][sS])
        echo "Great! Changing all js and jsx files to ts and tsx files"
        # exclude node_modules and build directories
        find . -type f -name "*.js" -not -path "./node_modules/*" -not -path "./build/*" -exec bash -c 'mv "$1" "${1%.js}.ts"' - '{}' \;
        find . -type f -name "*.jsx" -not -path "./node_modules/*" -not -path "./build/*" -exec bash -c 'mv "$1" "${1%.jsx}.tsx"' - '{}' \;

        echo "Would you like me to add a tsconfig.json file? (y/n)"
        read answer
        case $answer in
            [yY] | [yY][eE][sS])
                echo "Great! Adding a tsconfig.json file"
                touch tsconfig.json
                echo "{
        \"compilerOptions\": {
        \"target\": \"es5\",
        \"module\": \"commonjs\",
        \"lib\": [\"es2015\"],
        \"strict\": true,
        \"noImplicitAny\": true,
        \"strictNullChecks\": true,
        \"strictFunctionTypes\": true,
        \"strictPropertyInitialization\": true,
        \"noImplicitThis\": true,
        \"alwaysStrict\": true,
        \"noUnusedLocals\": true,
        \"noUnusedParameters\": true,
        \"noImplicitReturns\": true,
        \"noFallthroughCasesInSwitch\": true,
        \"esModuleInterop\": true,
        \"resolveJsonModule\": true,
        \"jsx\": \"react\",
        \"baseUrl\": \"./src\",
        \"paths\": {
            \"@/*\": [\"*\"]
        }
    },
    \"include\": [\"src/**/*\"],
    \"exclude\": [\"node_modules\", \"build\"]
}" >> tsconfig.json

                echo "Would you like me to add // @ts-nocheck to the top of all your files? (y/n)"
                read answer
                case $answer in
                    [yY] | [yY][eE][sS])
                        echo "Great! Adding // @ts-nocheck to the top of all your files"
                        # exclude node_modules and build directories
                        

                        # Define the text to insert
                        insert_text="// @ts-nocheck"

                        # Get the current directory
                        target_directory=$(pwd)

                        # Find all .js and .jsx files in the current directory and its subdirectories
                        find "$target_directory" -type f \( -name "*.ts" -o -name "*.tsx" \) ! -path "*/node_modules/*" ! -path "*/build/*" | while read -r file; do
                            # Check if the file is not in node_modules or build directory
                            # if [ ! -d "${file%/*}/node_modules" ] && [ ! -d "${file%/*}/build" ]; then
                                # Insert the text at the top of the file using a temporary file
                                temp_file=$(mktemp)
                                echo "$insert_text" > "$temp_file"
                                cat "$file" >> "$temp_file"
                                mv "$temp_file" "$file"
                                echo "Inserted text into: $file"
                            # fi
                        done

                        echo "Insertion complete."  
                        ;;
                    [nN] | [nN][oO])
                        echo "Well then, I hope you have a great day!"
                        exit 1
                        ;;
                    *)
                        echo "Sorry, I didn't understand"
                        exit 1
                        ;;
                esac
                ;;
            [nN] | [nN][oO])
                echo "Well then, I hope you have a great day!"
                ;;
            *)
                echo "Sorry, I didn't understand"
                exit 1
                ;;
        esac
        ;;
    [nN] | [nN][oO])
        echo "Well then, I hope you have a terrible day!"
        find . -type f -name "*.ts" -exec bash -c 'mv "$1" "${1%.ts}.js"' - '{}' \;
        find . -type f -name "*.tsx" -exec bash -c 'mv "$1" "${1%.tsx}.jsx"' - '{}' \;
        exit 1
        ;;
    *)
        echo "Sorry, I didn't understand"
        exit 1
        ;;
esac
