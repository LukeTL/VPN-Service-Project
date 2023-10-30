# Boto wrongly installed
FROM registry.gitlab.com/gitlab-org/terraform-images/branches/v1-6-0-1.5:f158d31c1356d14029d8285ddd4b79ebbe6d7e90

RUN apk add \
    python3 \
    py3-pip \
    ansible

RUN pip3 install boto3 boto


