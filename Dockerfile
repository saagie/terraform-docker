FROM quay.io/centos/centos:stream9

RUN dnf install -y which-2.21

RUN dnf install -y unzip-6.0

RUN dnf install -y groff-base-1.22.4

RUN dnf install -y curl-minimal-7.76.1

RUN dnf install -y python3-pip-21.2.3

RUN dnf install -y jq-1.6

RUN dnf install -y git-2.39.3

ADD files/google-cloud-sdk.repo /etc/yum.repos.d/google-cloud-sdk.repo
RUN dnf install -y google-cloud-sdk-434.0.0

RUN pip3 install awscli==1.27.152

ENV TERRAFORM_VERSION="1.5.0"

RUN true \
 && curl https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip -o terraform.zip \
 && unzip terraform.zip -d /usr/local/bin \
 && rm terraform.zip

ENV KUBE_VERSION="v1.27.2"

RUN true \
 && curl -L https://storage.googleapis.com/kubernetes-release/release/${KUBE_VERSION}/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl \
 && chmod +x /usr/local/bin/kubectl

ENV HELM_VERSION v3.12.0

RUN true  \
 && FILENAME=helm-${HELM_VERSION}-linux-amd64.tar.gz \
 && HELM_URL=https://get.helm.sh/${FILENAME} \
 && echo $HELM_URL \
 && curl -o /tmp/$FILENAME ${HELM_URL} \
 && tar -zxvf /tmp/${FILENAME} -C /tmp \
 && mv /tmp/linux-amd64/helm /bin/helm
