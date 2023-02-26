Windows 11
==========

Install Sphinx to work on this project
--------------------------------------

::

    PS C:\Users\kleyfl> winget install Python.Python.3.11
    Found Python 3.11 [Python.Python.3.11] Version 3.11.2
    This application is licensed to you by its owner.
    Microsoft is not responsible for, nor does it grant any licenses to, third-party packages.
    Downloading https://www.python.org/ftp/python/3.11.2/python-3.11.2-amd64.exe
      ██████████████████████████████  24.1 MB / 24.1 MB
    Successfully verified installer hash
    Starting package install...
      \

    PS C:\Users\kleyfl> winget search Python.Python
    Name        Id                 Version   Source
    ------------------------------------------------
    Python 3    Python.Python.3.9  3.9.13    winget
    Python 3    Python.Python.3.8  3.8.10    winget
    Python 3    Python.Python.3.7  3.7.9     winget
    Python 3    Python.Python.3.6  3.6.8     winget
    Python 3    Python.Python.3.5  3.5.4     winget
    Python 3    Python.Python.3.4  3.4.4     winget
    Python 3    Python.Python.3.3  3.3.5     winget
    Python 3    Python.Python.3.2  3.2.5     winget
    Python 3    Python.Python.3.12 3.12.0a4  winget
    Python 3.11 Python.Python.3.11 3.11.2    winget
    Python 3.10 Python.Python.3.10 3.10.9    winget
    Python 3    Python.Python.3.1  3.1.4     winget
    Python 3    Python.Python.3.0  3.0.1     winget
    Python 2    Python.Python.2    2.7.18150 winget
    PS C:\Users\kleyfl> winget install Python.Python.3.11
    Found Python 3.11 [Python.Python.3.11] Version 3.11.2
    This application is licensed to you by its owner.
    Microsoft is not responsible for, nor does it grant any licenses to, third-party packages.
    Downloading https://www.python.org/ftp/python/3.11.2/python-3.11.2-amd64.exe
      ██████████████████████████████  24.1 MB / 24.1 MB
    Successfully verified installer hash
    Starting package install...
    Successfully installed
    PS C:\Users\kleyfl>

    C:\Users\kleyfl>"C:\Users\kleyfl\AppData\Local\Programs\Python\Python311\python.exe" -V
    Python 3.11.2


    (venv) C:\Users\kleyfl\Documents\winsrc\github.com\fl\settings>C:\Users\kleyfl\Documents\winsrc\github.com\fl\settings\venv\Scripts\python.exe -m pip install --upgrade pip
    Requirement already satisfied: pip in c:\users\kleyfl\documents\winsrc\github.com\fl\settings\venv\lib\site-packages (22.3.1)
    Collecting pip
      Using cached pip-23.0.1-py3-none-any.whl (2.1 MB)
    Installing collected packages: pip
      Attempting uninstall: pip
        Found existing installation: pip 22.3.1
        Uninstalling pip-22.3.1:
          Successfully uninstalled pip-22.3.1
    Successfully installed pip-23.0.1

    (venv) C:\Users\kleyfl\Documents\winsrc\github.com\fl\settings>pip install --upgrade wheel
    Requirement already satisfied: wheel in c:\users\kleyfl\documents\winsrc\github.com\fl\settings\venv\lib\site-packages (0.38.4)

    (venv) C:\Users\kleyfl\Documents\winsrc\github.com\fl\settings>pip install sphinx
    Collecting sphinx
      Using cached sphinx-6.1.3-py3-none-any.whl (3.0 MB)
    Collecting sphinxcontrib-applehelp
      Using cached sphinxcontrib_applehelp-1.0.4-py3-none-any.whl (120 kB)
    Collecting sphinxcontrib-devhelp
      Using cached sphinxcontrib_devhelp-1.0.2-py2.py3-none-any.whl (84 kB)
    Collecting sphinxcontrib-jsmath
      Using cached sphinxcontrib_jsmath-1.0.1-py2.py3-none-any.whl (5.1 kB)
    Collecting sphinxcontrib-htmlhelp>=2.0.0
      Using cached sphinxcontrib_htmlhelp-2.0.1-py3-none-any.whl (99 kB)
    Collecting sphinxcontrib-serializinghtml>=1.1.5
      Using cached sphinxcontrib_serializinghtml-1.1.5-py2.py3-none-any.whl (94 kB)
    Collecting sphinxcontrib-qthelp
      Using cached sphinxcontrib_qthelp-1.0.3-py2.py3-none-any.whl (90 kB)
    Collecting Jinja2>=3.0
      Using cached Jinja2-3.1.2-py3-none-any.whl (133 kB)
    Collecting Pygments>=2.13
      Using cached Pygments-2.14.0-py3-none-any.whl (1.1 MB)
    Collecting docutils<0.20,>=0.18
      Using cached docutils-0.19-py3-none-any.whl (570 kB)
    Collecting snowballstemmer>=2.0
      Using cached snowballstemmer-2.2.0-py2.py3-none-any.whl (93 kB)
    Collecting babel>=2.9
      Using cached Babel-2.11.0-py3-none-any.whl (9.5 MB)
    Collecting alabaster<0.8,>=0.7
      Using cached alabaster-0.7.13-py3-none-any.whl (13 kB)
    Collecting imagesize>=1.3
      Using cached imagesize-1.4.1-py2.py3-none-any.whl (8.8 kB)
    Collecting requests>=2.25.0
      Using cached requests-2.28.2-py3-none-any.whl (62 kB)
    Collecting packaging>=21.0
      Using cached packaging-23.0-py3-none-any.whl (42 kB)
    Collecting colorama>=0.4.5
      Using cached colorama-0.4.6-py2.py3-none-any.whl (25 kB)
    Collecting pytz>=2015.7
      Using cached pytz-2022.7.1-py2.py3-none-any.whl (499 kB)
    Collecting MarkupSafe>=2.0
      Downloading MarkupSafe-2.1.2-cp311-cp311-win_amd64.whl (16 kB)
    Collecting charset-normalizer<4,>=2
      Downloading charset_normalizer-3.0.1-cp311-cp311-win_amd64.whl (96 kB)
         ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 96.0/96.0 kB 1.8 MB/s eta 0:00:00
    Collecting idna<4,>=2.5
      Using cached idna-3.4-py3-none-any.whl (61 kB)
    Collecting urllib3<1.27,>=1.21.1
      Using cached urllib3-1.26.14-py2.py3-none-any.whl (140 kB)
    Collecting certifi>=2017.4.17
      Using cached certifi-2022.12.7-py3-none-any.whl (155 kB)
    Installing collected packages: snowballstemmer, pytz, charset-normalizer, urllib3, sphinxcontrib-serializinghtml, sphinxcontrib-qthelp, sphinxcontrib-jsmath, sphinxcontrib-htmlhelp, sphinxcontrib-devhelp, sphinxcontrib-applehelp, Pygments, packaging, MarkupSafe, imagesize, idna, docutils, colorama, certifi, babel, alabaster, requests, Jinja2, sphinx
    Successfully installed Jinja2-3.1.2 MarkupSafe-2.1.2 Pygments-2.14.0 alabaster-0.7.13 babel-2.11.0 certifi-2022.12.7 charset-normalizer-3.0.1 colorama-0.4.6 docutils-0.19 idna-3.4 imagesize-1.4.1 pack
    aging-23.0 pytz-2022.7.1 requests-2.28.2 snowballstemmer-2.2.0 sphinx-6.1.3 sphinxcontrib-applehelp-1.0.4 sphinxcontrib-devhelp-1.0.2 sphinxcontrib-htmlhelp-2.0.1 sphinxcontrib-jsmath-1.0.1 sphinxcontrib-qthelp-1.0.3 sphinxcontrib-serializinghtml-1.1.5 urllib3-1.26.14

    (venv) C:\Users\kleyfl\Documents\winsrc\github.com\fl\settings>

activate the venv with the activate script
