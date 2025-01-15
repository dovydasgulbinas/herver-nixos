#!/bin/bash
# cd to your config dir
pushd ~/dotfiles

echo "Please enter hostname for this machine:"
read HOST

# Function to check if input is a valid yes/no response
is_valid_response() {
    local input="$1"
    [[ "$input" =~ ^(y|yes|n|no|Y|YES|N|NO)$ ]]
}

# Prompt the user for yes/no input
while true; do
    read -p "Do you want to continue with the host name $HOST ? (y/n): " response

    if is_valid_response "$response"; then
        # Normalize input to lowercase
        response=$(echo "$response" | tr '[:upper:]' '[:lower:]')
        if [[ "$response" == "y" || "$response" == "yes" ]]; then
            echo "Using $HOST"
        else
            echo "You chose no!"
        fi
        break
    else
        echo "Invalid input. Please enter 'y', 'yes', 'n', or 'no'."
    fi
done


cp /etc/nixos/configuration.nix "./configuration/$HOST"
cp /etc/nixos/hardware-configuration.nix "./hardware/$HOST"

# Define the new value in a variable
new_value="desired-new-value"

# Use sed to replace the old value with the new value
sed -i "s/networking\.hostName = \".*\";/networking\.hostName = \"$HOST\";/" ./configuration/$HOST.nix


git add "./host/$HOST" "./hardware/$HOST"
git commit -m "Added initial configuration for $HOST"

popd
