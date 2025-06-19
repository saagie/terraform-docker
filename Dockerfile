FROM scaleway/cli:v2.40.0 as scw

FROM quay.io/centos/centos:stream9

RUN dnf install -y which-2.21

RUN dnf install -y unzip-6.0

RUN dnf install -y groff-base-1.22.4

RUN dnf install -y curl-minimal-7.76.1

RUN dnf install -y python3-pip-21.2.3

RUN dnf install -y jq-1.6

RUN dnf install -y git-2.39.3

ENV TERRAFORM_VERSION="1.7.5"

RUN curl https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip -o terraform.zip \
 && unzip terraform.zip -d /usr/local/bin \
 && rm terraform.zip

ENV KUBE_VERSION="1.31.0"

RUN curl -L https://storage.googleapis.com/kubernetes-release/release/${KUBE_VERSION}/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl \
 && chmod +x /usr/local/bin/kubectl

ENV HELM_VERSION="v3.18.3"

RUN FILENAME=helm-${HELM_VERSION}-linux-amd64.tar.gz \
 && HELM_URL=https://get.helm.sh/${FILENAME} \
 && echo $HELM_URL \
 && curl -o /tmp/$FILENAME ${HELM_URL} \
 && tar -zxvf /tmp/${FILENAME} -C /tmp \
 && mv /tmp/linux-amd64/helm /bin/helm

RUN curl https://rclone.org/install.sh | bash

COPY --from=scw /scw /usr/local/bin/