# 0. Welcome
- [Course Website](https://cs61a.org/)
- [Textbook](https://www.composingprograms.com/)
- [Course Backup(2024 Spring)](https://www.learncs.site/docs/curriculum-resource/cs61a/syllabus)
- [Online Editor](https://code.cs61a.org/)

# Lab01
``` python
def how_big(x):
...     if x > 10:
...         print('huge')
...     elif x > 5:
...         return 'big'
...     if x > 0:
...         print('positive')
...     else:
...         print(0)

print(how_big(1), how_big(0))
```
这个问题卡了一会儿，仔细分析一下具体的运行过程。

先计算括号里面的 `how_big(1)` ，先打印 `positive` ，返回值是 `None`

然后计算括号里面的 `how_big(0)` ，先打印 `0` ，返回值是 `None`

最后计算表达式 `print(None, None)` ，所以打印 `None None`

# Homework02
``` python
def make_repeater(f, n):
    """Returns the function that computes the nth application of f.

    >>> add_three = make_repeater(increment, 3)
    >>> add_three(5)
    8
    >>> make_repeater(triple, 5)(1) # 3 * 3 * 3 * 3 * 3 * 1
    243
    >>> make_repeater(square, 2)(5) # square(square(5))
    625
    >>> make_repeater(square, 3)(5) # square(square(square(5)))
    390625
    """
    if n == 1:
        return f
    else:
        return lambda x: f(make_repeater(f, n-1)(x))
```
这是我写的重复调用的代码，这个递归可以运行，但是根据写斐波那契函数的经验，这样的开销是非常大的。

主要是一开始不知道怎么写 `f(f(?))` ，实际上很简单，看看参考代码的写法。对于这种情况，一般是在里面再定义一个假设已知变量 `x` 的函数，然后返回这个函数即可
``` py
def make_repeater(f, n):
    def repeater(x):
            k = 0
            while k < n:
                x, k = f(x), k + 1
            return x
        return repeater
```

# Homework03
如何使用匿名函数写递归？这个问题卡了很久。

首先一开始想到了要使用至少两个变量，但是因为对语法不熟悉，不知道后面可以直接接一个函数吸入，所以一直卡住

下面知道后面可以直接接一个函数吸入后，首先根据直觉确定我们的函数应该写成这样一个形式

`(lambda f: lambda x: ???)(lambda f, x: x if x == 1 else x*f(x-1))`

但是注意，吸入的函数是有两个变量的，修改一下使其满足语法条件

`(lambda f: lambda x: f(f,x))(lambda f, x: x if x == 1 else x*f(f,x-1))`

``` python
def make_anonymous_factorial():
    return (lambda f: lambda x: f(f,x))(lambda f,x: x if x == 1 else x*f(f,x-1))
```

还有另外一种实现方法，一开始写出来的代码是

`lambda f: lambda x: x if x == 1 else x*f(x-1)`

但是很明显，返回值不能有两重括号而只能有一重括号，因此这个函数肯定不是返回函数，里面的函数调用也不对，返回函数只能有一个括号，我们修改一下

`(lambda f: ???)(lambda f: lambda x: x if x == 1 else x*f(x-1))`

如何处理 `(lambda f: ???)` ？首先括号的函数是后面吸入的，而吸入的是个二重，而只有自己可以使用所以只能写成 `(lambda f: f(f))` 也就知道后面该怎么调用了

`(lambda f: f(f))(lambda f: lambda x: x if x == 1 else x*f(f)(x-1))`

# Discussion04

```python
def sums(n, m):
    """Return lists that sum to n containing positive numbers up to m that
    have no adjacent repeats.
    >>> sums(5, 1)
    []
    >>> sums(5, 2)
    [[2, 1, 2]]
    >>> sums(5, 3)
    [[1, 3, 1], [2, 1, 2], [2, 3], [3, 2]]
    >>> sums(5, 5)
    [[1, 3, 1], [1, 4], [2, 1, 2], [2, 3], [3, 2], [4, 1], [5]]
    >>> sums(6, 3)
    [[1, 2, 1, 2], [1, 2, 3], [1, 3, 2], [2, 1, 2, 1], [2, 1, 3], [2, 3, 1], [3, 1, 2],
    [3, 2, 1]]
    """
    if n < 0:
        return []
    if n == 0:
        sums_to_zero = []     # The only way to sum to zero using positives
        return [sums_to_zero] # Return a list of all the ways to sum to zero
    result = []
    for k in range(1, m + 1):
        result = result + [[k] + rest for rest in sums(n-k, m) if rest == [] or rest[0] != k]
    return result
```
这个就是当时上课的时候讲的那个切管子的题目（类似版？）。这里简单分析一下怎么做

首先题目要求是，给出所有可能的数组，使得 1. 数组总和为 `n` 2. 数组中的最大数字为 `m` 3. 数组中的相邻数不能重复

下面递归考虑问题：

1. 第一种基础情况是 `n == 0` ，此时已经取得了想要的结果，因此返回的是数组的数组 `[[]]` ，与最终结果的形式一致
2. 第二种情况是 `n < 0` ，此时切管子已经失败了，我们返回的结果应该是失败的，因此返回了一个不符合最终结果的值 `[]`
3. 最后是需要递归的情况，注意这是一个循环加递归的情况，因为我们的有很多个数可以选择，所以需要循环遍历，然后为了把所有的结果都得出来，使用一个总计量 `result` 记录结果

这里其实最重要的一步还是区分返回值的类型，我们最终要的是数组的数组，中间相加的时候用的是数组

# Lab04
## Lab04.1
``` python
def divide(quotients, divisors):
    """Return a dictonary in which each quotient q is a key for the list of
    divisors that it divides evenly.

    >>> divide([3, 4, 5], [8, 9, 10, 11, 12])
    {3: [9, 12], 4: [8, 12], 5: [10]}
    >>> divide(range(1, 5), range(20, 25))
    {1: [20, 21, 22, 23, 24], 2: [20, 22, 24], 3: [21, 24], 4: [20, 24]}
    """
    return {____: ____ for ____ in ____}
```
这里主要是语法不太熟悉，首先 `key` 肯定是遍历 `quotients` 的，先把除冒号后以外的项都填充完整

`return {key: ____ for key in quotients}`

接下来我们分析 `value` 是什么，根据要求这是一个 `list` 因此先把方括号写上

`return {key: [____] for key in quotients}`

方括号内就是对应要求的生成，这一步就很简单了

`return {k: [y for y in divisors if y % k == 0] for k in quotients}`

## Lab04.2
这几个递归的题目都值得总结一下
``` python
def buy(required_fruits, prices, total_amount):
    """Print ways to buy some of each fruit so that the sum of prices is amount.

    >>> prices = {'oranges': 4, 'apples': 3, 'bananas': 2, 'kiwis': 9}
    >>> buy(['apples', 'oranges', 'bananas'], prices, 12)
    [2 apples][1 orange][1 banana]
    >>> buy(['apples', 'oranges', 'bananas'], prices, 16)
    [2 apples][1 orange][3 bananas]
    [2 apples][2 oranges][1 banana]
    >>> buy(['apples', 'kiwis'], prices, 36)
    [3 apples][3 kiwis]
    [6 apples][2 kiwis]
    [9 apples][1 kiwi]
    """
    def add(fruits, amount, cart):
        if fruits == [] and amount == 0:
            print(cart)
        elif fruits and amount > 0:
            fruit = fruits[0]
            price = ____
            for k in ____:
                add(____, ____, ____)
    add(required_fruits, total_amount, '')

def display(fruit, count):
    """Display a count of a fruit in square brackets.

    >>> display('apples', 3)
    '[3 apples]'
    >>> display('apples', 1)
    '[1 apple]'
    """
    assert count >= 1 and fruit[-1] == 's'
    if count == 1:
        fruit = fruit[:-1]  # get rid of the plural s
    return '[' + str(count) + ' ' + fruit + ']'
```
怎么分析呢，先尝试分析出这几个函数和参数是什么意思

`fruits` 就是要购买的水果，而且这个肯定是要变的，买完一种就需要移除一种水果

`amount` 就是还要花掉的数额

`cart` 肯定是最后要打印的字符串，而且肯定要调用下面的函数 `display(fruit, count)`

先把能填的东西先填了

``` python
def add(fruits, amount, cart):
        if fruits == [] and amount == 0:
            print(cart)
        elif fruits and amount > 0:
            fruit = fruits[0]
            price = prices[fruit]
            for k in ____:
                add(____, ____, cart + display(fruit, ____))
    add(required_fruits, total_amount, '')
```

现在要考虑的是 `k` 是什么意思？看完上面已经根据感觉填出来的项，一下子就明白 `k` 是要填在 `display()` 函数里面的，表示这一个水果要买多少，那遍历是什么意思？就是当前我能买多少，因为至少买1，最多就是全买了，所以可以写出 `k` 的范围 `range(1, amount // price + 1)` 其他也就迎刃而解了

注意 `range(1, amount // price + 1)` 的 +1 因为根据要求 `amount // price` 是能够取到的，但是这么写语法上取不到，所以需要 +1 

``` python
def add(fruits, amount, cart):
        if fruits == [] and amount == 0:
            print(cart)
        elif fruits and amount > 0:
            fruit = fruits[0]
            price = prices[fruit]
            for k in range(1, amount // price + 1):
                add(fruits[1:], amount - k * price, cart + display(fruit, k))
    add(required_fruits, total_amount, '')
```

# Example: Partitions
``` python
def partitions(n,m):
    if n > 0 and m > 0:
        if n == m:
            yield str(m)
        for p in partitions(n-m, m):
            yield p + ' + ' + str(m)
        yield from partitions(n, m-1)
```
使用 python 的一些语言特性来写还是挺精致的，因为之前操作 list 会有许多格式需要注意，但是使用 `yield` 就不用考虑这些事情了，可以学习积累一下，之后也主动去使用一下看看

# Discussion08
``` python
def divide(n, d):
    """Return a linked list with a cycle containing the digits of n/d.

    >>> display(divide(5, 6))
    0.8333333333...
    >>> display(divide(2, 7))
    0.2857142857...
    >>> display(divide(1, 2500))
    0.0004000000...
    >>> display(divide(3, 11))
    0.2727272727...
    >>> display(divide(3, 99))
    0.0303030303...
    >>> display(divide(2, 31), 50)
    0.06451612903225806451612903225806451612903225806451...
    """
    assert n > 0 and n < d
    result = Link(0)  # The zero before the decimal point
    cache = {}
    tail = result
    while n not in cache:
        q, r = 10 * n // d, 10 * n % d
        tail.rest = Link(q)
        tail = tail.rest
        cache[n] = tail
        n = r
    tail.rest = cache[n]
    return result

def display(s, k=10):
    """Print the first k digits of infinite linked list s as a decimal.

    >>> s = Link(0, Link(8, Link(3)))
    >>> s.rest.rest.rest = s.rest.rest
    >>> display(s)
    0.8333333333...
    """
    assert s.first == 0, f'{s.first} is not 0'
    digits = f'{s.first}.'
    s = s.rest
    for _ in range(k):
        assert s.first >= 0 and s.first < 10, f'{s.first} is not a digit'
        digits += str(s.first)
        s = s.rest
    print(digits + '...')
```
求循环小数的代码，还是比较巧妙的，使用字典记录每一位数字出现的时候，其接下来的链表

当该数字再次出现的时候，让尾部接上来形成环，类似这样的效果

0\. 2 8 5 7 1 4 -> 2 （发现 2 再次出现之后，查找 2 对应的链表，接上来即可）

# Video13 Tracing

这里主要是是实现函数追溯的功能，其中有一个步骤没想明白，卡了比较久，直到使用 debug 功能看看到底 interpreters 怎么解释才搞明白。现在把这个追溯功能简单说一下

```scheme
(define fact (lambda (n)
    (if (zero? n) 1 (* n (fact (- n 1))))))

(define-macro (trace expr)
    (define operator (car expr))
`(begin
    (define original ,operator)
    (define ,operator (lambda (n)
                        (print (list (quote ,operator) n))
                        (original n)))
    (define result ,expr)
    (define ,operator original)
    result)
)
```
这其中没有理解的就是，是怎么反复递归调用的。

关键就是如下定义中，`fact` 被替换成 `operator` 后，注意里面的执行体还有一个 `fact` ，也就是 `operator` 会回来再一次调用 `fact` ，达到了反复调用的效果
``` scheme
(define fact (lambda (n)
    (if (zero? n) 1 (* n (fact (- n 1))))))
```
# Lab10

这次实验写得磕磕绊绊，需要好好总结一下！
``` python
def calc_eval(exp):
    if isinstance(exp, Pair):
        operator = exp.first # UPDATE THIS FOR Q2
        operands = exp.rest # UPDATE THIS FOR Q2
        if operator == 'and': # and expressions
            return eval_and(operands)
        elif operator == 'define': # define expressions
            return eval_define(operands)
        else: # Call expressions
            return calc_apply(calc_eval(operator), operands.map(calc_eval)) # UPDATE THIS FOR Q2
...
```
这一段卡了比较久，首先 `operator` 不能在第一行处理，因为下面的条件判断是字符串，所以只能在调用时处理，此时只有一个元素，所以直接调用函数

其次考虑 `operands`，一开始的时候没有对操作数进行取值处理而是直接传入，这肯定是不行的，因为 `calc_apply` 是直接调用操作符的计算函数，不可能再处理了。那么可不可以在前两行处理，不在调用计算函数时处理呢？也不行，因为下面有 `eval_and` 和 `eval_define` 的处理，这两个函数调用的是 `operands` ，而 `eval_and` 不需要在一开始就把所有操作数计算完的，而是读取一个计算一个，这个在下面的测试算例 `"1"` 就可以体现出来，所以只在后面应用时调用

``` python
def floor_div(args):
    result = args.first
    divisors = args.rest
    while divisors != nil:
        divisor = divisors.first
        result //= divisor
        divisors = divisors.rest
    return result
```
用递归用习惯了，其实**循环更直接**，而且下面求布尔值的时候，递归其实写错了！！！
``` python
def eval_and(expressions):
    if expressions == nil:
        return scheme_t
    elif expressions.rest == nil:
        return calc_eval(expressions.first)
    elif expressions.first is scheme_f:
        return scheme_f
    else:
        return eval_and(expressions.rest)
```
这里的递归写法只计算了最后一个表达式，中间的表达式根本没有计算值，所以如果中间出现一个表达式其实是 `false` 的话，结果是不对的！！！使用标准答案的结果进行了测试，验证了我的想法那应该怎么改呢？很简单，计算一下中间的表达式就行
``` python
def eval_and(expressions):
    if expressions == nil:
        return scheme_t
    elif expressions.rest == nil:
        return calc_eval(expressions.first)
    elif calc_eval(expressions.first) is scheme_f:
        return scheme_f
    else:
        return eval_and(expressions.rest)
```
另外关于 `define` 函数，实际上只有两个参数，所以可以直接取 `rest` 而不需要用 `map` ，所以题干不能只用翻译看，英语原文得自己仔细看一遍....

# Homework09
## Q1: Cooking Curry
这一段主要是不知道判断空链表，实际上判断是不是 `Pair` 就行了。

另外注意 `(,(car formals))` 外面的括号，为了与 `lambda` 表达式的定义形式相对应

``` scheme
(define (curry-cook formals body)
    (if (Pair? (cdr formals)) `(lambda (,(car formals)) ,(curry-cook (cdr formals) body))
        `(lambda ,formals ,body))
)
```
## Q2: Consuming Curry

终于做出来了，其实就是一开始想复杂了，以为需要自己再写一个新的链表结构去计算。实际上只需要每次调用一个参数就可以了，解释器会自动处理这个过程

一开始以为是字符形式的链表，于是一直尝试在链表后面接上参数，但是返回的结果却是 `#lambda` ，说明这里只能是函数（递归调用的形式也只能传入一个函数）。

那就换个思路，能不能直接把参数放进去。这里先不考虑会不会返回 `(lambda (z) (+ x (* y z)))` 这样已经吸收完参数的形式，先看能不能计算到最后的结果。

结果发现可以计算，再调试一下发现不用考虑重新写一个新的返回形式，可以直接通过了

``` scheme
(define (curry-consume curry args)
    (if (Pair? args)
        (curry-consume (curry (car args)) (cdr args))
        curry
    )
)
```

## Q3: Switch to Cond
``` scheme
(define-macro (switch expr options)
    (switch-to-cond (list 'switch expr options))
)

(define (switch-to-cond switch-expr)
  (cons 'cond
    (map
      (lambda (option) (cons (append `(equal? ,(car (cdr switch-expr))) (list (car option))) (cdr option)))
      (car (cdr (cdr switch-expr)))
    )
  )
)
```
这里的思路是当成字符串接的游戏，看看最终要达成什么样的结果
``` scheme
scm> (switch-to-cond `(switch (+ 1 1) ((1 2) (2 4) (3 6))))
(cond ((equal? (+ 1 1) 1) 2) 
      ((equal? (+ 1 1) 2) 4) 
      ((equal? (+ 1 1) 3) 6)
)
```
对比可以发现第一个空肯定就是 `'cond` 

再看看 `map` 做了什么，把第一个函数应用到第二个字符串的每一项上。而第二个字符串是什么，发现是就是所有的分支 `((1 2) (2 4) (3 6))` ，每一项就是一个分支。所以就是把每个分支的第一项与表达式形成一个判断，然后再接第二项作为结果就行，具体看上面的案例就很明白了

# Program04 Scheme
``` scheme
(define (enumerate s)
  (define (help idx ele)
      (if (null? ele) nil
          (cons (list idx (car ele)) (help (+ idx 1) (cdr ele))))
  )
  (help 0 s)
)
```
这里有一些钻牛角尖了，一定硬是要写一个不使用辅助函数的写法，实际上类似python加一个 `help` 就行了...

但是出现了另一个问题，使用 `web` 解释器可以通过检测，但是使用自己的解释器却不行，调试一下，看看到底是那里写错了

调试成功了，其实是 `scheme` 代码写错了，多对链表取了一层，`caar` 改成 `car` 就行了，`web` 解释器可能做了更加健壮的处理，这里就先不管了，就这样吧
``` scheme
(define (enumerate s)
  ; BEGIN PROBLEM 15
  (map (lambda (a) (list (+ (length s) (car a)) (car (cdr a)))) (help s))
)

(define (help s)
  (if (null? s) s
      (cons (list (- 0 (length s)) (car s)) (help (cdr s)))
  )
)
```

## tail-call optimization
这一部分的核心是，怎样识别尾递归，以及如何处理尾递归

下面这部分代码就是如何处理的示例
``` scheme
def thunk_factorial(n, so_far=1):
    def thunk():
        if n == 0:
            return so_far
        return thunk_factorial(n - 1, so_far * n)
    return thunk

def factorial(n):
    value = thunk_factorial(n)
    while callable(value): # While value is still a thunk
        value = value()
    return value
```
就是并不求值，而是把计算结果存在函数调用的参数里面，等到需要用的时候再计算就行了

理解了之后再看这部分怎么做，其实题目已经写得很清楚了
 
当需要尾递归优化的时候，直接把参数打包返回回去就行了。当不需要优化的时候，调用不优化版本的函数计算，注意此时中间的结果还是有可能出现可以尾递归优化，所以使用循环来反复计算，直到求出来的是值而不是打包参数

所以接下来只要判断哪些时候需要进行优化就可以了，题目里面说得很清楚了，当 `scheme_eval()` 就是这个函数得返回值的时候，就可以优化（因为所有求值的启动函数都是 `scheme_eval()` 开头），接下来找到这些函数，加上第三个参数 `True` 就可以了。稍微卡了一会儿的就是 `and` 和 `or` 这两个函数，当没有后续的时候是直接返回这个表达式的值的，这个时候是可以优化的，把原来的代码情况分得更加仔细一些就可以了