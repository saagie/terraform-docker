FROM hashicorp/terraform:0.11.12

ENV KUBE_LATEST_VERSION="v1.13.3"

RUN curl -L https://storage.googleapis.com/kubernetes-release/release/${KUBE_LATEST_VERSION}/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl \
 && chmod +x /usr/local/bin/kubectl

RUN curl -L https://amazon-eks.s3-us-west-2.amazonaws.com/1.11.5/2018-12-06/bin/linux/amd64/aws-iam-authenticator -o /usr/local/bin/aws-iam-authenticator \
 && chmod +x /usr/local/bin/aws-iam-authenticator

# Install Helm
ENV VERSION v2.11.0
ENV FILENAME helm-${VERSION}-linux-amd64.tar.gz
ENV HELM_URL https://storage.googleapis.com/kubernetes-helm/${FILENAME}

RUN echo $HELM_URL

RUN curl -o /tmp/$FILENAME ${HELM_URL} \
   && tar -zxvf /tmp/${FILENAME} -C /tmp \
   && mv /tmp/linux-amd64/helm /bin/helm \
   && rm -rf /tmp

RUN apk --update add git bash

# Install Helm plugins
RUN helm init --client-only
RUN helm plugin install https://github.com/nouney/helm-gcs


RUN mkdir -p ~/.terraform.d/plugins/ \
    && curl -L https://github.com/lawrencegripper/terraform-provider-kubernetes-yaml/releases/download/v0.1.45/terraform-provider-k8sraw-linux-386 -o ~/.terraform.d/plugins/terraform-provider-k8sraw \
    && chmod +x ~/.terraform.d/plugins/terraform-provider-k8sraw
