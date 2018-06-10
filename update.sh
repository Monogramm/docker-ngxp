#!/bin/bash
set -eo pipefail

declare -A base=(
	[jdk]='debian'
	[alpine]='alpine'
)

variants=(
	jdk
	alpine
)

dockerRepo="monogramm/docker-ngxp"

# Remove existing images
echo "reset docker images"
find ./images -maxdepth 1 -type d -regextype sed -regex '\./images/\.*' -exec rm -r '{}' \;

echo "update docker images"
travisEnv=

for variant in "${variants[@]}"; do
	echo "updating ngxp:$variant"

	# Create the variant directory with a Dockerfile.
	dir="images/$variant"
	mkdir -p "$dir"

	template="Dockerfile-${base[$variant]}.template"
	cp "$template" "$dir/Dockerfile"

	# Replace the variables.
	sed -ri -e '
		s/%%VARIANT%%/'"$variant"'/g;
	' "$dir/Dockerfile"

	travisEnv='\n    - VARIANT='"$variant$travisEnv"

	if [[ $1 == 'build' ]]; then
		tag="$variant"
		echo "Build Dockerfile for ${tag}"
		docker build -t ${dockerRepo}:${tag} $dir
	fi
done

# update .travis.yml
travis="$(awk -v 'RS=\n\n' '$1 == "env:" && $2 == "#" && $3 == "Environments" { $0 = "env: # Environments'"$travisEnv"'" } { printf "%s%s", $0, RS }' .travis.yml)"
echo "$travis" > .travis.yml
