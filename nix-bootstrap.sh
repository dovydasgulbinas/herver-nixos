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

CONF="./configuration/${HOST}.nix"
HW="./hardware/${HOST}.nix"

cp /etc/nixos/configuration.nix $CONF
cp /etc/nixos/hardware-configuration.nix $HW


# Use sed to replace the old value with the new value
sed -i "s/networking\.hostName = \".*\";/networking\.hostName = \"$HOST\";/" $CONF
sed -i "s|\./hardware-configuration\.nix|\.$HW|" $CONF

sudo nix-channel --add https://github.com/nix-community/home-manager/archive/release-24.11.tar.gz home-manager
sudo nix-channel --update


echo "NixOS Rebuilding..."

# Rebuild, output simplified errors, log trackebacks
sudo THIS_HOSTNAME=$HOST nixos-rebuild switch -I nixos-config=configuration.nix &>nixos-switch.log || (cat nixos-switch.log | grep --color error && exit 1)


git add "$HW" "$CONF"
git commit -m "Added initial configuration for $HOST"

popd
