#!/usr/bin/bash

mkdir -p html-gen
cd html-gen

# download latest overall results

if [ ! -d os-test-results ]; then
	git clone https://gitlab.com/sortix/os-test-results
else
	cd os-test-results
	git pull
	cd ..
fi

cp -ra os-test-results/outcomes/* ../sysroot/usr/share/os-test/out/
rm -r ../sysroot/usr/share/os-test/out/managarm

# download latest managarm results from CI

LATEST_MANAGARM_URL=$(curl -s -H "Accept: application/vnd.github+json" $(curl -s -H "Accept: application/vnd.github+json" -H "Authorization: Bearer $GITHUB_TOKEN" "https://api.github.com/repos/managarm/managarm/actions/workflows/ci.yml/runs?branch=master&status=success&per_page=1" | jq -r ".workflow_runs.[0].artifacts_url") | jq -r '.artifacts[] | select(.name == "os-test-results-managarm-x86_64.tar.gz").archive_download_url')
echo ${LATEST_MANAGARM_URL}
curl -L -H "Authorization: Bearer $GITHUB_TOKEN" -o os-test-results-managarm-x86_64.tar.gz.zip ${LATEST_MANAGARM_URL}
unzip -u os-test-results-managarm-x86_64.tar.gz.zip
tar -xf  os-test-results.tar.gz

cp -r out/* ../sysroot/usr/share/os-test/out

make -C ../sysroot/usr/share/os-test OS=mlibc html
