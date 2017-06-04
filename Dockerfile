FROM python:alpine

RUN apk add bash coreutils jq --update
RUN pip install awscli

COPY scripts /awsinfo

ENTRYPOINT ["/awsinfo/awsinfo.bash"]

LABEL io.whalebrew.config.environment '["AWS_ACCESS_KEY_ID", "AWS_SECRET_ACCESS_KEY", "AWS_SESSION_TOKEN", "AWS_DEFAULT_REGION", "AWS_DEFAULT_PROFILE", "AWS_CONFIG_FILE", "AWSINFO_DEBUG"]'
LABEL io.whalebrew.config.volumes '["~/.aws:/.aws"]'