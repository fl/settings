# Minimal makefile for Sphinx documentation
#

# You can set these variables from the command line, and also
# from the environment for the first two.
SPHINXOPTS    ?=
SPHINXBUILD   ?= sphinx-build
SPHINXPROJ    = Settings
SOURCEDIR     = docs
BUILDDIR      = build

#PYTHON_VERSION = $(shell pyenv version --bare)
PYTHON_VERSION = $(shell cat .python-version)

# Put it first so that "make" without argument is like "make help".
help:
	@. .venv/bin/activate && $(SPHINXBUILD) -M help "$(SOURCEDIR)" "$(BUILDDIR)"

.PHONY: help

setup-venv:
	python$(PYTHON_VERSION) -m venv .venv
	.venv/bin/pip install --upgrade pip
	.venv/bin/pip install --upgrade wheel
	.venv/bin/pip install -r docs/requirements.txt

serve:
	sphinx-autobuild -b html $(SOURCEDIR) $(BUILDDIR)/html

# Catch-all target: route all unknown targets to Sphinx using the new
# "make mode" option.  $(O) is meant as a shortcut for $(SPHINXOPTS).
%: Makefile
	@. .venv/bin/activate && $(SPHINXBUILD) -M $@ "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)
