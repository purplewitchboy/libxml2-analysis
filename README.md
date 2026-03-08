Должны быть установлены заранее:
docker
git
curl
wget
htop
make
tree
nano

Задание выполнялось в VirtualBox, установлен образ miniU (Ubuntu 18.04 без графической оболочки).

Есть две дирректории, содержашие в себе Dockerfile и результаты анализа, названия директорий соответствуют статическому анализу и фаззингу. Версия тестируемой libxml2: 2.12.10, зафиксирована в Dockerfile.

Лог результатов статического анализа находится в файле /static-analysis/results/scan-build-report/2026-03-06-160453-5175-1/index.html и в /static-analysis/results/scan-build.log

Разметка 3 срабатываний находится в /static-analysis/results/static-analysis-markup.md


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
5. Запуск фаззинга, можно остановить через некоторое количество времени, тест идёт по seeds в директории /fuzzing/seeds. Исследуется исполняемый файл xmllint. Результаты попадут в /fuzzing/fidnings.
```c
afl-fuzz -i /fuzz/seeds \
         -o /fuzz/findings \
         -- ./xmllint @@
```
