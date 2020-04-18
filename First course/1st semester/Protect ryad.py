from math import *
# Вычисление суммы элементов заданного ряда с точнотью eps

x = float(input('Введите х: '))
eps = float(input('Введите точность(eps): '))
NMax = int(input('Введите количество итераций: '))
step = int(input('Введите шаг: '))

if  eps <= 0 or eps >= 1 or NMax <= 0 or step <=0:
    if NMax <=0:
        print('Количество итераций должно быть больше 0.')
    elif step <= 0:
        print('Шаг должен быть больше 0')
    elif eps <= 0 or eps >= 1:
        print('Точность должна быть от 0 до 1.')
else:
    # Вывод таблицы.
    print()
    print(u'\u250C' + u'\u2015'*16 + u'\u252C' + u'\u2015'*14 + u'\u252C' +
              u'\u2015'*19 + u'\u252C' + u'\u2015'*24 + u'\u2510')
    print(u'\u2502', 'Номер итерации', u'\u2502', '  Текущий x ', u'\u2502',
          'Текущий член ряда', u'\u2502', 'Текущee значение суммы', u'\u2502')

    t = 1
    N = s = 0
    while abs(t) > eps and N < NMax:
        if N % step == 0:
            print(u'\u251C' + u'\u2015' * 16 + u'\u253C' + u'\u2015' * 14 +
                  u'\u253C' + u'\u2015' * 19 + u'\u253C' + u'\u2015' * 24 +
                  u'\u2524')
            print(u'\u2502' + '{:^16}'.format(N+1) + u'\u2502', '{: 12.2g}'.
                  format(x**(N+1)) + ' ' + u'\u2502' + '{: 18.4g}'.format(t) +
                  ' ' + u'\u2502' + '{: 23.4g}'.format(s) + ' ' + u'\u2502')
        N += 1
        t =(x**N)*log(x)**N/factorial(N)
        s += t

    print(u'\u2514' + u'\u2015'*16 + u'\u2534' + u'\u2015'*14 + u'\u2534'
          + u'\u2015'*19 + u'\u2534' + u'\u2015'*24 + u'\u2518')
    print()

    if N >= NMax:
        print('Ряд не сошелся за', N, 'итераций.')
        print('Сумма ряда: ', '{:.5g}'.format(s-t))
    else:
        print('Сумма ряда: ', '{:.5g}'.format(s-t))

