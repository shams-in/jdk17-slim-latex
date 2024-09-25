```
docker build . -t shamsin/jdk17-slim-latex:pandoc-3.3 --build-arg pandoc_ver=3.3
docker push shamsin/jdk17-slim-latex:pandoc-3.3

make shell
tlmgr info --list fontawesome

make pull
docker run --rm -v $(pwd):/usr/src/app -w /usr/src/app shamsin/jdk17-slim-latex xelatex examples/example.tex
```
