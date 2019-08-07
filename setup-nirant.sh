git config --global user.name "NirantK"
git config --global user.email "nirant.bits@gmail.com" 
git config --global credential.helper "cache --timeout=3600"
echo "git config done. Starting code & dev env config"

# Setting up my programming basics
pip install black isort pipreqs ranger-fm

# conda install pytorch torchvision cudatoolkit=10.0 -c pytorch

# vim binding for Jupyter
mkdir -p $(jupyter --data-dir)/nbextensions
# Clone the repository
cd $(jupyter --data-dir)/nbextensions
git clone https://github.com/lambdalisue/jupyter-vim-binding vim_binding
# Activate the extension
jupyter nbextension enable vim_binding/vim_binding
echo "Enabled: Vim Binding for Jupyter"

# isort for Jupyter
pip install jupyter_contrib_nbextensions
jupyter nbextension install https://github.com/benjaminabel/jupyter-isort/archive/master.zip --user
jupyter nbextension enable jupyter-isort-master/jupyter-isort
echo "Enabled: isort for Jupyter"

# black for jupyter
jupyter nbextension install https://github.com/drillan/jupyter-black/archive/master.zip --user
jupyter nbextension enable jupyter-black-master/jupyter-black
echo "Enabled: black for Jupyter"

echo "Setting up Kubectl"
sudo apt-get install -y kubectl
gcloud container clusters get-credentials default
echo "Hoorah. All Done. Check for Errors though :)"
