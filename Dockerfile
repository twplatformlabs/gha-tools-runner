# hadolint ignore=DL3007
FROM ghcr.io/twplatformlabs/runner-base-image:latest

SHELL ["/bin/bash", "-exo", "pipefail", "-c"]

ENV DEBIAN_FRONTEND=noninteractive \
    TERM=dumb \
    PAGER=cat \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8

# hadolint ignore=DL3004,DL3007,DL3008,SC2174
RUN echo 'APT::Get::Assume-Yes "true";' > /etc/apt/apt.conf.d/90circleci && \
    echo 'DPkg::Options "--force-confnew";' >> /etc/apt/apt.conf.d/90circleci && apt-get update && \
    apt-get install --no-install-recommends -y \
            nodejs \
            npm && \
    apt-get clean && rm -rf /var/lib/apt/lists/* && \
    download_url=$(curl -s "https://api.github.com/repos/hadolint/hadolint/releases/latest" | jq -r ".assets[] | select(.name == \"hadolint-linux-x86_64\") | .browser_download_url") && \
    curl -LO "${download_url}" && \
    chmod +x hadolint-linux-x86_64 && mv hadolint-linux-x86_64 /usr/local/bin/hadolint && \
    curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b /usr/local/bin && \
    curl -sSfL https://raw.githubusercontent.com/anchore/syft/main/install.sh | sh -s -- -b /usr/local/bin && \
    contains_url=$(curl -s "https://api.github.com/repos/oras-project/oras/releases/latest" | jq -r ".assets[] | select(.name | contains(\"_linux_amd64.tar.gz.asc\")) | .browser_download_url") && \
    download_url="${contains_url::-4}" && curl -L -o oras.tar.gz "${download_url}" && \
    mkdir -p oras-install && \
    tar -zxf oras.tar.gz -C oras-install/ && \
    mv oras-install/oras /usr/local/bin/ && \
    rm -rf ./oras.tar.gz oras-install/ && \
    download_url=$(curl -s "https://api.github.com/repos/sigstore/cosign/releases/latest" | jq -r ".assets[] | select(.name == \"cosign-linux-amd64\") | .browser_download_url") && \
    curl -LO "${download_url}" && \
    chmod +x cosign-linux-amd64 && mv cosign-linux-amd64 /usr/local/bin/cosign && \
    curl -sSfL https://raw.githubusercontent.com/anchore/grype/main/install.sh | sh -s -- -b /usr/local/bin

    # sudo chown -R root:root /usr/local/lib/node_modules && \