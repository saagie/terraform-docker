FROM quay.io/centos/centos:stream8

ADD files/google-cloud-sdk.repo /etc/yum.repos.d/google-cloud-sdk.repo

RUN dnf install git-2.31.1 curl-7.61.1 unzip-6.0 which-2.21 python3-pip-9.0.3 groff-base-1.22.3 google-cloud-sdk-369.0.0 -y \
    && pip3 install awscli==1.22.42

ENV TERRAFORM_VERSION="1.0.5"

RUN curl https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip -o terraform.zip \
 && unzip terraform.zip -d /usr/local/bin \
 && rm terraform.zip

ENV KUBE_VERSION="v1.21.8"

RUN curl -L https://storage.googleapis.com/kubernetes-release/release/${KUBE_VERSION}/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl \
 && chmod +x /usr/local/bin/kubectl

RUN curl -L https://amazon-eks.s3.us-west-2.amazonaws.com/1.21.2/2021-07-05/bin/linux/amd64/aws-iam-authenticator -o /usr/local/bin/aws-iam-authenticator \
 && chmod +x /usr/local/bin/aws-iam-authenticator

# Install Helm
ENV VERSION v3.7.0
ENV FILENAME helm-${VERSION}-linux-amd64.tar.gz
ENV HELM_URL https://get.helm.sh/${FILENAME}

RUN echo $HELM_URL

RUN curl -o /tmp/$FILENAME ${HELM_URL} \
   && tar -zxvf /tmp/${FILENAME} -C /tmp \
   && mv /tmp/linux-amd64/helm /bin/helm
