# Take A a Note

<br/>

포모도로를 사용한 Todo 기록 앱

## 실행 및 소개 영상

[![이미지 텍스트](https://i.imgur.com/TpNDfa8.png)](https://youtu.be/-QwrMOPGrKk)

## 개발 스택

<br/>

![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)
![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)
![SQLite](https://img.shields.io/badge/sqlite-%2307405e.svg?style=for-the-badge&logo=sqlite&logoColor=white)
![Redux](https://img.shields.io/badge/redux-%23593d88.svg?style=for-the-badge&logo=redux&logoColor=white)

## 개요

<br/>

항상 하루를 보낸 후, **되돌아 볼 때 지난 시간에 무엇을 했는지에 대한 기억이 잘 나질 않았으며,** 매 시간 어떻게 보냈는지에 대한 기록이 없어 많이 아쉬웠습니다.

그래서 **할 투두 리스트로 할 일을 기록 한 후, 이 일을 몇시부터 몇시까지 했는지에 대한 기록이 있었으면 좋겠다는 생각을 하게되어 개발을 시작**하게 되었습니다.

부가가치로는 **내가 한 일과 수행했던 시간을 보며 잘 했다면 본인의 동기가 될 것이며, 오히려 잘 못했다면, 반성할 동기 또한 부여가 가능**할 것이라 생각했습니다.

## 설명

<br/>

크게 포모도로 타이머, 캘린더, 투두리스트, 셋팅 페이지 4개의 위젯이 있습니다.

각 위젯의 데이터의 request & response는 상태관리 라이브러리인 Provider를 통해 관리를 하였습니다.

1. **포모도로 ( 먼저 todoList에 있는 todo들을 보여준다. )**
    - 포모도로는 시간 관리 기법으로 타이머를 이용해서 25분간 집중해서 일을 한 다음 5분간 휴식과 타이머 수행 주기마다 긴 휴식시간을 갖는 방법론입니다.
    - 이 포모도로 타이머를 이용해, 타이머 시작시간, 끝난시간을 사이에 했던 todo와 함께 기록 한 후, 최종적으로 캘린더 위젯에서 보여주게 됩니다.
    - 타이며가 끝나면, 바텀 싯이 올라와, 직접 했던일을 적을 수 있는 기능과 todoList에서 입력한 할일을 선택할 수 있습니다.
2. **TodoList**
    - 투두리스트 위젯은 날짜별 할일을 적어 놓는 위젯입니다.
    - Todo는 해야 할 일을 모아두는 Box이고, Done은 했던 일을 모아두는 Box입니다. ⇒ 이렇게 나눔으로서 할일을 직관적으로 파악할 수 있습니다.
    - 각각의 todo들은 CRUD가 가능합니다.
        - 아래 Floating 버튼은 할일을 작성
        - todo 옆에 사이드 버튼을 누르면 수정 및 삭제가 가능합니다.
3. **캘린더**
    - 해당 날짜에 수행했던 일을 모아 볼 수 있는 위젯입니다.
    - Today 박스 안에 있는 todo에는 나의 todo와 몇시부터 몇시까지 했는지를 볼 수 있습니다.
4. **셋팅 위젯**
    - 포모도로 시간, 휴식 시간, 긴 휴식 시간 그리고 긴 휴식 시간을 가지려면, 포모도로 타이머를 몇번이나 수행할 것인지를 USER가 설정 할 수 있습니다.

## 느낀점

<br/>

- 삶에 있어 첫 개발이었기에 주먹구구식으로 했던 것이 조금 아쉽습니다.
- 그래도 그 과정에서 상태관리라든가 생명주기 등등 대한 공부를 할 수 있는 계기가 되어 매우 개인적으로 뜻깊은 앱이라고 생각이 됩니다.
