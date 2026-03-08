Должны быть установлены заранее:
docker
git
curl
wget
htop
make
tree
nano


Сборка контейнера для статического анализа:
cd static-analysis
docker build -t libxml2-clang-sa .


Запуск статического анализа:
1. Войти в контейнер
docker run --rm -it \
    -v $(pwd)/results:/results \
    libxml2-clang-sa
2. Запустить ./autogen.sh
3. scan-build --status-bugs \
    -o /results/scan-build-report \
    make -j$(nproc) 2>&1 | tee /results/scan-build.log


Сборка контейнера фаззинга:
cd ../fuzzing
docker build -t libxml2-afl .

Запуск фаззинга:
1. Войти в контейнер
   docker run --rm -it \
    -v $(pwd):/fuzz \
    libxml2-afl
2. ./autogen.sh
3. ./configure
4. make -j$(nproc)
5. afl-fuzz -i /fuzz/seeds \
         -o /fuzz/findings \
         -- ./xmllint @@
