import os
from notebook.auth import passwd

## Answer yes to any prompts.
c.JupyterApp.answer_yes = True

## Whether to allow the user to run the notebook as root.
c.NotebookApp.allow_root = True

#  Leading and trailing slashes can be omitted, and will automatically be added.
#c.NotebookApp.base_url = '/'

## The full path to an SSL/TLS certificate file.
#c.NotebookApp.certfile = ''

## The full path to a certificate authority certificate for SSL/TLS client
#  authentication.
#c.NotebookApp.client_ca = ''

## The default URL to redirect to from `/`
#c.NotebookApp.default_url = '/'

## Whether to enable MathJax for typesetting math/TeX
#  
#  MathJax is the javascript library Jupyter uses to render math/LaTeX. It is
#  very large, so you may want to disable it if you have a slow internet
#  connection, or for offline use of the notebook.
#  
#  When disabled, equations etc. will appear as their untransformed TeX source.
c.NotebookApp.enable_mathjax = True

## The IP address the notebook server will listen on.
c.NotebookApp.ip = '*'

## The directory to use for notebooks and kernels.
c.NotebookApp.notebook_dir = '/notebooks'

## Whether to open in a browser after starting. The specific browser used is
#  platform dependent and determined by the python standard library `webbrowser`
#  module, unless it is overridden using the --browser (NotebookApp.browser)
#  configuration option.
c.NotebookApp.open_browser = False

## Hashed password to use for web authentication.
#  
#  To generate, type in a python/IPython shell:
#  
#    from notebook.auth import passwd; passwd()
#  
#  The string should be of the form type:salt:hashed-password.
#c.NotebookApp.password = ''

if 'JUPYTER_PASSWORD' in os.environ:
    c.NotebookApp.password = passwd(os.environ['JUPYTER_PASSWORD'])
    del os.environ['JUPYTER_PASSWORD']

## The port the notebook server will listen on.
c.NotebookApp.port = int(os.getenv('JUPYTER_PORT', 3000))

## Token used for authenticating first-time connections to the server.
#  
#  When no password is enabled, the default is to generate a new, random token.
#  
#  Setting to an empty string disables authentication altogether, which is NOT
#  RECOMMENDED.
c.NotebookApp.token = ''

## The base name used when creating untitled directories.
c.ContentsManager.untitled_directory = 'New Folder'

## The base name used when creating untitled files.
c.ContentsManager.untitled_file = 'New File'

## The base name used when creating untitled notebooks.
c.ContentsManager.untitled_notebook = 'New Notebook'
