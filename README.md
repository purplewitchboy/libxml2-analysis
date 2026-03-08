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
```c
cd static-analysis
docker build -t libxml2-clang-sa .
```


Запуск статического анализа:
1. Войти в контейнер
```c
docker run --rm -it \
    -v $(pwd)/results:/results \
    libxml2-clang-sa
```
3. Запустить
   ```c
   ./autogen.sh
   ```
4.
```c
   scan-build --status-bugs \
    -o /results/scan-build-report \
    make -j$(nproc) 2>&1 | tee /results/scan-build.log
```

Сборка контейнера фаззинга:
```c
cd ../fuzzing
docker build -t libxml2-afl .
```

Запуск фаззинга:
1. Войти в контейнер
   ```c
   docker run --rm -it \
    -v $(pwd):/fuzz \
    libxml2-afl
   ```
2. ```c
    ./autogen.sh
   ```
4. 
```c
./configure
```
5.
```c
make -j$(nproc)
```
6.
```c
afl-fuzz -i /fuzz/seeds \
         -o /fuzz/findings \
         -- ./xmllint @@
```
