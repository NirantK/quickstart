# Quick Wiki, Configs & Scripts


```bash
telepresence --swap-deployment faq-builder --also-proxy=10.13.0.0/16
python manage.py runserver 0.0.0.0:3000
```

## Starting a new notebook

https://towardsdatascience.com/how-to-automatically-import-your-favorite-libraries-into-ipython-or-a-jupyter-notebook-9c69d89aa343

```python
import json
import random
from pathlib import Path
from urllib.parse import quote_plus

%load_ext autoreload
%autoreload 2
Path.ls = lambda x: list(x.iterdir())
```

## convolib

```bash
export PROJECT="mach-learn"
gcloud config set project $PROJECT
export ZONE="asia-south1-b" # budget: "us-west1-b"
export INSTANCE_NAME="convolib"
export INSTANCE_TYPE="n1-standard-1"
gcloud compute instances start $INSTANCE_NAME --zone=$ZONE
gcloud compute ssh --zone=$ZONE jupyter@$INSTANCE_NAME -- -L 8080:localhost:8080
```

## Hindi2vec
```bash
export PROJECT="verloop-hindi2vec"
gcloud config set project $PROJECT
export IMAGE_FAMILY="pytorch-latest-gpu" # or "pytorch-latest-cpu" for non-GPU instances
export ZONE="asia-south1-b"
export INSTANCE_NAME="hack" # "hack" is not preemptible
# export ZONE="us-west2-b" # budget: "us-west1-b"
# export INSTANCE_NAME="ulmfit"
export INSTANCE_TYPE="n1-highmem-8"
gcloud compute instances start $INSTANCE_NAME --zone=$ZONE
gcloud compute ssh --zone=$ZONE jupyter@$INSTANCE_NAME -- -L 8080:localhost:8080
```

## Starting and Stopping the instance
```bash
gcloud compute instances start $INSTANCE_NAME --zone=$ZONE
gcloud compute instances stop $INSTANCE_NAME --zone=$ZONE
```

## Creating the Instance

```bash
# budget: 'type=nvidia-tesla-k80,count=1'
export PROJECT="mach-learn"
gcloud config set project $PROJECT
export IMAGE_FAMILY="pytorch-latest-gpu" # or "pytorch-latest-cpu" for non-GPU instances
export ZONE="asia-south1-b" # budget: "us-west1-b"
export INSTANCE_NAME="email-intel"
export INSTANCE_TYPE="n1-highmem-8"
gcloud compute instances create $INSTANCE_NAME \
        --zone=$ZONE \
        --image-family=$IMAGE_FAMILY \
        --image-project=deeplearning-platform-release \
        --maintenance-policy=TERMINATE \
        --accelerator="type=nvidia-tesla-t4,count=1" \
        --machine-type=$INSTANCE_TYPE \
        --boot-disk-size=200GB \
        --metadata="install-nvidia-driver=True" \
        # --preemptible
```


## Mongo Data Exports

```bash
# ssh into the secondary read replica
export INSTANCE_NAME="mongodb-chat-node-4"
export PROJECT="verloop-production"
export ZONE="us-central1-f"
gcloud compute ssh $INSTANCE_NAME --project=$PROJECT --zone=$ZONE

# dump a compressed db
export TENANT="nykaa" #replace nykaa with target tenant
export FNAME="db_archive_$(date +%Y%m%d)_$TENANT.archive" #filename
# export PARAMS="--db=default_chat --gzip --archive=$FNAME"
export PARAMS="--db=default_chat --collection messages --query {'_tenantId':'$TENANT'} --gzip --archive=$FNAME --readPreference secondary"
mongodump $PARAMS

# actually push to the gcs bucket
export TARGET_FOLDER="analytics"
gsutil cp $FNAME gs://verloop-production-db-exports/$TARGET_FOLDER
```

### Copy dump from Production to Dev Projects

*Important*: Exit to local where you have access to both production and dev

```bash
export FNAME="db_archive_$(date +%Y%m%d).archive" #filename
export TARGET_FOLDER="analytics"
gsutil cp gs://verloop-production-db-exports/$TARGET_FOLDER/$FNAME gs://verloop-prod-db-exports-in-dev/$TARGET_FOLDER/
```

### Restore Dump

```bash
export TENANT="milkbasket"
export FNAME="db_archive_20190624_$TENANT.archive" #filename
gsutil cp gs://chat-prod-exports/$FNAME .

# restore a compressed db
export PARAMS="--db=default_chat --gzip --archive=$FNAME"
mongorestore $PARAMS
```

## ssh and tunnel
```bash
gcloud compute ssh --zone=$ZONE jupyter@$INSTANCE_NAME -- -L 8080:localhost:8080
sudo /opt/anaconda3/bin/conda install -c fastai fastai
```

## Deleting the instance

```bash
gcloud compute instances delete $INSTANCE_NAME --zone=$ZONE --delete-disks=all
```

## Creating a symlink
To create a symlink at /usr/bin/bar which references the original file /opt/foo, use:
ln -s /opt/foo /usr/bin/bar

For our use case:
sudo ln -s /home/jupyter/ulmfit-multilingual/data/wiki/hi-all /home/jupyter/hindi2vec/hi-all

sudo ln -s /home/jupyter/ulmfit-multilingual/data/wiki/hi-all-unk /home/jupyter/hindi2vec/hi-all-unk


python create_wikitext.py -i data/wiki_extr/hi -o data/wiki/hi -l hi
python postprocess_wikitext.py data/wiki/hi-100 hi

sudo apt-get install mysql-server
sudo apt-get install libmysqlclient-dev

## ssh directly without gcloud
ssh -i google_compute_engine -R 52698:localhost:52698 nirant@35.200.194.133

## zsh
sudo apt install zsh
chsh -s $(which zsh)
sh -c "$(wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"

gcloud compute ssh varys-vm --zone=asia-south1-b

## Fixes for gensim installation bugs
sudo apt-get -y install gcc
sudo apt-get -y update
sudo apt-get -y install --reinstall build-essential

## Get the Miniconda and basic dependencies used at Verloop
wget -c https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh
conda --version
pip install structlog
pip install python-json-logger

curl -s https://packagecloud.io/install/repositories/datawireio/telepresence/script.deb.sh | sudo bash
sudo apt install --no-install-recommends telepresence
cd telepresence

python -m spacy download en
python -m nltk.downloader punkt
pip install fire


### Known Error
```
ModuleNotFoundError: No module named 'google_compute_engine'
```
Fix? 
```bash
sudo rm -f /etc/boto.cfg
```

## Rasa Commands
```bash
tmux new -s rasa
python -m rasa_nlu.server -c sample_configs/config_sentence_classifier.json
```
Then, ctrl+b; d to detach from that session

To attach the session again
```bash
tmux attach -t rasa  
```
Use hostnamectl to find host info like operating system
Use nproc --all to find number of vCPUs on your system

sudo apt install ranger

Add logging based on syntax here: https://github.com/verloop/api/blob/master/py/verloop/utils/logger.py

pip install locustio
locust -f scripts/api_loadtest.py --csv=benchmark --no-web -c 100 -r 10 --host=http://localhost:5000
-c specifies the number of Locust users to spawn, and -r specifies the hatch rate (number of users to spawn per second).

locust -f api_loadtest.py --csv=api_loadtest --no-web -c 1000 -r 20 -t5m --host=http://10.13.0.29:8000
locust -f api_loadtest.py --csv=api_loadtest --no-web -c 100 -r 10 -t5m --host=http://10.160.0.5:8000

{'project': "hello_again", 'model': "model_20190117-083752", 'q': "send email now or dont sent anytime soon"}
'intent_suggestions': kwargs.get('intent_suggestions', [])}

## Setting up Livegrep:
sudo apt-get install pkg-config zip g++ zlib1g-dev unzip
wget -c https://github.com/bazelbuild/bazel/releases/download/0.21.0/bazel-0.21.0-installer-linux-x86_64.sh

## ssh keep-alive
https://patrickmn.com/aside/how-to-keep-alive-ssh-sessions/

# vim
:set paste 
-- to paste with proper indenting in Python
set tabstop=4 shiftwidth=4 expandtab

