FROM centos:7

ADD files/google-cloud-sdk.repo /etc/yum.repos.d/google-cloud-sdk.repo

RUN yum install git curl unzip which python3-pip groff google-cloud-sdk -y \
    && pip3 install awscli

ENV TERRAFORM_VERSION="0.12.19"

RUN curl https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip -o terraform.zip \
 && unzip terraform.zip -d /usr/local/bin \
 && rm terraform.zip

ENV KUBE_VERSION="v1.15.4"

RUN curl -L https://storage.googleapis.com/kubernetes-release/release/${KUBE_VERSION}/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl \
 && chmod +x /usr/local/bin/kubectl

RUN curl -L https://amazon-eks.s3-us-west-2.amazonaws.com/1.13.8/2019-08-14/bin/linux/amd64/aws-iam-authenticator -o /usr/local/bin/aws-iam-authenticator \
 && chmod +x /usr/local/bin/aws-iam-authenticator

# Install Helm
ENV VERSION v2.14.2
ENV FILENAME helm-${VERSION}-linux-amd64.tar.gz
ENV HELM_URL https://storage.googleapis.com/kubernetes-helm/${FILENAME}

RUN echo $HELM_URL

RUN curl -o /tmp/$FILENAME ${HELM_URL} \
   && tar -zxvf /tmp/${FILENAME} -C /tmp \
   && mv /tmp/linux-amd64/helm /bin/helm
