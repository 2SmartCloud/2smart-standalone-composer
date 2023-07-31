mkdir -p ~/.ssh

echo "$STAGE_KEY" | tr -d '\r' > ~/.ssh/id_rsa
chmod 700 ~/.ssh/id_rsa
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa
ssh-keyscan -H $STAGE_HOST >> ~/.ssh/known_hosts

NEW=$JOB_TOKEN

# scp deploy.sh $STAGE_USER@$STAGE_HOST:/home/$STAGE_USER
scp docker-compose.demo.yml $STAGE_USER@$STAGE_HOST:/home/$STAGE_USER/docker-compose.demo.yml
scp docker-compose.yml $STAGE_USER@$STAGE_HOST:/home/$STAGE_USER/system/releases/demo/docker-compose.yml
scp install_2smart.sh $STAGE_USER@$STAGE_HOST:/home/$STAGE_USER/install_2smart.sh
# ssh -tt $STAGE_USER@$STAGE_HOST env JOB_TOKEN=$JOB_TOKEN REGISTRY=$REGISTRY 'chmod +x ./deploy.sh && export CI_JOB_TOKEN='"'$JOB_TOKEN'"'; export CI_REGISTRY='"'$REGISTRY'"'; ./deploy.sh'
