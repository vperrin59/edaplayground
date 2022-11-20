docker run \
  --name ubuntu_eda_playground \
  -it \
  -e EDA_LOGIN=$EDA_LOGIN \
  -e EDA_TOKEN=$EDA_TOKEN \
  -e EDA_HEADLESS=true \
  --entrypoint ./env.sh \
  -v /$(pwd)://work \
  -w //work \
  ubuntu