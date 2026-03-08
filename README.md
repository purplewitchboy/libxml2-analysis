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
2. Запустить автогенерацию
```c
./autogen.sh
```
3. Запуск самого анализа. Результаты сохранятся в директории /static-analysis/results
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
2. Запустить автогенерацию
```c
./autogen.sh
```
3. Сконфигурировать проект
```c
./configure
```
4. Собрать проект
```c
make -j$(nproc)
```
5. Запуск фаззинга, можно остановить через некоторое количество времени, тест идёт по seeds в директории /fuzzing/seeds
```c
afl-fuzz -i /fuzz/seeds \
         -o /fuzz/findings \
         -- ./xmllint @@
```
