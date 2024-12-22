import system
import fenv
import math

proc add_up*(x, y: float64): float64 =
    var
        r {.volatile.} : float64
        x1 {.volatile.} : float64 = x
        y1 {.volatile.} : float64 = y
    r = x1 + y1
    move(r)

proc add_down*(x, y: float64): float64 =
    var
        r {.volatile.} : float64
        x1 {.volatile.} : float64 = -x
        y1 {.volatile.} : float64 = -y
    r = x1 + y1
    r = -r
    move(r)

proc sub_up*(x, y: float64): float64 =
    var
        r {.volatile.} : float64
        x1 {.volatile.} : float64 = x
        y1 {.volatile.} : float64 = y
    r = x1 - y1
    move(r)

proc sub_down*(x, y: float64): float64 =
    var
        r {.volatile.} : float64
        x1 {.volatile.} : float64 = -x
        y1 {.volatile.} : float64 = -y
    r = x1 - y1
    r = -r
    move(r)

proc mul_up*(x, y: float64): float64 =
    var
        r {.volatile.} : float64
        x1 {.volatile.} : float64 = x
        y1 {.volatile.} : float64 = y
    r = x1 * y1
    move(r)

proc mul_down*(x, y: float64): float64 =
    var
        r {.volatile.} : float64
        x1 {.volatile.} : float64 = -x
        y1 {.volatile.} : float64 = y
    r = x1 * y1
    r = -r
    move(r)

proc div_up*(x, y: float64): float64 =
    var
        r {.volatile.} : float64
        x1 {.volatile.} : float64 = x
        y1 {.volatile.} : float64 = y
    r = x1 / y1
    move(r)

proc div_down*(x, y: float64): float64 =
    var
        r {.volatile.} : float64
        x1 {.volatile.} : float64 = -x
        y1 {.volatile.} : float64 = y
    r = x1 / y1
    r = -r
    move(r)

proc sqrt_up*(x: float64): float64 =
    var
        r {.volatile.} : float64
        x1 {.volatile.} : float64 = x
    r = sqrt(x1)
    move(r)

proc sqrt_down*(x: float64): float64 =
    var
        r {.volatile.} : float64
        x1 {.volatile.} : float64 = x
    discard fesetround(FE_DOWNWARD)
    r = sqrt(x1)
    move(r)

proc interval_begin*(x: float64) =
    discard fesetround(FE_UPWARD)

proc interval_end*(x: float64) = 
    discard fesetround(FE_TONEAREST)

proc add_up*(x, y: float32): float32 =
    var
        r {.volatile.} : float32
        x1 {.volatile.} : float32 = x
        y1 {.volatile.} : float32 = y
    r = x1 + y1
    move(r)

proc add_down*(x, y: float32): float32 =
    var
        r {.volatile.} : float32
        x1 {.volatile.} : float32 = -x
        y1 {.volatile.} : float32 = -y
    r = x1 + y1
    r = -r
    move(r)

proc sub_up*(x, y: float32): float32 =
    var
        r {.volatile.} : float32
        x1 {.volatile.} : float32 = x
        y1 {.volatile.} : float32 = y
    r = x1 - y1
    move(r)

proc sub_down*(x, y: float32): float32 =
    var
        r {.volatile.} : float32
        x1 {.volatile.} : float32 = -x
        y1 {.volatile.} : float32 = -y
    r = x1 - y1
    r = -r
    move(r)

proc mul_up*(x, y: float32): float32 =
    var
        r {.volatile.} : float32
        x1 {.volatile.} : float32 = x
        y1 {.volatile.} : float32 = y
    r = x1 * y1
    move(r)

proc mul_down*(x, y: float32): float32 =
    var
        r {.volatile.} : float32
        x1 {.volatile.} : float32 = -x
        y1 {.volatile.} : float32 = y
    r = x1 * y1
    r = -r
    move(r)

proc div_up*(x, y: float32): float32 =
    var
        r {.volatile.} : float32
        x1 {.volatile.} : float32 = x
        y1 {.volatile.} : float32 = y
    r = x1 / y1
    move(r)

proc div_down*(x, y: float32): float32 =
    var
        r {.volatile.} : float32
        x1 {.volatile.} : float32 = -x
        y1 {.volatile.} : float32 = y
    r = x1 / y1
    r = -r
    move(r)

proc sqrt_up*(x: float32): float32 =
    var
        r {.volatile.} : float32
        x1 {.volatile.} : float32 = x
    r = sqrt(x1)
    move(r)

proc sqrt_down*(x: float32): float32 =
    var
        r {.volatile.} : float32
        x1 {.volatile.} : float32 = x
    discard fesetround(FE_DOWNWARD)
    r = sqrt(x1)
    move(r)

proc interval_begin*(x: float32) =
    discard fesetround(FE_UPWARD)

proc interval_end*(x: float32) = 
    discard fesetround(FE_TONEAREST)


type interval*[T] = ref object of RootObj
    inf : T
    sup : T

proc init*[T](self: interval; i, s: T) =
    if i <= s:
        self.inf = self.T(i)
        self.sup = self.T(s)
    else:
        self.inf = self.T(s)
        self.sup = self.T(i)

proc init*[T](self: interval; i: T) =
    self.inf = self.T(i)
    self.sup = self.T(i)

proc echo*(self: interval, a: varargs[interval]) =
    echo("[", self.inf, ",", self.sup, "]")
    for s in a:
        echo("[", s.inf, ",", s.sup, "]")

proc `+`* (a, b: interval): interval =
    var r = new interval

    interval_begin(a.inf)
    r.inf = add_down(a.inf, b.inf)
    r.sup = add_up(a.sup, b.sup)
    interval_end(a.inf)

    move(r)

proc `+`*[T] (a: interval, b: T): interval =
    var r = new interval

    interval_begin(a.inf)
    r.inf = add_down(a.inf, a.T(b))
    r.sup = add_up(a.sup, a.T(b))
    interval_end(a.inf)

    move(r)

proc `+`*[T] (a: T, b: interval): interval =
    var r = new interval

    interval_begin(b.inf)
    r.inf = add_down(b.T(a), b.inf)
    r.sup = add_up(b.T(a), b.sup)
    interval_end(b.inf)

    move(r)

proc `+=`* (a, b: var interval) =

    a = a + b

proc `+=`*[T] (a: var interval, b: T) =

    interval_begin(a.inf)
    a.inf = add_down(a.inf, a.T(b))
    a.sup = add_up(a.sup, a.T(b))
    interval_end(a.inf)


proc `-`* (a, b: interval): interval =
    var r = new interval

    interval_begin(a.inf)
    r.inf = sub_down(a.inf, b.sup)
    r.sup = sub_up(a.sup, b.inf)
    interval_end(a.inf)

    move(r)

proc `-`*[T] (a: interval, b: T): interval =
    var r = new interval

    interval_begin(a.inf)
    r.inf = sub_down(a.inf, a.T(b))
    r.sup = sub_up(a.sup, a.T(b))
    interval_end(a.inf)

    move(r)

proc `-`*[T] (a: T, b: interval): interval =
    var r = new interval

    interval_begin(b.inf)
    r.inf = sub_down(b.T(a), b.sup)
    r.sup = sub_up(b.T(a), b.inf)
    interval_end(b.inf)

    move(r)

proc `-=`* (a, b: var interval) =

    a = a - b

proc `-=`*[T] (a: var interval, b: T) =

    interval_begin(a.inf)
    a.inf = sub_down(a.inf, a.T(b))
    a.sup = sub_up(a.sup, a.T(b))
    interval_end(a.inf)


proc `-`* (a: interval): interval =
    var r = new interval
    r.sup = - a.inf
    r.inf = - a.sup
    move(r)

proc `*`* (a, b: interval): interval =
    var 
        r = new interval
        tmp : a.T

    interval_begin(a.inf)
    if a.inf >= 0:
        if a.sup == 0:
            r.init(0, 0)
        else:
            if b.inf >= 0:
                if b.sup == 0:
                    r.init(0, 0)
                else:
                    r.inf = mul_down(a.inf, b.inf)
                    r.sup = mul_up(a.sup, b.sup)
            elif b.sup <= 0:
                r.inf = mul_down(a.sup, b.inf)
                r.sup = mul_up(a.inf, b.sup)
            else:
                r.inf = mul_down(a.sup, b.inf)
                r.sup = mul_up(a.sup, b.sup)
    elif a.sup <= 0:
        if b.inf >= 0:
            if b.sup == 0:
                r.init(0, 0)
            else:
                r.inf = mul_down(a.inf, b.sup)
                r.sup = mul_up(a.sup, b.inf)
        elif b.sup <= 0:
            r.inf = mul_down(a.sup, b.sup)
            r.sup = mul_up(a.inf, b.inf)
        else:
            r.inf = mul_down(a.inf, b.sup)
            r.sup = mul_up(a.inf, b.inf)
    else:
        if b.inf >= 0:
            if b.sup == 0:
                r.init(0, 0)
            else:
                r.inf = mul_down(a.inf, b.sup)
                r.sup = mul_up(a.sup, b.sup)
        elif b.sup <= 0:
            r.inf = mul_down(a.sup, b.inf)
            r.sup = mul_up(a.inf, b.inf)
        else:
            r.inf = mul_down(a.inf, b.sup)
            tmp = mul_down(a.sup, b.inf)
            if tmp < r.inf:
                r.inf = tmp
            r.sup = mul_up(a.inf, b.inf)
            tmp = mul_up(a.sup, b.sup)
            if tmp > r.sup:
                r.sup = tmp
    interval_end(a.inf)

    move(r)

proc `*`*[T] (a: interval, b: T): interval =
    var r = new interval

    interval_begin(a.inf)
    if b > 0:
        r.inf = mul_down(a.inf, a.T(b))
        r.sup = mul_up(a.sup, a.T(b))
    elif b < 0:
        r.inf = mul_down(a.sup, a.T(b))
        r.sup = mul_up(a.inf, a.T(b))
    else:
        r.inf = 0
        r.sup = 0
    interval_end(a.inf)

    move(r)

proc `*`*[T] (a: T, b: interval): interval =
    var r = new interval

    interval_begin(b.inf)
    if a > 0:
        r.inf = mul_down(b.T(a), b.inf)
        r.sup = mul_up(b.T(a), b.sup)
    elif a < 0:
        r.inf = mul_down(b.T(a), b.sup)
        r.sup = mul_up(b.T(a), b.inf)
    else:
        r.inf = 0
        r.sup = 0
    interval_end(b.inf)

    move(r)

proc `*=`* (a, b: var interval) =

    a = a * b

proc `*=`*[T] (a: var interval, b: T) =

    a = a * b

proc `/`* (a, b: interval): interval =
    var r = new interval
    var e: ref ValueError

    interval_begin(a.inf)
    if b.inf > 0:
        if a.inf >= 0:
            r.inf = div_down(a.inf, b.sup)
            r.sup = div_up(a.sup, b.inf)
        elif a.sup <= 0:
            r.inf = div_down(a.inf, b.inf)
            r.sup = div_up(a.sup, b.sup)
        else:
            r.inf = div_down(a.inf, b.inf)
            r.sup = div_up(a.sup, b.inf)
    elif b.sup < 0:
        if a.inf >= 0:
            r.inf = div_down(a.sup, b.sup)
            r.sup = div_up(a.inf, b.inf)
        elif a.sup <= 0:
            r.inf = div_down(a.sup, b.inf)
            r.sup = div_up(a.inf, b.sup)
        else:
            r.inf = div_down(a.sup, b.sup)
            r.sup = div_up(a.inf, b.sup)
    else:
        interval_end(a.inf)
        new(e)
        e.msg = "interval: division by 0"
        raise e
    interval_end(a.inf)

    move(r)

proc `/`*[T] (a: interval, b: T): interval =
    var r = new interval
    var e: ref ValueError

    interval_begin(a.inf)
    if b > 0:
        r.inf = div_down(a.inf, a.T(b))
        r.sup = div_up(a.sup, a.T(b))
    elif b < 0:
        r.inf = div_down(a.sup, a.T(b))
        r.sup = div_up(a.inf, a.T(b))
    else:
        interval_end(a.inf)
        new(e)
        e.msg = "interval: division by 0"
        raise e
    interval_end(a.inf)
    
    move(r)

proc `/`*[T] (a: T, b: interval): interval =
    var r = new interval
    var e: ref ValueError

    interval_begin(b.inf)
    if b.inf > 0 and b.sup < 0:
        if a >= 0:
            r.inf = div_down(b.T(a), b.sup)
            r.sup = div_up(b.T(a), b.inf)
        else:
            r.inf = div_down(b.T(a), b.inf)
            r.sup = div_up(b.T(a), b.sup)
    else:
        interval_end(b.inf)
        new(e)
        e.msg = "interval: division by 0"
        raise e
    interval_end(b.inf)

    move(r)

proc `/=`* (a, b: var interval) =

    a = a / b

proc `/=`*[T] (a: var interval, b: T) =

    a = a / a.T(b)

proc sqrt* (a: interval ): interval =
    var r = new interval
    var e: ref ValueError

    if a.inf < 0:
        new(e)
        e.msg = "interval: sqrt of negative value"
        raise e

    interval_begin(a.inf)
    r.sup = sqrt_up(a.sup)
    r.inf = sqrt_down(a.inf)
    interval_end(a.inf)

    move(r)

template lower* (a: interval): untyped =
    a.addr.inf

template upper* (a: interval): untyped =
    a.addr.sup

proc hull* (a,b: interval): interval =
    var
        tmp1,tmp2: a.T
        r = new interval
    
    tmp1 = a.inf
    if b.inf < tmp1:
        tmp1 = b.inf
    tmp2 = a.sup
    if b.sup > tmp2:
        tmp2 = b.sup
    
    r.inf = tmp1
    r.sup = tmp2

    move(r)

proc hull*[T] (a: interval, b: T): interval =
    var
        tmp1,tmp2: a.T
        r = new interval
    
    tmp1 = a.inf
    if a.T(b) < tmp1:
        tmp1 = a.T(b)
    tmp2 = a.sup
    if a.T(b) > tmp2:
        tmp2 = a.T(b)
    
    r.inf = tmp1
    r.sup = tmp2

    move(r)

proc hull*[T] (a: T, b: interval): interval =
    var
        tmp1,tmp2: b.T
        r = new interval
    
    tmp1 = b.T(a)
    if b.inf < tmp1:
        tmp1 = b.inf
    tmp2 = b.T(a)
    if b.sup > tmp2:
        tmp2 = b.sup
    
    r.inf = tmp1
    r.sup = tmp2

    move(r)

proc hull*[T] (a,b: T): interval =
    var
        tmp1,tmp2: b.T
        r = new interval
    
    tmp1 = a
    if b < tmp1:
        tmp2 = tmp1
        tmp1 = b
    else:
        tmp2 = b
    
    r.inf = tmp1
    r.sup = tmp2

    move(r)

template width* (a: interval): untyped =
    var tmp: a.T

    interval_begin(a.inf)
    tmp = sub_up(a.sup, a.inf)
    interval_end(a.inf)

    tmp

template rad* (a: interval): untyped =
    var tmp: a.T

    interval_begin(a.inf)
    tmp = mul_up(sub_up(a.sup, a.inf), a.T(0.5))
    interval_end(a.inf)

    tmp

template mid* (a: interval): untyped =
    var tmp: a.T
    if abs(a.inf) > 1.0 and abs(a.sup) > 1.0:
        tmp = a.inf * 0.5 + a.sup * 0.5
    else:
        tmp = (a.inf + a.sup) * 0.5
    
    tmp

template median* (a: interval): untyped =
    mid(a)

proc midrad*[T] (a:interval, m, r:var T) =
    var tmp: a.T
    m = mid(a)
    interval_begin(a.inf)
    r = sub_up(a.sup, m)
    tmp = sub_up(m, a.inf)
    interval_end(a.inf)
    if tmp > r:
        r = tmp

template norm* (a: interval): untyped =    
    var tmp: a.T
    tmp = -a.inf
    if a.inf >= 0:
        tmp = a.sup
    elif a.sup <= 0:
        tmp = -a.inf
    elif a.sup > tmp:
        tmp = a.sup
    tmp

template mag* (a: interval): untyped =
    norm(a)

template mig* (a: interval): untyped =
    var tmp: a.T
    if a.inf <= 0 and 0 <= a.sup:
        tmp = a.T(0)
    elif a.inf > 0:
        tmp = a.inf
    else:
        tmp = -a.sup
    tmp

proc abs* (a: interval): interval =
    var
        r = new interval
        tmp: a.T
    if a.inf >= 0:
        r = a
    elif a.sup <= 0:
        r = -a
    else:
        tmp = -a.inf
        if a.sup > tmp:
            tmp = a.sup
        r.init(a.T(0), tmp)
    move(r)

proc `<`* (a,b: interval): bool =
    a.sup < b.inf

proc `<`*[T] (a: interval, b: T): bool =
    a.sup < a.T(b)

proc `<`*[T] (a: T, b: interval): bool =
    b.T(a) < b.inf

proc `<=`* (a,b: interval): bool =
    a.sup < b.inf

proc `<=`*[T] (a: interval, b: T): bool =
    a.sup < a.T(b)

proc `<=`*[T] (a: T, b: interval): bool =
    b.T(a) < b.inf

proc `>`* (a,b: interval): bool =
    a.inf > b.sup

proc `>`*[T] (a: interval, b: T): bool =
    a.inf > a.T(b)

proc `>`*[T] (a: T, b: interval): bool =
    b.T(a) > b.sup

proc `>=`* (a,b: interval): bool =
    a.inf > b.sup

proc `>=`*[T] (a: interval, b: T): bool =
    a.inf > a.T(b)

proc `>=`*[T] (a: T, b: interval): bool =
    b.T(a) > b.sup

proc `==`* (a,b: interval): bool =
    a.inf == a.sup and a.sup == b.inf and b.inf == b.sup

proc `==`*[T] (a: interval, b: T): bool =
    a.inf == a.sup and a.sup == a.T(b)

proc `==`*[T] (a: T, b: interval): bool =
    b.inf == b.sup and b.sup == b.T(a)

proc pow* (a: interval, b: int): interval =
    var r = new interval
    var x, i: int
    
    i = 1
    r = a
    x = abs(b)

    if b == 0:
        r.init(a.T(1.0)) 

    while i < x:
        r = r * a
        i += 1

    if b < 0:
        r = a.T(1.0) / r

    move(r)
