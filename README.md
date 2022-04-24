# Employee Time Management
## Документација

#### [Линк до проектот](https://github.com/darkoskerlevski/employee-time-management-flutter)

##### Автори: Виктор Пановски, Дарко Скерлевски.

#
Employee Time Management е апликација наменета за менаџирање на времето на вработените во една компанија. Лидерот на компанијата создава задачи и ги делигира помеѓу вработените, потоа вработените имаат целосен преглед над истите и можат да го запишат времето кога ја започнале/завршиле задачата и им се прикажува колку време ја извршувале задачата. Дополнително се зачувува и локацијата на која што е направена најавата од вработените.
Апликацијата е наменета за користење од компании со помал број на вработени. Помага со менањирањето на времето на вработените.

## Функционалности на апликацијата

- Креирање на корисничка сметка
- Креирање на работна околина за компанија
- Приклучување на работна околина на друга компанија
- Креирање на задачи во работната околина со дополнителни описи како: опис на задача, рок, степен на користење на телефонот за време на задачата, на кого е доделена задачата, бројач за време поминато на задачата, запис на локации каде е започната/завршена работа на задачата
- Уредување и бришење на задачи, како и дополнителна листа со избришани задачи


## Користени технологии

За да ја изградиме оваа апликација ги користевме наредните технологии:

- [Flutter](https://flutter.dev/) - open-source UI software development kit created by Google
- [Dart](https://dart.dev/) - programming language designed for client development
- [Android Studio](https://developer.android.com/studio) - official integrated development environment for Google's Android operating system
- [Firebase](https://firebase.google.com/) - platform developed by Google for creating mobile and web applications
- [Git](https://git-scm.com/) - software for tracking changes in any set of files, usually used for coordinating work among programmers collaboratively developing source code during software development
- [Github](https://github.com/) - rovider of Internet hosting for software development and version control using Git

## Installation

За да се изгради проектот потребно е да имате инсталирано [Flutter](https://flutter.dev/) претходно.

Зависно од оперативниот систем кој го имате има различни чекори кои треба да се следат
##### Windows
```sh
git clone https://github.com/flutter/flutter.git -b stable
```
Update your path
- From the Start search bar, enter ‘env’ and select Edit environment variables for your account.
- Under User variables check if there is an entry called Path:
- If the entry exists, append the full path to flutter\bin using ; as a separator from existing values.
- If the entry doesn’t exist, create a new user variable named Path with the full path to flutter\bin as its value.
- You have to close and reopen any existing console windows for these changes to take effect.

#### MacOS
```sh
cd ~/development
unzip ~/Downloads/flutter_macos_2.10.5-stable.zip
export PATH="$PATH:`pwd`/flutter/bin"
```
#### Linux
```sh
sudo snap install flutter --classic
flutter sdk-path
```

И потоа е потребно да го симнете изворниот код на апликацијата од [Github](https://github.com/darkoskerlevski/employee-time-management-flutter)

## Користени пакети

Employee Time Management ги користи следните пакети (библиотеки):

| Package | Link |
| ------ | ------ |
| flutter_bloc | https://pub.dev/packages/flutter_bloc |
| firebase_auth | https://pub.dev/packages/firebase_auth |
| firebase_core | https://pub.dev/packages/firebase_core |
| firebase_database | https://pub.dev/packages/firebase_database|
| uuid | https://pub.dev/packages/uuid |
| stop_watch_timer | https://pub.dev/packages/stop_watch_timer |
| wc_flutter_share | https://pub.dev/packages/wc_flutter_share |
| geolocator | https://pub.dev/packages/geolocator|
| persmission_handler | https://pub.dev/packages/permission_handler |
| sensors_plus | https://pub.dev/packages/sensors_plus |
| url_launcher | https://pub.dev/packages/url_launcher |
| flutter_launcher_icons | https://pub.dev/packages/flutter_launcher_icons |

## Карактеристики

Во овој дел ќе се опишат карактеристиките на апликацијата.

### Firebase и памтење на состојба

Нашата апликација го користи Firebase сервисот за да се овозможи автентикација на корисниците и чување на податоци.

### UI компоненти

Нашата компонента е картичика која што се користи за прикажување на секоја задача. Оваа картичка се користи за приказ на задачи на користинкот, за приказ на сите задачи и приказ на избришани задачи.

### Дизајн шаблони

Во нашата апликација користиме три шаблони на дизајн:
1. Factory - овој шаблон го користиме за креирање на различен вид објекти кои треба да се испратат на некој сервис од апликацијата.
2. Singleton - овој шаблон се користи за имплементација на сервисит во кои се содржи дел од бизнис логиката.
3. State Pattern - овој шаблон се користи во делот за мерење на време поминато на некоја задача. Состојбатата ни претставува дали стоперката е активна или не и во завистност од тоа се повикува соодветната фукнција при клик на копчето за стартување и стопирање на стоперката.

### Сензори

Нашата апликација користи два сензора.

1. Локациски сервис се користи за да се одреди локација каде една задача е започната или прекината да се работи. 
2. Жироскоп се користи за да се одреди колку корисникот го користел телефонот за време на изработка на една задача.

## Упатство за користење

При првото стартување на апликацијата од корисникот се бара тој да се најави со корисничка сметка, или да креира нова доколку нема веќе постоечка.
![Login Screen](https://i.imgur.com/i2TLTUQ.png)

По најавувањето, апликацијата има три главни екрани - My Tasks, All Tasks и Company. 
- Во 'My Tasks' екранот се прикажани сите задачи кои му се доделени на тековниот корисник. 
- Во 'All Tasks' екранот се прикажани сите задачи во компанијата
- Во 'Company' екранот корисникот може да креира нова компанија или да се приклучи на веќе постоечка

Секоја од задачите има копче за да се отвори задачата, при што се прикажуваат подетални информации за истата. Во деталите на задачата има стоперка која се користи за следење на времето потрошено на таа задача. Дополнително се води и сметка каде е започнато/прекинато мерењето на времето за задачата и се прикажуваат тие информации.

Во 'All Tasks' екранот во десниот горен дел има копче со кое се отвара екранот со избришани задачи и корисникот може да прегледа истите или да врати некоја од

На двата екрани за задачи во десниот долен ќош има копче со знак 'плус' во средината кое служи за креирање на нови задачи.

![My Tasks Screen](https://i.imgur.com/pPuTicV.png)

![Task Details Screen](https://i.imgur.com/ondNaRF.png)

![No Company Screen](https://i.imgur.com/32y3CZP.png)

![Company Screen](https://i.imgur.com/WZHq8zC.png)

## License

MIT