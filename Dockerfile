FROM hashicorp/terraform:0.12.5

ENV KUBE_LATEST_VERSION="v1.15.1"

RUN apk --update add curl

RUN curl -L https://storage.googleapis.com/kubernetes-release/release/${KUBE_LATEST_VERSION}/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl \
 && chmod +x /usr/local/bin/kubectl

RUN curl -L https://amazon-eks.s3-us-west-2.amazonaws.com/1.11.5/2018-12-06/bin/linux/amd64/aws-iam-authenticator -o /usr/local/bin/aws-iam-authenticator \
 && chmod +x /usr/local/bin/aws-iam-authenticator

# Install Helm
ENV VERSION v2.14.2
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

RUN apk add aws-cli --repository http://dl-3.alpinelinux.org/alpine/edge/testing/
RUN apk upgrade python3 --repository http://dl-3.alpinelinux.org/alpine/edge/main/
