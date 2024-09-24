FROM openjdk:17-slim

# Set environment variable to non-interactive mode to avoid user prompts
ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /root

# latex version
ARG pandoc_ver=3.3

# Install general dependencies
RUN apt-get -qq -y update
RUN apt-get -qq -y --no-install-recommends install \
    curl wget build-essential zip python3-pip jq git libfontconfig \
    locales software-properties-common imagemagick ca-certificates \
    dpkg r-base ghostscript doxygen mkdocs graphviz

# Install popular package bookdown and rmarkdown for document authoring
RUN Rscript -e "install.packages('rmarkdown',repos='https://cran.rstudio.com');install.packages('bookdown',repos='https://cran.rstudio.com')"

# Install ghostscript, pandoc extensions
RUN pip3 install --upgrade pip
RUN pip3 install pandoc-fignos pandoc-eqnos pandoc-tablenos pygments

# Download the latest version of pandoc and install it
RUN wget https://github.com/jgm/pandoc/releases/download/$pandoc_ver/pandoc-$pandoc_ver-1-amd64.deb -O pandoc.deb
RUN dpkg -i pandoc.deb && rm pandoc.deb

# Log what version of pandoc we're running on
RUN echo "pandoc version $(pandoc --version) running"

# Install latest TexLive
RUN wget http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz
RUN tar -zxvf install-tl-unx.tar.gz
COPY texlive.profile .
RUN install-*/install-tl --profile=texlive.profile
RUN rm -rf install-tl*

# Export useful texlive paths
ENV PATH /opt/texbin:$PATH
ENV PATH /usr/local/texlive/2020/bin/x86_64-linux:$PATH

# Update texlive and texlive manager to the absolute
RUN tlmgr update --self --all

# Test Latex
COPY examples/small2e.tex small2e.tex
RUN latex small2e.tex
RUN pdflatex small2e.tex
RUN xelatex small2e.tex

RUN rm -rf /var/lib/apt/lists/*
RUN rm -rf /root/*

# "jshell" is an interactive REPL for Java (see https://en.wikipedia.org/wiki/JShell)
CMD ["jshell"]