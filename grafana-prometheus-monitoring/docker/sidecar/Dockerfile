
FROM public.ecr.aws/amazonlinux/amazonlinux:2
RUN yum -y install python3 jq && pip3 install awscli && yum clean all
WORKDIR /sidecar
COPY fetch-secrets.sh .
RUN chmod +x fetch-secrets.sh
CMD ["/sidecar/fetch-secrets.sh"]
