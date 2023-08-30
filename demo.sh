#! /bin/bash
# create an example project 
mkdir example-react-project

npx create-react-app example-react-project

cd example-react-project

# copy typescriptify.sh to the project
cp ../typescriptify.sh .

# run typescriptify.sh
echo "Running typescriptify.sh"
bash typescriptify.sh

echo "Removing typescriptify.sh"
rm typescriptify.sh

echo "This demo is over, are you finished? (y/n)"
read answer
case $answer in
    [yY] | [yY][eE][sS])
        echo "Great! Have a great day!"
        cd ..
        rm -rf example-react-project
        ;;
    [nN] | [nN][oO])
        echo "Well then, I hope you have a great day!"
        ;;
    *)
        echo "Sorry, I didn't understand"
        ;;
esac