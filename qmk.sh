#/bin/sh

CONTAINER_CMD="sudo podman" #otherwise we run into dfu issues
EXEC="$CONTAINER_CMD exec -ti qmk fish"


$CONTAINER_CMD run -it --privileged \
  -v $HOME/.ssh:/root/.ssh:z \
  -v /dev:/dev \
  --name qmk \
  nichtsfrei/qmk:latest || \
     $EXEC || \
    ($CONTAINER_CMD start qmk && $EXEC)
