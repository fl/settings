# Configuration file for the Sphinx documentation builder.

# -- Project information

project = 'Settings'
copyright = ('Contributors to this project. "Noun Scroll 308110" by stefano corradetti licensed under CC BY 4.0.')
author = 'Florenz <fl@hacker-stueberl.de> et al.'

release = '1.0'
version = '1.0.0'
language = 'de'

# -- General configuration

extensions = [
    'sphinx_rtd_theme',
    'sphinx.ext.duration',
    'sphinx.ext.doctest',
    'sphinx.ext.autodoc',
    'sphinx.ext.autosummary',
    # 'sphinx.ext.intersphinx',
]

# intersphinx_mapping = {
#     'python': ('https://docs.python.org/3/', None),
#     'sphinx': ('https://www.sphinx-doc.org/en/master/', None),
# }
# intersphinx_disabled_domains = ['std']

templates_path = ['_templates']

# -- Options for HTML output

html_theme = 'sphinx_rtd_theme'
html_logo = 'scroll.svg'

# Sphinx RTD theme options. Docs at https://sphinx-rtd-theme.readthedocs.io/en/stable/index.html
html_theme_options = {
    'logo_only': False
    , 'display_version': True
    , 'prev_next_buttons_location': 'bottom'
    , 'style_external_links': True
    , 'vcs_pageview_mode': ''
    , 'style_nav_header_background': 'white'
    # Toc options
    , 'collapse_navigation': True
    , 'sticky_navigation': True
    , 'navigation_depth': 4
    , 'includehidden': True
    , 'titles_only': False
    # more misc. settings
    , 'html_baseurl': 'https://settings.readthedocs.io/'
    , ' language_selector': False
}

# -- Options for EPUB output
epub_show_urls = 'footnote'
