# Задачи домашнего задания 02

## 01_edge_and_pulse_detection

Напишите детектор однотактового сигнала (010).

Для формата вывода посмотрите
`$display` в файле `testbench.sv`.

![image](https://github.com/user-attachments/assets/b863bbe3-7da0-4523-a163-36ba5cb41e4d)

## 02_single_and_double_rate_fibonacci

Сделайте модуль, который генерирует 2 числа Фибоначчи за такт.

|этап  |num1             | num1                  | num3        |
|------|-----------------|-----------------------|-------------|
|1     | num1 = 1        |     num2 = 1          | num3  = 1   |
|2     |num1 = num3 = 1  |   num2 = num3+ num2 =2| num3 = num2+ num3<<2 = 3|
|3     | num1 = num3 = 3 |   num2 = num3+ num2 =5| num3 = num2+ num3<<2 = 8|
|3     | num1 = num3 = 8 |   num2 = num3+ num2 =13| num3 = num2+ num3<<2 = 21|


![image](https://github.com/user-attachments/assets/8f801461-2983-495d-b923-7adae95757b7)



## 03_serial_adder_using_logic_operations_only

Напишите последовательный сумматор, используя только операторы `^` (XOR), `|` (OR),
`&` (AND) и `~` (NOT).


|A|	B|	Cin |Cout	 |S|
|-|--|------|------|-|
|0|	0|	0	|0	     |0|
|0|	0|	1	|0	     |1|
|0|	1|	0	|0	     |1|
|0|	1|	1	|1	     |0|
|1|	0|	0	|0	     |1|
|1|	0|	1	|1	     |0|
|1|	1|	0	|1	     |0|
|1|	1|	1	|1	     |1|


Информацию про однобитный полный сумматор можно найти в книге Харрис и Харрис
или на [Википедии](https://en.wikipedia.org/wiki/Adder_(electronics)#Full_adder).

Для формата вывода посмотрите
`$display` в файле `testbench.sv`.

## 04_serial_adder_with_vld

Напишите модуль, реализующий последовательное сложение двух чисел (сложение
одной пары бит за такт). У модуля есть входы `a` и `b`, выход `sum`.
Также, у модуля есть контрольные сигналы `vld` и `last`.

Сигнал `vld` означает, что входные сигналы являются валидными. Сигнал `last`
означает, что получены последние биты чисел.

Когда `vld` в 1, модуль должен сложить `a` и `b` и выдать сумму `sum`.
Когда `last` в 1, модуль должен выдать сумму и сбросить свое состояние на
начальное, но только если сигнал `vld` тоже в 1, иначе `last` должен игнорироваться.

Когда `rst` в 1, модуль долен сбросить свое состояние на начальное.

## 05_serial_comparator_most_significant_first

Напишите модуль, который последовательно сравнивает 2 числа.

Входы модуля `a` и `b` - это биты от двух чисел, причем старшие биты идут первыми.
Выходы модуля `a_less_b`, `a_eq_b` и `a_greater_b` должны показывать отношение между
`a` и `b`.
Модуль также должен использовать входы `clk` и `rst`.

Для формата вывода посмотрите
`$display` в файле `testbench.sv`.

## 06_serial_comparator_most_significant_first_using_fsm

Напишите последовательный компаратор, аналогичный предыдущему упражнению, но
используя конечный автомат для определения выходов.
Старшие биты приходят первыми.

![image](https://github.com/user-attachments/assets/f0436ee2-513f-476e-887a-7997a62b1d52)

## 07_halve_tokens

Задание:
Реализуйте последовательный модуль, который вдвое сократит количество входящих токенов "1" (логических единиц).

Временная диаграмма:

![](../doc/homework2/02_07_01_halve_tokens.png)
![image](https://github.com/user-attachments/assets/2c348b55-8502-493c-a9f5-0322e7c4aea4)

## 08_double_tokens

Задание:
Реализуйте последовательный модуль, который удваивает каждый входящий токен "1" (логическую единицу).
Модуль должен обрабатывать удвоение как минимум для 200 токенов "1", поступающих подряд.

В случае, если модуль обнаруживает более 200 последовательных токенов "1", он должен выставить
флаг ошибки переполнения. Ошибка переполнения должна быть фиксированной (sticky). Как только ошибка появится,
единственный способ устранить ее - использовать сигнал сброса "rst".

Временная диаграмма:

![](../doc/homework2/02_08_01_double_tokens.png)


![image](https://github.com/user-attachments/assets/9009e4cb-d715-4b73-872a-8ba146b0e2c3)
![image](https://github.com/user-attachments/assets/17ab8a6f-6ba5-4db0-a07b-69f110726283)


## 09_round_robin_arbiter_with_2_requests

Задание:
Реализуйте модуль "арбитр", который принимает до двух запросов
и предоставляет разрешение на работу (grant) одному из них.

Модуль должен поддерживать внутренний реестр, который отслеживает,
кто из запрашивающих следующий в очереди на получение гранта.

Временная диаграмма:

![](../doc/homework2/02_09_01_rr_arbiter_2_req.png)

## 10_serial_to_parallel

Задание:
Реализуйте модуль, который преобразует последовательные данные
в параллельное многоразрядное значение.

Модуль должен принимать одноразрядные значения с "valid" интерфейсом последовательным образом.
После накопления битов ширины модуль должен выставить сигнал "parallel_valid"
и выставить данные.

Временная диаграмма:

![](../doc/homework2/02_10_01_serial_to_parallel.png)
