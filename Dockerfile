FROM quay.io/centos/centos:stream8

RUN dnf install -y which-2.21

RUN dnf install -y unzip-6.0

RUN dnf install -y groff-base-1.22.3

RUN dnf install -y curl-7.61.1

RUN dnf install -y python3-pip-9.0.3

RUN dnf install -y jq-1.6

RUN dnf install -y git-2.31.1

ADD files/google-cloud-sdk.repo /etc/yum.repos.d/google-cloud-sdk.repo
RUN dnf install -y google-cloud-sdk-398.0.0

RUN pip3 install awscli==1.24.10

ENV TERRAFORM_VERSION="1.0.5"

RUN true \
 && curl https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip -o terraform.zip \
 && unzip terraform.zip -d /usr/local/bin \
 && rm terraform.zip

ENV KUBE_VERSION="v1.21.8"

RUN true \
 && curl -L https://storage.googleapis.com/kubernetes-release/release/${KUBE_VERSION}/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl \
 && chmod +x /usr/local/bin/kubectl

ENV HELM_VERSION v3.7.0

RUN true  \
 && FILENAME=helm-${HELM_VERSION}-linux-amd64.tar.gz \
 && HELM_URL=https://get.helm.sh/${FILENAME} \
 && echo $HELM_URL \
 && curl -o /tmp/$FILENAME ${HELM_URL} \
 && tar -zxvf /tmp/${FILENAME} -C /tmp \
 && mv /tmp/linux-amd64/helm /bin/helm
