#!/bin/bash

# Get all submodule configurations and convert HTTPS to SSH URLs
git config --file .gitmodules --get-regexp '^submodule\..*\.url$' | \
while read -r key url; do
    # Extract the submodule name from the key
    name=$(echo "$key" | sed 's/submodule\.\(.*\)\.url/\1/')
    
    # Convert HTTPS to SSH URL format
    ssh_url=$(echo "$url" | sed 's|https://github.com/|git@github.com:|')
    
    # Configure the SSH URL locally
    git config submodule."$name".url "$ssh_url"
    echo "Configured $name to use SSH: $ssh_url"
done

echo "SSH URLs configured for all submodules"

echo -e "\nCurrent git config for submodules:"
git config --local --get-regexp '^submodule\.'

echo -e "\nTo view all git config settings use:"
echo "git config --list --show-origin"
