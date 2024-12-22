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