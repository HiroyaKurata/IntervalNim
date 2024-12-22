import system
import fenv
import math

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
